import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../services/iap_service.dart';
import '../services/premium_service.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  final IAPService _iapService = IAPService();
  final PremiumService _premiumService = PremiumService();

  bool _isPremium = false;
  bool _loading = true;
  String? _premiumType;
  int? _daysRemaining;
  DateTime? _expiryDate;
  bool _autoRenewing = true;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    setState(() => _loading = true);

    // Initialize IAP
    await _iapService.initialize();

    // Check premium status
    _isPremium = await _premiumService.isPremium();
    _premiumType = await _premiumService.getPremiumType();
    _daysRemaining = await _premiumService.getDaysRemaining();
    _expiryDate = await _premiumService.getExpiryDate();
    _autoRenewing = await _premiumService.isAutoRenewing();

    setState(() => _loading = false);
  }

  Future<void> _handlePurchase(ProductDetails product) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final success = await _iapService.purchaseProduct(product);

    if (!mounted) return;
    Navigator.pop(context); // Close loading

    if (success) {
      // Tunggu sebentar untuk pastikan purchase ter-process
      await Future.delayed(const Duration(milliseconds: 500));

      // Refresh status
      await _initializePage();

      if (!mounted) return;
      // Cek lagi apakah benar-benar premium sekarang
      final isPremium = await _premiumService.isPremium();

      if (isPremium) {
        _showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pembelian gagal diverifikasi'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      // Purchase failed atau dibatalkan
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pembelian dibatalkan atau gagal'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 12),
            Text('Selamat!'),
          ],
        ),
        content: const Text(
          'Anda sekarang adalah pengguna Premium! '
          'Nikmati semua fitur tanpa batas.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Close premium page
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRestore() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await _iapService.restorePurchases();
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.pop(context);

    // Check if premium was restored
    final isPremium = await _premiumService.isPremium();

    if (!mounted) return;
    if (isPremium) {
      await _initializePage();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pembelian berhasil dipulihkan!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada pembelian yang ditemukan')),
      );
    }
  }

  Future<void> _openSubscriptionManagement() async {
    // URL untuk membuka halaman subscription di Google Play
    final uri = Uri.parse(
      'https://play.google.com/store/account/subscriptions',
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka Google Play Store'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showCancelSubscriptionInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: const Text(
                'Cara Membatalkan Langganan',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Untuk membatalkan langganan, ikuti langkah berikut:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildStepItem('1', 'Buka aplikasi Google Play Store'),
              _buildStepItem('2', 'Tap ikon profil Anda di pojok kanan atas'),
              _buildStepItem('3', 'Pilih "Pembayaran & langganan"'),
              _buildStepItem('4', 'Pilih "Langganan"'),
              _buildStepItem('5', 'Pilih langganan Saku Muslim'),
              _buildStepItem('6', 'Tap "Batalkan langganan"'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Text(
                  'ℹ️ Catatan: Anda tetap bisa menggunakan fitur premium sampai akhir periode langganan yang sudah dibayar.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openSubscriptionManagement();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Buka Play Store'),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium'),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 🧪 Debug banner
                if (PremiumService.debugPremiumMode)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: Colors.orange.shade100,
                    child: Row(
                      children: [
                        Icon(Icons.bug_report, color: Colors.orange.shade900),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '🧪 DEBUG MODE: Premium aktif otomatis untuk testing',
                            style: TextStyle(
                              color: Colors.orange.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(child: _buildContent()),
              ],
            ),
    );
  }

  Widget _buildContent() {
    return _isPremium ? _buildPremiumActiveView() : _buildPremiumOffersView();
  }

  Widget _buildPremiumActiveView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Premium badge
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade400, Colors.amber.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.verified, size: 80, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  'Anda Pengguna Premium!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _premiumType == 'lifetime'
                      ? 'Akses Selamanya'
                      : _daysRemaining != null
                      ? '$_daysRemaining hari tersisa'
                      : 'Aktif',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Subscription management (jika subscription, bukan lifetime)
          if (_premiumType == 'subscription') ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Langganan Aktif',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _autoRenewing
                        ? 'Langganan Anda akan diperpanjang otomatis. '
                              'Anda bisa membatalkan kapan saja dari Google Play Store.'
                        : 'Langganan Anda telah dibatalkan. Anda tetap bisa menggunakan fitur premium sampai masa aktif berakhir.',
                    style: TextStyle(
                      fontSize: 13,
                      color: _autoRenewing
                          ? Colors.grey.shade700
                          : Colors.orange.shade900,
                      fontWeight: _autoRenewing
                          ? FontWeight.normal
                          : FontWeight.w600,
                    ),
                  ),
                  if (_daysRemaining != null && _expiryDate != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _autoRenewing ? Icons.refresh : Icons.event_busy,
                          size: 16,
                          color: _autoRenewing
                              ? Colors.blue.shade700
                              : Colors.orange.shade700,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _autoRenewing ? 'Perpanjangan:' : 'Aktif sampai:',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('d MMMM yyyy', 'id_ID').format(_expiryDate!),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _autoRenewing
                            ? Colors.blue.shade900
                            : Colors.orange.shade900,
                      ),
                    ),
                    Text(
                      '($_daysRemaining hari lagi)',
                      style: TextStyle(
                        fontSize: 12,
                        color: _autoRenewing
                            ? Colors.blue.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ],
                  if (!_autoRenewing) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Ingin lanjut premium? Anda bisa berlangganan lagi kapan saja.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _openSubscriptionManagement,
                          icon: const Icon(Icons.settings, size: 18),
                          label: const Text('Kelola Langganan'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue.shade700,
                            side: BorderSide(color: Colors.blue.shade700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: _showCancelSubscriptionInfo,
                          icon: const Icon(Icons.help_outline, size: 18),
                          label: const Text('Cara Batalkan'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Premium features
          const Text(
            'Fitur Premium Aktif',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _buildFeatureItem(
            icon: Icons.audiotrack,
            title: 'Audio Al-Qur\'an Offline',
            description: 'Download dan dengarkan tanpa internet',
          ),
          _buildFeatureItem(
            icon: Icons.dark_mode,
            title: 'Tema Dark Mode',
            description: 'Nyaman di mata, hemat baterai',
          ),
          _buildFeatureItem(
            icon: Icons.palette,
            title: 'Custom Colors',
            description: 'Pilih warna tema sesuai selera',
          ),
          _buildFeatureItem(
            icon: Icons.bookmarks,
            title: 'Bookmark Unlimited',
            description: 'Simpan ayat favorit tanpa batas',
          ),
          _buildFeatureItem(
            icon: Icons.mosque,
            title: 'Masjid Terdekat',
            description: 'Temukan masjid di sekitar lokasi Anda',
          ),
          _buildFeatureItem(
            icon: Icons.calculate,
            title: 'Kalkulator Zakat',
            description: 'Hitung zakat fitrah dan mal dengan mudah',
          ),
          _buildFeatureItem(
            icon: Icons.download,
            title: 'Export/Import Data',
            description: 'Backup dan restore data Anda',
          ),
          _buildFeatureItem(
            icon: Icons.widgets,
            title: 'Widget Custom',
            description: 'Personalisasi tampilan home screen',
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumOffersView() {
    final lifetimeProduct = _iapService.getProduct(
      IAPService.premiumLifetimeId,
    );
    final monthlyProduct = _iapService.getProduct(IAPService.premiumMonthlyId);
    final yearlyProduct = _iapService.getProduct(IAPService.premiumYearlyId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const Icon(Icons.workspace_premium, size: 80, color: Colors.amber),
          const SizedBox(height: 16),
          const Text(
            'Upgrade ke Premium',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Nikmati fitur lengkap tanpa batas',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 30),

          // Features list
          const Text(
            'Apa yang Anda Dapatkan:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _buildFeatureItem(
            icon: Icons.audiotrack,
            title: 'Audio Offline',
            description: 'Download audio Al-Qur\'an',
          ),
          _buildFeatureItem(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            description: 'Tema gelap yang nyaman',
          ),
          _buildFeatureItem(
            icon: Icons.palette,
            title: 'Custom Colors',
            description: '8 pilihan warna tema',
          ),
          _buildFeatureItem(
            icon: Icons.bookmarks,
            title: 'Unlimited Bookmarks',
            description: 'Simpan ayat tanpa batas',
          ),
          _buildFeatureItem(
            icon: Icons.mosque,
            title: 'Masjid Terdekat',
            description: 'Temukan masjid terdekat',
          ),
          _buildFeatureItem(
            icon: Icons.calculate,
            title: 'Kalkulator Zakat',
            description: 'Hitung zakat Anda',
          ),
          _buildFeatureItem(
            icon: Icons.cloud_upload,
            title: 'Backup Data',
            description: 'Export/Import data',
          ),

          const SizedBox(height: 30),

          // Purchase options
          const Text(
            'Pilih Paket:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Yearly (Best Value)
          if (yearlyProduct != null)
            _buildPurchaseCard(
              product: yearlyProduct,
              title: 'Tahunan',
              subtitle: 'Hemat 40%',
              isPopular: true,
              onTap: () => _handlePurchase(yearlyProduct),
            ),

          const SizedBox(height: 12),

          // Monthly
          if (monthlyProduct != null)
            _buildPurchaseCard(
              product: monthlyProduct,
              title: 'Bulanan',
              subtitle: 'Berlangganan fleksibel',
              onTap: () => _handlePurchase(monthlyProduct),
            ),

          const SizedBox(height: 12),

          // Lifetime (Best Value)
          if (lifetimeProduct != null)
            _buildPurchaseCard(
              product: lifetimeProduct,
              title: 'Selamanya',
              subtitle: 'Sekali bayar, akses selamanya',
              isPopular: true,
              color: Colors.amber,
              onTap: () => _handlePurchase(lifetimeProduct),
            ),

          const SizedBox(height: 20),

          // Restore purchases button
          TextButton.icon(
            onPressed: _handleRestore,
            icon: const Icon(Icons.restore),
            label: const Text('Pulihkan Pembelian'),
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
          ),

          const SizedBox(height: 8),

          // Terms
          Text(
            'Pembayaran akan ditagihkan ke akun Google Play Anda. '
            'Langganan diperpanjang otomatis kecuali dibatalkan.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.green.shade700, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseCard({
    required ProductDetails product,
    required String title,
    required String subtitle,
    bool isPopular = false,
    Color? color,
    required VoidCallback onTap,
  }) {
    final cardColor = color ?? Colors.green;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isPopular ? cardColor : Colors.grey.shade300,
              width: isPopular ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
            color: isPopular ? cardColor.withOpacity(0.05) : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isPopular ? cardColor : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _iapService.formatPrice(product),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isPopular ? cardColor : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isPopular)
          Positioned(
            top: 0,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: const Text(
                'TERPOPULER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
