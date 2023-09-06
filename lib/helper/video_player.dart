import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:stream_chat_flutter/src/video/video_thumbnail_image.dart';

class VideoPlayerPage extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;
  final Attachment attachment;
  const VideoPlayerPage(
      {Key? key,
      required this.videoPlayerController,
      required this.looping,
      required this.autoplay,
      required this.attachment})
      : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  // late ChewieController _chewieController;
  double ratio = 1;
  // late VideoPlayerController controller;
  // String current = "0:00:00";
  // double playValue = 0;
  // var initializeVideo;
  // bool isloaded = false;
  // bool isVideoCompleted = false;
  // bool isFullScreen = false;
  // bool visible = true;

  // double max = 0;
  // Duration videoDuration = Duration();

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   initialize();
    // });
    print('initialize');
    widget.videoPlayerController.initialize().then((_value) {
      setState(() {
        ratio = widget.videoPlayerController.value.aspectRatio;
      });
      // print('Ratio: ${}');
    });
    // _chewieController = ;
  }

  @override
  void dispose() {
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    widget.videoPlayerController.dispose();
    super.dispose();
  }

  // initialize() {
  //   controller = VideoPlayerController.network(widget.fileUrl)
  //     ..initialize().then((value) {
  //       setState(() {
  //         isloaded = true;
  //         controller.play();
  //         controller.setVolume(1);
  //       });
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return widget.videoPlayerController.value.isInitialized
        ? AspectRatio(
            aspectRatio: ratio,
            // height: 350,
            child: Chewie(
              controller: ChewieController(
                videoPlayerController: widget.videoPlayerController,
                aspectRatio: ratio,
                autoInitialize: false,
                autoPlay: widget.autoplay,
                looping: widget.looping,
                errorBuilder: (context, errorMessage) {
                  return Center(
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          )
        : StreamVideoThumbnailImage(
            video: widget.attachment.assetUrl ?? widget.attachment.file!.path,
            thumbUrl: widget.attachment.thumbUrl,
            constraints: BoxConstraints(maxHeight: 400),
          );
  }
}
