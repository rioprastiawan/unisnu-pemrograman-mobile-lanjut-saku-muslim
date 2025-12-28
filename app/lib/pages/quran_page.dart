import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/surah.dart';
import '../services/quran_api_service.dart';
import '../services/database_helper.dart';
import 'surah_detail_page.dart';
import 'favorite_ayat_page.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  final QuranApiService _quranApiService = QuranApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Surah> _surahs = [];
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _lastRead;
  int _favoriteCount = 0;

  @override
  void initState() {
    super.initState();
    _loadSurahs();
    _loadLastRead();
    _loadFavoriteCount();
  }

  Future<void> _loadLastRead() async {
    final lastRead = await _dbHelper.getLastReadQuran();
    setState(() {
      _lastRead = lastRead;
    });
  }

  Future<void> _loadFavoriteCount() async {
    final count = await _dbHelper.getFavoriteAyatCount();
    setState(() {
      _favoriteCount = count;
    });
  }

  void _showSurahContextMenu(BuildContext context, Surah surah) {
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
                surah.namaLatin,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
            // Menu items
            ListTile(
              leading: const Icon(Icons.bookmark_add),
              title: const Text('Tandai sebagai Terakhir Dibaca'),
              subtitle: const Text('Simpan posisi baca Anda'),
              onTap: () async {
                Navigator.pop(context);
                await _dbHelper.saveLastReadQuran(
                  surahNumber: surah.nomor,
                  surahName: surah.namaLatin,
                  ayatNumber: 1,
                );
                await _loadLastRead();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.bookmark, color: Colors.white),
                          const SizedBox(width: 12),
                          Expanded(child: Text('Ditandai: ${surah.namaLatin}')),
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
              leading: const Icon(Icons.info_outline),
              title: const Text('Info Surah'),
              subtitle: const Text('Lihat detail surah'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Row(
                      children: [
                        Text(surah.namaLatin),
                        const Spacer(),
                        Text(
                          surah.nama,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          surah.arti,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('Nomor', surah.nomor.toString()),
                        _buildInfoRow('Tempat Turun', surah.tempatTurun),
                        _buildInfoRow(
                          'Jumlah Ayat',
                          '${surah.jumlahAyat} ayat',
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SurahDetailPage(
                                nomorSurah: surah.nomor,
                                namaSurah: surah.namaLatin,
                              ),
                            ),
                          ).then((_) {
                            _loadLastRead();
                            _loadFavoriteCount();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                        ),
                        child: const Text('Buka Surah'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Salin Info Surah'),
              subtitle: const Text('Salin nama dan detail surah'),
              onTap: () {
                Navigator.pop(context);
                final surahInfo =
                    '''📖 ${surah.namaLatin} (${surah.nama})
${surah.arti}

Nomor: ${surah.nomor}
Tempat Turun: ${surah.tempatTurun}
Jumlah Ayat: ${surah.jumlahAyat}

━━━━━━━━━━━━━━━━━━
🕌 Saku Muslim''';
                Clipboard.setData(ClipboardData(text: surahInfo));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Info surah disalin'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Bagikan Surah'),
              subtitle: const Text('Bagikan info surah ke teman'),
              onTap: () {
                Navigator.pop(context);
                final shareText =
                    '''📖 ${surah.namaLatin} (${surah.nama})
"${surah.arti}"

Nomor: ${surah.nomor}
Tempat Turun: ${surah.tempatTurun}
Jumlah Ayat: ${surah.jumlahAyat}

Baca lengkap di Saku Muslim
━━━━━━━━━━━━━━━━━━
🕌 Aplikasi Muslim Lengkap''';
                Share.share(shareText);
              },
            ),
            ListTile(
              leading: Icon(Icons.book, color: Colors.green.shade700),
              title: const Text('Buka Surah'),
              subtitle: const Text('Baca surah lengkap'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurahDetailPage(
                      nomorSurah: surah.nomor,
                      namaSurah: surah.namaLatin,
                    ),
                  ),
                ).then((_) {
                  _loadLastRead();
                  _loadFavoriteCount();
                });
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _loadSurahs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Try to load from cache first
      final cachedSurahs = await _dbHelper.getAllSurahsCache();

      if (cachedSurahs.isNotEmpty) {
        // Load from cache
        setState(() {
          _surahs = cachedSurahs.map((map) => Surah.fromMap(map)).toList();
          _isLoading = false;
        });

        // Check if cache is stale and refresh in background
        final isStale = await _dbHelper.isSurahCacheStale(maxAgeDays: 30);
        if (isStale) {
          _refreshSurahsInBackground();
        }
      } else {
        // No cache, fetch from API
        await _fetchAndCacheSurahs();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data surah: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAndCacheSurahs() async {
    try {
      final surahs = await _quranApiService.fetchAllSurahs();

      // Save to cache
      await _dbHelper.saveSurahsCache(surahs.map((s) => s.toMap()).toList());

      setState(() {
        _surahs = surahs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data surah: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshSurahsInBackground() async {
    try {
      final surahs = await _quranApiService.fetchAllSurahs();
      await _dbHelper.saveSurahsCache(surahs.map((s) => s.toMap()).toList());

      if (mounted) {
        setState(() {
          _surahs = surahs;
        });
      }
    } catch (e) {
      // Silent fail for background refresh
      debugPrint('Background refresh failed: $e');
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchAndCacheSurahs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Qur\'an'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Favorite button with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoriteAyatPage(),
                    ),
                  ).then((_) {
                    _loadFavoriteCount();
                  });
                },
                tooltip: 'Ayat Favorit',
              ),
              if (_favoriteCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade600,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      _favoriteCount > 99 ? '99+' : _favoriteCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _lastRead != null
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurahDetailPage(
                      nomorSurah: _lastRead!['surah_number'],
                      namaSurah: _lastRead!['surah_name'],
                      scrollToAyat: _lastRead!['ayat_number'],
                    ),
                  ),
                ).then((_) => _loadLastRead());
              },
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.bookmark),
              label: const Text('Terakhir Dibaca'),
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSurahs,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _surahs.length,
        itemBuilder: (context, index) {
          return _buildSurahCard(_surahs[index]);
        },
      ),
    );
  }

  Widget _buildSurahCard(Surah surah) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to surah detail page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurahDetailPage(
                nomorSurah: surah.nomor,
                namaSurah: surah.namaLatin,
              ),
            ),
          ).then((_) {
            _loadLastRead();
            _loadFavoriteCount();
          });
        },
        onLongPress: () => _showSurahContextMenu(context, surah),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Nomor surah badge
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  // color: Colors.green.shade700,
                  gradient: LinearGradient(
                    colors: [Colors.green.shade700, Colors.green.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    surah.nomor.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info surah
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.namaLatin,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${surah.arti} • ${surah.jumlahAyat} Ayat',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: surah.tempatTurun.toLowerCase() == 'mekah'
                                ? Colors.amber.shade100
                                : Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            surah.tempatTurun,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: surah.tempatTurun.toLowerCase() == 'mekah'
                                  ? Colors.amber.shade900
                                  : Colors.blue.shade900,
                            ),
                          ),
                        ),
                        if (surah.nomor == 1)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.touch_app,
                                  size: 10,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Tahan lama',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Nama Arab
              Text(
                surah.nama,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
