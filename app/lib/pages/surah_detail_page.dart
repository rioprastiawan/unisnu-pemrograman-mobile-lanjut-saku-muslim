import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/ayat.dart';
import '../services/quran_api_service.dart';
import '../services/database_helper.dart';
import '../services/quran_audio_service.dart';

class SurahDetailPage extends StatefulWidget {
  final int nomorSurah;
  final String namaSurah;

  const SurahDetailPage({
    super.key,
    required this.nomorSurah,
    required this.namaSurah,
  });

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  final QuranApiService _quranApiService = QuranApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final QuranAudioService _audioService = QuranAudioService();

  SurahDetail? _surahDetail;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isDescriptionExpanded = false;
  PlayerState _playerState = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    _loadSurahDetail();
    
    // Listen to player state changes
    _audioService.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _playerState = state;
        });
      }
    });
    
    // Listen to audio completion
    _audioService.audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _playerState = PlayerState.stopped;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _loadSurahDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Try to load from cache first
      final cachedDetail = await _dbHelper.getSurahDetailCache(widget.nomorSurah);

      if (cachedDetail != null) {
        // Load from cache
        setState(() {
          _surahDetail = SurahDetail.fromJson(cachedDetail['detail_data']);
          _isLoading = false;
        });

        // Check if cache is stale and refresh in background
        final isStale = await _dbHelper.isSurahDetailCacheStale(
          widget.nomorSurah,
          maxAgeDays: 30,
        );
        if (isStale) {
          _refreshSurahDetailInBackground();
        }
      } else {
        // No cache, fetch from API
        await _fetchAndCacheSurahDetail();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat detail surah: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAndCacheSurahDetail() async {
    try {
      final detail = await _quranApiService.fetchSurahDetail(widget.nomorSurah);

      // Save to cache
      await _dbHelper.saveSurahDetailCache(
        widget.nomorSurah,
        detail.toJson(),
      );

      setState(() {
        _surahDetail = detail;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat detail surah: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshSurahDetailInBackground() async {
    try {
      final detail = await _quranApiService.fetchSurahDetail(widget.nomorSurah);
      await _dbHelper.saveSurahDetailCache(
        widget.nomorSurah,
        detail.toJson(),
      );

      if (mounted) {
        setState(() {
          _surahDetail = detail;
        });
      }
    } catch (e) {
      // Silent fail for background refresh
      debugPrint('Background refresh failed: $e');
    }
  }

  String _stripHtmlTags(String htmlString) {
    // Simple HTML tag remover
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
  
  Future<void> _handleAudioButtonPressed(String audioUrl, int ayatNumber) async {
    try {
      final isPlaying = _audioService.isAyatPlaying(ayatNumber);
      
      if (isPlaying && _playerState == PlayerState.playing) {
        // Pause if currently playing
        await _audioService.pause();
      } else if (isPlaying && _playerState == PlayerState.paused) {
        // Resume if paused
        await _audioService.resume();
      } else {
        // Play new ayat
        await _audioService.playAyat(audioUrl, ayatNumber);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memutar audio: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _handleFullSurahButtonPressed(String audioFullUrl) async {
    try {
      final isPlayingFullSurah = _audioService.currentPlayingAyatNumber == -1;
      
      if (isPlayingFullSurah && _playerState == PlayerState.playing) {
        // Pause if currently playing
        await _audioService.pause();
      } else if (isPlayingFullSurah && _playerState == PlayerState.paused) {
        // Resume if paused
        await _audioService.resume();
      } else {
        // Play full surah (use -1 to indicate full surah playback)
        await _audioService.playAyat(audioFullUrl, -1);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memutar audio surah: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToSurah(int nomorSurah, String namaSurah, {bool isNext = true}) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SurahDetailPage(
          nomorSurah: nomorSurah,
          namaSurah: namaSurah,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Slide from right for next, from left for previous
          final beginOffset = isNext ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);
          final endOffset = isNext ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
          
          const curve = Curves.easeInOut;

          // Incoming page animation
          var slideTween = Tween(begin: beginOffset, end: Offset.zero).chain(
            CurveTween(curve: curve),
          );

          // Outgoing page animation
          var exitTween = Tween(begin: Offset.zero, end: endOffset).chain(
            CurveTween(curve: curve),
          );

          return Stack(
            children: [
              // Outgoing page (current page sliding out)
              SlideTransition(
                position: secondaryAnimation.drive(exitTween),
                child: child,
              ),
              // Incoming page (new page sliding in)
              SlideTransition(
                position: animation.drive(slideTween),
                child: child,
              ),
            ],
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildNavigationBar(),
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
              onPressed: _loadSurahDetail,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_surahDetail == null) {
      return const Center(child: Text('Data tidak tersedia'));
    }

    // Use CustomScrollView with SliverAppBar for collapsing header
    return CustomScrollView(
      cacheExtent: 1000, // Pre-render items within 1000 pixels
      slivers: [
        // Floating header that appears when scrolling down
        SliverAppBar(
          floating: true,
          snap: true,
          pinned: false,
          title: Text(
            widget.namaSurah,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.green.shade700,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        // Main header with gradient (visible at top)
        SliverToBoxAdapter(child: _buildHeader()),
        SliverToBoxAdapter(child: _buildDescription()),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Use RepaintBoundary to prevent unnecessary repaints
                return RepaintBoundary(
                  child: _buildAyatCard(_surahDetail!.ayat[index]),
                );
              },
              childCount: _surahDetail!.ayat.length,
            ),
          ),
        ),
        // Add bottom padding for navigation bar
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final isPlayingFullSurah = _audioService.currentPlayingAyatNumber == -1; // Use -1 to indicate full surah
    final audioFullUrl = _surahDetail!.audioFull['05']; // Using reciter 05 (Mishari Rashid)
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.green.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            _surahDetail!.nama,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            _surahDetail!.namaLatin,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _surahDetail!.arti,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip(
                _surahDetail!.tempatTurun,
                _surahDetail!.tempatTurun.toLowerCase() == 'mekah'
                    ? Colors.amber
                    : Colors.blue,
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                '${_surahDetail!.jumlahAyat} Ayat',
                Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Play Full Surah Button
          ElevatedButton.icon(
            onPressed: audioFullUrl != null
                ? () => _handleFullSurahButtonPressed(audioFullUrl)
                : null,
            icon: Icon(
              isPlayingFullSurah && _playerState == PlayerState.playing
                  ? Icons.pause
                  : Icons.play_arrow,
            ),
            label: Text(
              isPlayingFullSurah && _playerState == PlayerState.playing
                  ? 'Jeda Surah Lengkap'
                  : 'Putar Surah Lengkap',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, Color color) {
    // Determine background and text colors based on the color parameter
    Color backgroundColor;
    Color textColor;
    
    if (color == Colors.white) {
      // For "X Ayat" chip - white background with green text
      backgroundColor = Colors.white.withOpacity(0.9);
      textColor = Colors.green.shade700;
    } else if (color == Colors.amber) {
      // For "Mekah" chip
      backgroundColor = Colors.amber.shade100;
      textColor = Colors.amber.shade900;
    } else {
      // For "Madinah" chip
      backgroundColor = Colors.blue.shade100;
      textColor = Colors.blue.shade900;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    final cleanDescription = _stripHtmlTags(_surahDetail!.deskripsi);
    final isLong = cleanDescription.length > 150;
    final displayText = _isDescriptionExpanded || !isLong
        ? cleanDescription
        : '${cleanDescription.substring(0, 150)}...';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.green.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Tentang Surah',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            displayText,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
          if (isLong)
            InkWell(
              onTap: () {
                setState(() {
                  _isDescriptionExpanded = !_isDescriptionExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _isDescriptionExpanded ? 'Lihat Lebih Sedikit' : 'Lihat Selengkapnya',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAyatCard(Ayat ayat) {
    final isPlaying = _audioService.isAyatPlaying(ayat.nomorAyat);
    final audioUrl = ayat.audio['05']; // Using reciter 05 (Mishari Rashid)
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with number and audio icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade700, Colors.green.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      ayat.nomorAyat.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isPlaying && _playerState == PlayerState.playing
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    color: isPlaying 
                        ? Colors.green.shade700 
                        : Colors.grey.shade600,
                  ),
                  onPressed: audioUrl != null 
                      ? () => _handleAudioButtonPressed(audioUrl, ayat.nomorAyat)
                      : null,
                  tooltip: audioUrl != null 
                      ? (isPlaying && _playerState == PlayerState.playing 
                          ? 'Pause' 
                          : 'Play')
                      : 'Audio not available',
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Arabic text
            Text(
              ayat.teksArab,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                height: 2,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            
            // Latin transliteration
            Text(
              ayat.teksLatin,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            
            // Indonesian translation
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Text(
                ayat.teksIndonesia,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade800,
                  height: 1.6,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildNavigationBar() {
    if (_surahDetail == null) return null;

    final hasPrev = _surahDetail!.suratSebelumnya != null &&
        _surahDetail!.suratSebelumnya is Map;
    final hasNext = _surahDetail!.suratSelanjutnya != null;

    if (!hasPrev && !hasNext) return null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Previous button
              if (hasPrev)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final prev = _surahDetail!.suratSebelumnya as Map;
                      _navigateToSurah(
                        prev['nomor'] as int,
                        prev['namaLatin'] as String,
                        isNext: false, // Slide from left
                      );
                    },
                    icon: const Icon(Icons.chevron_left),
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Sebelumnya',
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          (_surahDetail!.suratSebelumnya as Map)['namaLatin'] as String,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      foregroundColor: Colors.green.shade700,
                      side: BorderSide(color: Colors.green.shade700),
                    ),
                  ),
                )
              else
                const Expanded(child: SizedBox()),

              if (hasPrev && hasNext) const SizedBox(width: 12),

              // Next button
              if (hasNext)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final next = _surahDetail!.suratSelanjutnya!;
                      _navigateToSurah(
                        next['nomor'] as int,
                        next['namaLatin'] as String,
                        isNext: true, // Slide from right
                      );
                    },
                    icon: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Selanjutnya',
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          _surahDetail!.suratSelanjutnya!['namaLatin'] as String,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    label: const Icon(Icons.chevron_right),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                )
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
