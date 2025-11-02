import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../services/qibla_service.dart';

class QiblaCompass extends StatefulWidget {
  final double userLatitude;
  final double userLongitude;
  final String cityName;

  const QiblaCompass({
    super.key,
    required this.userLatitude,
    required this.userLongitude,
    required this.cityName,
  });

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  double? _heading;
  double? _qiblaDirection;
  double? _distanceToKaaba;
  bool _hasPermission = true;

  @override
  void initState() {
    super.initState();
    _calculateQiblaDirection();
    _initCompass();
  }

  void _calculateQiblaDirection() {
    setState(() {
      _qiblaDirection = QiblaService.calculateQiblaDirection(
        widget.userLatitude,
        widget.userLongitude,
      );
      _distanceToKaaba = QiblaService.calculateDistanceToKaaba(
        widget.userLatitude,
        widget.userLongitude,
      );
    });
  }

  void _initCompass() {
    FlutterCompass.events?.listen((CompassEvent event) {
      if (mounted) {
        setState(() {
          _heading = event.heading;
        });
      }
    }).onError((error) {
      setState(() {
        _hasPermission = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return _buildPermissionError();
    }

    if (_heading == null || _qiblaDirection == null) {
      return _buildLoading();
    }

    return _buildCompass();
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.green.shade700,
          ),
          const SizedBox(height: 16),
          const Text(
            'Menginisialisasi kompas...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.orange.shade700,
            ),
            const SizedBox(height: 16),
            const Text(
              'Sensor Kompas Tidak Tersedia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Perangkat Anda tidak mendukung sensor kompas atau izin ditolak.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompass() {
    // Hitung sudut rotasi kompas (berlawanan arah heading)
    // Kompas berputar berlawanan arah dengan rotasi HP
    final double compassAngle = -(_heading! * pi / 180);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Header
            Text(
              'Arah Kiblat',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.cityName,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),

            // Kompas
            SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Kompas Rose + Ka'bah Icon (BERPUTAR bersama)
                  Transform.rotate(
                    angle: compassAngle,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Lingkaran kompas
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.shade200.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: CustomPaint(
                            painter: CompassPainter(),
                          ),
                        ),
                        
                        // Ikon Ka'bah di posisi derajat kiblat (ikut berputar)
                        Transform.rotate(
                          angle: _qiblaDirection! * pi / 180,
                          child: Transform.translate(
                            offset: const Offset(0, -115), // Posisi di tepi kompas
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade700,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.shade700.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.mosque,
                                size: 28,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Panah indikator FIXED di atas (menunjuk arah depan HP)
                  Positioned(
                    top: -10,
                    child: Icon(
                      Icons.arrow_drop_up,
                      size: 60,
                      color: Colors.red.shade700,
                    ),
                  ),

                  // Titik tengah
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Info
            _buildInfoCard(
              icon: Icons.explore,
              label: 'Arah Kiblat',
              value: '${_qiblaDirection!.toStringAsFixed(1)}°',
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.mosque,
              label: 'Jarak ke Ka\'bah',
              value: QiblaService.formatDistance(_distanceToKaaba!),
            ),

            const SizedBox(height: 24),

            // Instruksi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Putar HP hingga ikon Ka\'bah sejajar dengan panah merah di atas',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.green.shade700,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter untuk menggambar kompas
class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = min(centerX, centerY);

    // Gambar lingkaran luar
    final Paint circlePaint = Paint()
      ..color = Colors.green.shade50
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), radius, circlePaint);

    // Gambar garis derajat
    final Paint linePaint = Paint()
      ..color = Colors.green.shade200
      ..strokeWidth = 1;

    for (int i = 0; i < 360; i += 30) {
      final double angle = i * pi / 180;
      final double x1 = centerX + (radius - 20) * sin(angle);
      final double y1 = centerY - (radius - 20) * cos(angle);
      final double x2 = centerX + radius * sin(angle);
      final double y2 = centerY - radius * cos(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
    }

    // Gambar huruf arah mata angin (Bahasa Indonesia)
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // U (Utara) - merah dan besar untuk highlight
    textPainter.text = TextSpan(
      text: 'U',
      style: TextStyle(
        color: Colors.red.shade700,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, 8),
    );

    // S (Selatan)
    textPainter.text = TextSpan(
      text: 'S',
      style: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, size.height - 35),
    );

    // T (Timur)
    textPainter.text = TextSpan(
      text: 'T',
      style: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width - 30, centerY - textPainter.height / 2),
    );

    // B (Barat)
    textPainter.text = TextSpan(
      text: 'B',
      style: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(10, centerY - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
