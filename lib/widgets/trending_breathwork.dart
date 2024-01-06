import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class TrendingBreathwork extends StatefulWidget {
  final String? videoLink;
  final String? videoId;
  final String? videoTitle;
  final String? videoThumbnail;

  const TrendingBreathwork(
      {Key? key,
      this.videoLink,
      this.videoId,
      this.videoThumbnail,
      this.videoTitle})
      : super(key: key);

  @override
  State<TrendingBreathwork> createState() => _TrendingBreathworkState();
}

class _TrendingBreathworkState extends State<TrendingBreathwork> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.videoLink != null && widget.videoLink!.isNotEmpty) {
      _videoPlayerController = VideoPlayerController.network(widget.videoLink!);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 16 / 9, // You can adjust the aspect ratio here
        autoPlay: false,
        looping: false,
      );
      _videoPlayerController.addListener(() {
        setState(() {});
      });
      _chewieController!.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200, // Adjust the height as needed for the video
            child: _chewieController != null
                ? Chewie(controller: _chewieController!)
                : Center(child: CircularProgressIndicator()),
          ),
          SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Manage your Anger with Dum Mantra',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
