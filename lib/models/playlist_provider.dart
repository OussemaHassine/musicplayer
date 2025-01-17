import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';
import 'dart:math';

class PlaylistProvider extends ChangeNotifier {
  // playlist of songs
  final List<Song> _playlist = [
    Song(
        songName: 'House of Balloons',
        artistName: 'The Weeknd',
        albumArtImagePath: "assets/images/weeknd.jpg",
        audioPath: "audio/weeknd.mp3"),
    Song(
        songName: "My Eyes",
        artistName: "Travis Scott",
        albumArtImagePath: "assets/images/ts.jpg",
        audioPath: "audio/ts.mp3"),
    Song(
        songName: "Je Comprends Pas",
        artistName: "PNL",
        albumArtImagePath: "assets/images/pnl.jpeg",
        audioPath: "audio/Pnl.mp3")
  ];

  // current song playing
  int? _currentSongIndex;

  // Audio Player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Shuffle and Repeat Flags
  bool _isShuffle = false;
  bool _isRepeat = false;

  // Constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // Initially not playing
  bool _isPlaying = false;

  // Play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // Stop current song if playing
    await _audioPlayer.play(AssetSource(path)); // Play new song
    _isPlaying = true;
    notifyListeners();
  }

  // Pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // Resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // Pause or Resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  // Seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // Play Next Song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_isShuffle) {
        // Shuffle mode: play a random song
        final randomIndex = Random().nextInt(_playlist.length);
        _currentSongIndex = randomIndex == _currentSongIndex
            ? (randomIndex + 1) % _playlist.length
            : randomIndex;
      } else if (_currentSongIndex! < _playlist.length - 1) {
        // Go to the next song if it's not the last
        _currentSongIndex = _currentSongIndex! + 1;
      } else {
        // If it's the last song
        if (_isRepeat) {
          _currentSongIndex = 0; // Loop back to the first song
        } else {
          return; // Do nothing (stay on the last song)
        }
      }
      play();
    }
    notifyListeners();
  }

  // Play Previous Song
  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero); // Restart current song
    } else if (_currentSongIndex != null) {
      if (_currentSongIndex! > 0) {
        _currentSongIndex = _currentSongIndex! - 1;
      } else {
        _currentSongIndex = _playlist.length - 1; // Loop back to the last song
      }
      play();
    }
    notifyListeners();
  }

  // Toggle Shuffle Mode
  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  // Toggle Repeat Mode
  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  // Listen to Duration
  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (_isRepeat) {
        seek(Duration.zero); // Repeat current song
        play();
      } else {
        playNextSong();
      }
    });
  }

  // Dispose Audio Player
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Getters
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  // Setters
  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }
}
