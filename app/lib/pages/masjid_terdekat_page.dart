import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/mosque.dart';
import '../services/location_service.dart';
import '../services/mosque_service.dart';
import '../services/premium_service.dart';
import '../widgets/premium_widgets.dart';
import 'premium_page.dart';

/// Halaman Masjid Terdekat (Premium Feature)
class MasjidTerdekatPage extends StatefulWidget {
  const MasjidTerdekatPage({super.key});

  @override
  State<MasjidTerdekatPage> createState() => _MasjidTerdekatPageState();
}

class _MasjidTerdekatPageState extends State<MasjidTerdekatPage> {
  final LocationService _locationService = LocationService();
  final MosqueService _mosqueService = MosqueService();
  final PremiumService _premiumService = PremiumService();

  bool _isPremium = false;
  bool _loading = true;
  Position? _currentPosition;
  List<Mosque> _nearbyMosques = [];

  @override
  void initState() {
    super.initState();
    _checkPremiumAndLoad();
  }

  Future<void> _checkPremiumAndLoad() async {
    setState(() => _loading = true);

    _isPremium = await _premiumService.isPremium();

    if (_isPremium) {
      // Load mosques data from CSV if not already loaded
      await _mosqueService.loadMosquesData();
      await _loadNearbyMosques();
    }

    setState(() => _loading = false);
  }

  Future<void> _loadNearbyMosques() async {
    try {
      // Get current location
      _currentPosition = await _locationService.getCurrentLocation();

      if (_currentPosition == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat mengakses lokasi. Periksa izin lokasi.'),
          ),
        );
        return;
      }

      // Get nearby mosques from database
      _nearbyMosques = await _mosqueService.getNearbyMosques(
        userLat: _currentPosition!.latitude,
        userLon: _currentPosition!.longitude,
        city: 'Semarang', // atau deteksi otomatis dari geocoding
        limit: 50,
      );

      setState(() {});
    } catch (e) {
      debugPrint('Error loading mosques: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    }
  }

  Future<void> _openMaps(double lat, double lng, String name) async {
    // Try geo URI first (native for Android)
    final geoUri = Uri.parse('geo:$lat,$lng?q=$lat,$lng(${Uri.encodeComponent(name)})');
    
    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
      return;
    }

    // Fallback to Google Maps web URL
    final webUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tidak dapat membuka maps')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masjid Terdekat'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          if (_isPremium)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadNearbyMosques,
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !_isPremium
          ? _buildNonPremiumView()
          : _buildMosquesList(),
    );
  }

  Widget _buildNonPremiumView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: PremiumLockWidget(
          featureName: 'Masjid Terdekat',
          description:
              'Temukan masjid di sekitar lokasi Anda dengan mudah. '
              'Dapatkan informasi lengkap dan navigasi langsung. '
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

  Widget _buildMosquesList() {
    if (_nearbyMosques.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mosque, size: 80, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text(
                'Tidak Ada Masjid Ditemukan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Coba pindahkan lokasi atau refresh ulang',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadNearbyMosques,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNearbyMosques,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _nearbyMosques.length,
        itemBuilder: (context, index) {
          final mosque = _nearbyMosques[index];
          return _buildMosqueCard(mosque);
        },
      ),
    );
  }

  Widget _buildMosqueCard(Mosque mosque) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _openMaps(mosque.latitude, mosque.longitude, mosque.name);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.mosque,
                      color: Colors.green.shade700,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mosque.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (mosque.address != null && mosque.address!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            mosque.address!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (mosque.distance != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _mosqueService.formatDistance(mosque.distance),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    mosque.city,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      _openMaps(mosque.latitude, mosque.longitude, mosque.name);
                    },
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text('Navigasi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
