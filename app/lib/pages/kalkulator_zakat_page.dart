import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/premium_service.dart';
import '../widgets/premium_widgets.dart';
import 'premium_page.dart';

/// Halaman Kalkulator Zakat (Premium Feature)
class KalkulatorZakatPage extends StatefulWidget {
  const KalkulatorZakatPage({super.key});

  @override
  State<KalkulatorZakatPage> createState() => _KalkulatorZakatPageState();
}

class _KalkulatorZakatPageState extends State<KalkulatorZakatPage>
    with SingleTickerProviderStateMixin {
  final PremiumService _premiumService = PremiumService();
  late TabController _tabController;

  bool _isPremium = false;
  bool _loading = true;

  // Zakat Fitrah
  final _hargaBerasController = TextEditingController();
  int _jumlahJiwa = 1;
  double _zakatFitrah = 0;

  // Zakat Mal (Harta)
  final _hartaController = TextEditingController();
  final _utangController = TextEditingController();
  double _zakatMal = 0;
  bool _wajibZakatMal = false;

  // Constants
  static const double nishabEmas = 85; // gram
  static const double hargaEmasPerGram = 1000000; // Rp per gram (estimasi)
  static const double tarifZakat = 0.025; // 2.5%
  static const double berasPerOrang = 2.5; // kg

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkPremiumStatus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _hargaBerasController.dispose();
    _hartaController.dispose();
    _utangController.dispose();
    super.dispose();
  }

  Future<void> _checkPremiumStatus() async {
    setState(() => _loading = true);
    _isPremium = await _premiumService.isPremium();
    setState(() => _loading = false);
  }

  void _hitungZakatFitrah() {
    final hargaBeras = double.tryParse(_hargaBerasController.text) ?? 0;

    if (hargaBeras <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan harga beras yang valid')),
      );
      return;
    }

    setState(() {
      _zakatFitrah = hargaBeras * berasPerOrang * _jumlahJiwa;
    });

    _showResultDialog(
      'Hasil Zakat Fitrah',
      'Jumlah jiwa: $_jumlahJiwa orang\n'
          'Beras per orang: $berasPerOrang kg\n'
          'Harga beras: Rp ${_formatNumber(hargaBeras)}/kg\n\n'
          'Total Zakat Fitrah:\nRp ${_formatNumber(_zakatFitrah)}',
    );
  }

  void _hitungZakatMal() {
    final harta = double.tryParse(_hartaController.text) ?? 0;
    final utang = double.tryParse(_utangController.text) ?? 0;

    if (harta <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan jumlah harta yang valid')),
      );
      return;
    }

    final hartaBersih = harta - utang;
    final nishab = nishabEmas * hargaEmasPerGram;

    setState(() {
      _wajibZakatMal = hartaBersih >= nishab;
      _zakatMal = _wajibZakatMal ? hartaBersih * tarifZakat : 0;
    });

    _showResultDialog(
      'Hasil Zakat Mal',
      'Total Harta: Rp ${_formatNumber(harta)}\n'
          'Hutang/Cicilan: Rp ${_formatNumber(utang)}\n'
          'Harta Bersih: Rp ${_formatNumber(hartaBersih)}\n\n'
          'Nishab ($nishabEmas gram emas):\nRp ${_formatNumber(nishab)}\n\n'
          '${_wajibZakatMal ? 'Status: WAJIB ZAKAT ✅\n\nTotal Zakat Mal (2.5%):\nRp ${_formatNumber(_zakatMal)}' : 'Status: BELUM WAJIB ZAKAT\n\nHarta Anda belum mencapai nishab'}',
    );
  }

  void _showResultDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double number) {
    return number
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Zakat'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        bottom: _isPremium
            ? TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(text: 'Zakat Fitrah'),
                  Tab(text: 'Zakat Mal'),
                ],
              )
            : null,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !_isPremium
          ? _buildNonPremiumView()
          : TabBarView(
              controller: _tabController,
              children: [_buildZakatFitrahTab(), _buildZakatMalTab()],
            ),
    );
  }

  Widget _buildNonPremiumView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: PremiumLockWidget(
          featureName: 'Kalkulator Zakat',
          description:
              'Hitung zakat fitrah dan zakat mal dengan mudah. '
              'Lengkap dengan panduan dan referensi nishab terbaru. '
              'Fitur ini hanya tersedia untuk pengguna premium.',
          onUnlock: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PremiumPage()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildZakatFitrahTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade50, Colors.orange.shade100],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    const Text(
                      'Tentang Zakat Fitrah',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Zakat fitrah adalah zakat yang wajib dikeluarkan oleh setiap muslim '
                  'pada bulan Ramadhan. Besarnya $berasPerOrang kg beras atau makanan pokok per orang.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Input harga beras
          TextField(
            controller: _hargaBerasController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Harga Beras per Kg',
              prefixText: 'Rp ',
              suffixIcon: const Icon(Icons.agriculture),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),

          const SizedBox(height: 20),

          // Jumlah jiwa
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jumlah Jiwa',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_jumlahJiwa > 1) {
                          setState(() => _jumlahJiwa--);
                        }
                      },
                      icon: const Icon(Icons.remove_circle),
                      color: Colors.orange,
                      iconSize: 36,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade300),
                      ),
                      child: Text(
                        '$_jumlahJiwa',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => _jumlahJiwa++);
                      },
                      icon: const Icon(Icons.add_circle),
                      color: Colors.orange,
                      iconSize: 36,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Button hitung
          ElevatedButton(
            onPressed: _hitungZakatFitrah,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Hitung Zakat Fitrah',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZakatMalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade50, Colors.orange.shade100],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    const Text(
                      'Tentang Zakat Mal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Zakat mal adalah zakat yang dikenakan atas harta yang dimiliki selama 1 tahun (haul). '
                  'Nishab: $nishabEmas gram emas. Tarif: 2.5%',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Input total harta
          TextField(
            controller: _hartaController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Total Harta (Tabungan, Investasi, dll)',
              prefixText: 'Rp ',
              suffixIcon: const Icon(Icons.account_balance_wallet),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),

          const SizedBox(height: 16),

          // Input hutang
          TextField(
            controller: _utangController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Hutang/Cicilan yang Harus Dibayar',
              prefixText: 'Rp ',
              suffixIcon: const Icon(Icons.credit_card),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),

          const SizedBox(height: 16),

          // Info nishab
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.diamond, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Nishab: Rp ${_formatNumber(nishabEmas * hargaEmasPerGram)} '
                    '($nishabEmas gram emas)',
                    style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Button hitung
          ElevatedButton(
            onPressed: _hitungZakatMal,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Hitung Zakat Mal',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
