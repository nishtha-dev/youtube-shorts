import 'package:chewie/chewie.dart';
import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:video_player/video_player.dart';
class CustomVideoPlayer extends StatefulWidget {
  final String videoURL;
  const CustomVideoPlayer({
    super.key,
    required this.videoURL,
  });
  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}
class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  // below controller will hold actions/controls related to Video Player
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  @override
  void initState() {
    initControllers();
    super.initState();
  }
  void initControllers() {
    // initializing the controller by passing URL
    // and also setting the state to handle video playing.
    _controller = VideoPlayerController.network(
        "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")
      ..initialize().then((_) => setState(() {}));
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      allowFullScreen: false,
      showOptions: false,
      materialProgressColors: ChewieProgressColors(
        backgroundColor: GlobalColors.lightGrey3,
        playedColor: GlobalColors.red,
        bufferedColor: Colors.transparent,
      ),
      cupertinoProgressColors: ChewieProgressColors(
        backgroundColor: GlobalColors.lightGrey3,
        playedColor: GlobalColors.red,
        bufferedColor: Colors.transparent,
      ),
    );
  }
  // variable to check for Hover and likewise show animation
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Stack(
        alignment: Alignment.center,
        children: [
          if (!_controller.value.isPlaying)
            Positioned.fill(
              child: MouseRegion(
                onHover: (event) {
                  setState(() {
                    _isHovering = true;
                  });
                },
                onExit: (event) {
                  setState(() {
                    _isHovering = false;
                  });
                },
                child: Center(
                  child: AnimatedOpacity(
                    opacity:
                        _isHovering || !_controller.value.isPlaying ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      height:
                          ResponsiveBreakpoints.of(context).isDesktop ? 80 : 80,
                      width:
                          ResponsiveBreakpoints.of(context).isDesktop ? 80 : 80,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: ResponsiveBreakpoints.of(context).isDesktop
                              ? 28
                              : 15,
                        ),
                        onPressed: () {
                          _controller.play();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          InkWell(
            onTap: () {
              // when user taps, start playing the video
              _controller.play();
              // showDialog is used to
              // grey out the background while video is playing
              showDialog(
                barrierColor: Colors.transparent,
                useSafeArea: false,
                context: context,
                builder: (context) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Dialog(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Chewie(
                            controller: _chewieController,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 50.0, top: 40.0),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          color: GlobalColors.white,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      );
    });
  }
  // disposing the video controllers post exit.
  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}