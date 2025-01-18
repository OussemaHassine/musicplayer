import 'package:flutter/material.dart';
import 'package:music_player/components/my_drawer.dart';
import 'package:music_player/components/neu_box.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  SongPage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String formatTime(Duration duration) {
    String twoDigitSeconds =
    duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "${duration.inMinutes}:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<PlaylistProvider>(builder: (context, value, child) {
      final playlist = value.playlist;
      final currentSong = playlist[value.currentSongIndex ?? 0];

      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        drawer: const MyDrawer(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // AppBar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back)),
                    const Text("N O W   P L A Y I N G"),
                    IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                // Album artwork
                NeuBox(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          currentSong.albumArtImagePath,
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.4,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(screenHeight * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentSong.songName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenHeight * 0.025),
                                ),
                                Text(currentSong.artistName),
                              ],
                            ),
                            const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                // Song duration progress
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatTime(value.currentDuration)),
                          GestureDetector(
                            onTap: value.toggleShuffle,
                            child: Icon(
                              Icons.shuffle,
                              color: value.isShuffle ? Colors.green : Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: value.toggleRepeat,
                            child: Icon(
                              Icons.repeat,
                              color: value.isRepeat ? Colors.green : Colors.grey,
                            ),
                          ),
                          Text(formatTime(value.totalDuration)),
                        ],
                      ),
                    ],
                  ),
                ),
                Slider(
                  min: 0,
                  max: value.totalDuration.inSeconds.toDouble(),
                  activeColor: Colors.green,
                  value: value.currentDuration.inSeconds.toDouble(),
                  onChanged: (double double) {
                    // Update UI during sliding
                  },
                  onChangeEnd: (double double) {
                    value.seek(Duration(seconds: double.toInt()));
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                // Playback controls
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: value.playPreviousSong,
                        child: NeuBox(child: const Icon(Icons.skip_previous)),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: value.pauseOrResume,
                        child: NeuBox(
                            child: Icon(
                                value.isPlaying ? Icons.pause : Icons.play_arrow)),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    Expanded(
                      child: GestureDetector(
                        onTap: value.playNextSong,
                        child: NeuBox(child: const Icon(Icons.skip_next)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
