import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final int index;
  final ValueNotifier<int?> currentlyPlayingIndex;

  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
    required this.index,
    required this.currentlyPlayingIndex,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem>
    with AutomaticKeepAliveClientMixin {
  late YoutubePlayerController _controller;
  late VoidCallback _listener;

  @override
  bool get wantKeepAlive => true; // Keep the state alive when off-screen

  @override
  void initState() {
    super.initState();

    String? videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          controlsVisibleAtStart: false,
          hideControls: true,
          forceHD: false,
        ),
      );
    }

    _listener = () {
      if (widget.currentlyPlayingIndex.value != widget.index) {
        if (_controller.value.isPlaying) {
          _controller.pause();
          setState(() {
            // Update UI
          });
        }
      }
    };
    widget.currentlyPlayingIndex.addListener(_listener);
  }

  @override
  void dispose() {
    widget.currentlyPlayingIndex.removeListener(_listener);
    _controller.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  void skipForward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition + const Duration(seconds: 5);
    _controller.seekTo(newPosition);
  }

  void skipBackward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 5);
    _controller.seekTo(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important when using AutomaticKeepAliveClientMixin

    return Column(
      children: [
        YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
          progressColors: const ProgressBarColors(
            playedColor: Colors.red,
            handleColor: Colors.redAccent,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.replay_5, color: Colors.white),
              onPressed: skipBackward,
            ),
            IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    // Update the currently playing index
                    widget.currentlyPlayingIndex.value = widget.index;
                    _controller.play();
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.forward_5, color: Colors.white),
              onPressed: skipForward,
            ),
          ],
        ),
      ],
    );
  }
}
