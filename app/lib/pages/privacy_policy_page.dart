import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kebijakan Privasi'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Kebijakan Privasi Saku Muslim',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Terakhir diperbarui: 25 Desember 2025',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 24),

          _buildSection(
            '1. Informasi yang Kami Kumpulkan',
            'Saku Muslim mengumpulkan dan menyimpan informasi berikut secara lokal di perangkat Anda:',
            [
              'Lokasi GPS untuk menentukan jadwal sholat dan arah kiblat',
              'Preferensi notifikasi untuk pengingat sholat',
              'Bookmark dan ayat favorit yang Anda simpan',
              'Riwayat bacaan Al-Qur\'an',
              'Pengaturan aplikasi (tema, notifikasi, dll)',
            ],
          ),

          _buildSection(
            '2. Bagaimana Kami Menggunakan Informasi',
            'Informasi yang dikumpulkan digunakan untuk:',
            [
              'Menampilkan jadwal sholat yang akurat berdasarkan lokasi Anda',
              'Menentukan arah kiblat dengan kompas',
              'Menyimpan progress dan preferensi bacaan Anda',
              'Mengirimkan notifikasi pengingat sholat',
              'Meningkatkan pengalaman pengguna aplikasi',
            ],
          ),

          _buildSection(
            '3. Penyimpanan Data',
            'Semua data disimpan secara lokal di perangkat Anda menggunakan SQLite database dan Shared Preferences. '
            'Kami TIDAK mengirim data Anda ke server eksternal atau pihak ketiga.',
            null,
          ),

          _buildSection(
            '4. Keamanan Data',
            'Kami berkomitmen untuk melindungi data Anda:',
            [
              'Data disimpan lokal di perangkat Anda',
              'Tidak ada transmisi data ke server',
              'Anda dapat menghapus semua data kapan saja dengan uninstall aplikasi',
            ],
          ),

          _buildSection(
            '5. Izin Aplikasi',
            'Aplikasi ini meminta izin berikut:',
            [
              'Lokasi (GPS): Untuk jadwal sholat dan arah kiblat',
              'Penyimpanan: Untuk cache data Al-Qur\'an (offline mode)',
              'Notifikasi: Untuk pengingat waktu sholat',
              'Internet: Untuk download data Al-Qur\'an dan audio',
            ],
          ),

          _buildSection(
            '6. Layanan Pihak Ketiga',
            'Aplikasi ini menggunakan API eksternal untuk data:',
            [
              'API Al-Qur\'an dari equran.id (teks dan audio)',
              'API Jadwal Sholat dari myquran.org',
              'Data ini di-cache secara lokal untuk offline access',
            ],
          ),

          _buildSection(
            '7. Data Anak-Anak',
            'Aplikasi ini aman untuk semua umur. Kami tidak mengumpulkan informasi pribadi dari anak-anak secara khusus.',
            null,
          ),

          _buildSection(
            '8. Perubahan Kebijakan',
            'Kami dapat memperbarui kebijakan privasi ini dari waktu ke waktu. Perubahan akan ditampilkan di halaman ini dengan tanggal "Terakhir diperbarui" yang baru.',
            null,
          ),

          _buildSection(
            '9. Hak Anda',
            'Anda memiliki hak untuk:',
            [
              'Menolak izin lokasi (dengan konsekuensi fitur tertentu tidak dapat digunakan)',
              'Menghapus semua data dengan uninstall aplikasi',
              'Menonaktifkan notifikasi dari pengaturan perangkat',
            ],
          ),

          _buildSection(
            '10. Kontak',
            'Jika Anda memiliki pertanyaan tentang kebijakan privasi ini, silakan hubungi kami melalui:',
            [
              'Email: support@sakumuslim.app (placeholder)',
              'Atau melalui fitur Feedback di aplikasi',
            ],
          ),

          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              children: [
                Icon(Icons.verified_user, color: Colors.green.shade700, size: 40),
                const SizedBox(height: 12),
                Text(
                  'Privasi Anda adalah Prioritas Kami',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Semua data Anda tersimpan lokal di perangkat dan tidak dibagikan dengan pihak manapun.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String description, List<String>? bulletPoints) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.6,
            ),
          ),
          if (bulletPoints != null) ...[
            const SizedBox(height: 8),
            ...bulletPoints.map((point) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }
}
