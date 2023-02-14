import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  String link;
  bool isAutoPlayAndFull;

  VideoWidget({super.key, required this.link, this.isAutoPlayAndFull = false});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  videoCon() async {
    videoPlayerController = VideoPlayerController.network(widget.link);
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      allowedScreenSleep : false ,
      // fullScreenByDefault: widget.isAutoPlayAndFull,
      autoPlay: widget.isAutoPlayAndFull,
    );
    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    videoCon();
  }

  @override
  Widget build(BuildContext context) {
    return videoPlayerController != null &&
            videoPlayerController.value.isInitialized
        ? Container(
            child:
                Chewie(
                  controller: chewieController!,
                ))
           
        : Center(child: CircularProgressIndicator());
  }
}
