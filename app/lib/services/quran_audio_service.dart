import 'package:audioplayers/audioplayers.dart';

class QuranAudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  String? _currentPlayingUrl;
  int? _currentPlayingAyatNumber;
  
  // Getters
  String? get currentPlayingUrl => _currentPlayingUrl;
  int? get currentPlayingAyatNumber => _currentPlayingAyatNumber;
  AudioPlayer get audioPlayer => _audioPlayer;
  
  // Play audio from URL
  Future<void> playAyat(String audioUrl, int ayatNumber) async {
    try {
      // If same ayat is playing, pause it
      if (_currentPlayingUrl == audioUrl) {
        await pause();
        return;
      }
      
      // Stop current audio if different
      if (_currentPlayingUrl != null && _currentPlayingUrl != audioUrl) {
        await stop();
      }
      
      // Play new audio
      await _audioPlayer.play(UrlSource(audioUrl));
      _currentPlayingUrl = audioUrl;
      _currentPlayingAyatNumber = ayatNumber;
    } catch (e) {
      throw Exception('Failed to play audio: $e');
    }
  }
  
  // Pause audio
  Future<void> pause() async {
    await _audioPlayer.pause();
  }
  
  // Resume audio
  Future<void> resume() async {
    await _audioPlayer.resume();
  }
  
  // Stop audio
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentPlayingUrl = null;
    _currentPlayingAyatNumber = null;
  }
  
  // Check if specific ayat is playing
  bool isAyatPlaying(int ayatNumber) {
    return _currentPlayingAyatNumber == ayatNumber;
  }
  
  // Get player state stream
  Stream<PlayerState> get playerStateStream => _audioPlayer.onPlayerStateChanged;
  
  // Get duration stream
  Stream<Duration> get durationStream => _audioPlayer.onDurationChanged;
  
  // Get position stream
  Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;
  
  // Dispose
  void dispose() {
    _audioPlayer.dispose();
  }
}
