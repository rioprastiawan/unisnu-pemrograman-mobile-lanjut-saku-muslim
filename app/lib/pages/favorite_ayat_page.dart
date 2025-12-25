import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../services/database_helper.dart';
import 'surah_detail_page.dart';

class FavoriteAyatPage extends StatefulWidget {
  const FavoriteAyatPage({super.key});

  @override
  State<FavoriteAyatPage> createState() => _FavoriteAyatPageState();
}

class _FavoriteAyatPageState extends State<FavoriteAyatPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _favoriteAyat = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteAyat();
  }

  Future<void> _loadFavoriteAyat() async {
    setState(() {
      _isLoading = true;
    });

    final favorites = await _dbHelper.getAllFavoriteAyat();

    setState(() {
      _favoriteAyat = favorites;
      _isLoading = false;
    });
  }

  Future<void> _removeFavorite(Map<String, dynamic> ayat) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus dari Favorit?'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${ayat['surah_name']} ayat ${ayat['ayat_number']} dari favorit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _dbHelper.removeFavoriteAyat(
        ayat['surah_number'],
        ayat['ayat_number'],
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dihapus dari favorit'),
            behavior: SnackBarBehavior.floating,
          ),
        );

        _loadFavoriteAyat();
      }
    }
  }

  Future<void> _clearAllFavorites() async {
    if (_favoriteAyat.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua Favorit?'),
        content: Text(
          'Apakah Anda yakin ingin menghapus semua ${_favoriteAyat.length} ayat dari favorit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _dbHelper.clearAllFavoriteAyat();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Semua favorit telah dihapus'),
            behavior: SnackBarBehavior.floating,
          ),
        );

        _loadFavoriteAyat();
      }
    }
  }

  void _showFavoriteAyatContextMenu(BuildContext context, Map<String, dynamic> ayat) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '${ayat['surah_name']} : ${ayat['ayat_number']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
            // Menu items
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.pink),
              title: const Text('Hapus dari Favorit'),
              onTap: () {
                Navigator.pop(context);
                _removeFavorite(ayat);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_add),
              title: const Text('Tandai sebagai Terakhir Dibaca'),
              onTap: () async {
                Navigator.pop(context);
                await _dbHelper.saveLastReadQuran(
                  surahNumber: ayat['surah_number'],
                  surahName: ayat['surah_name'],
                  ayatNumber: ayat['ayat_number'],
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.bookmark, color: Colors.white),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Ditandai: ${ayat['surah_name']} ayat ${ayat['ayat_number']}',
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.green.shade700,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Salin Teks Arab'),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(text: ayat['ayat_text_arab']));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Teks Arab disalin'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Salin Terjemahan'),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(text: ayat['ayat_text_indonesia']));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Terjemahan disalin'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Bagikan Ayat'),
              onTap: () {
                Navigator.pop(context);
                final shareText = '''📖 QS. ${ayat['surah_name']} : ${ayat['ayat_number']}

${ayat['ayat_text_arab']}

${ayat['ayat_text_latin']}

"${ayat['ayat_text_indonesia']}"

━━━━━━━━━━━━━━━━━━
🕌 Dibagikan dari Saku Muslim''';
                Share.share(shareText);
              },
            ),
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: const Text('Buka Surah'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurahDetailPage(
                      nomorSurah: ayat['surah_number'],
                      namaSurah: ayat['surah_name'],
                      scrollToAyat: ayat['ayat_number'],
                    ),
                  ),
                ).then((_) => _loadFavoriteAyat());
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayat Favorit'),
        backgroundColor: Colors.pink.shade600,
        foregroundColor: Colors.white,
        actions: [
          if (_favoriteAyat.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAllFavorites,
              tooltip: 'Hapus Semua',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_favoriteAyat.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada ayat favorit',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap icon ❤️ di ayat untuk menambahkan favorit',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFavoriteAyat,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _favoriteAyat.length,
        itemBuilder: (context, index) {
          return _buildFavoriteCard(_favoriteAyat[index]);
        },
      ),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> ayat) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurahDetailPage(
                nomorSurah: ayat['surah_number'],
                namaSurah: ayat['surah_name'],
                scrollToAyat: ayat['ayat_number'],
              ),
            ),
          ).then((_) => _loadFavoriteAyat());
        },
        onLongPress: () => _showFavoriteAyatContextMenu(context, ayat),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink.shade600, Colors.pink.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${ayat['surah_name']} : ${ayat['ayat_number']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Long-press hint
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.pink.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app,
                          size: 14,
                          color: Colors.pink.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Tahan lama',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.pink.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Arabic text
              Text(
                ayat['ayat_text_arab'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  height: 2,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 12),

              // Latin transliteration
              Text(
                ayat['ayat_text_latin'],
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),

              // Indonesian translation
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.pink.shade200),
                ),
                child: Text(
                  ayat['ayat_text_indonesia'],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade800,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 8),

              // Tap to navigate hint
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Tap untuk buka surah',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: Colors.grey.shade400,
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
