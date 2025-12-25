import 'package:flutter/material.dart';
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
      await _dbHelper.saveSurahsCache(
        surahs.map((s) => s.toMap()).toList()
      );
      
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
      await _dbHelper.saveSurahsCache(
        surahs.map((s) => s.toMap()).toList()
      );
      
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
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
