/*
 * @author [Sourav Ranjan Maharana]
 * @email [sourav.maharana@gida.io]
 * @create date 2023-06-16 11:56:13
 * @desc [This is a segregated class that holds the Video Player]
 *       [Wherever we need to use, just call class and pass URL]
 */

import 'package:chewie/chewie.dart';
// import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
// import 'package:responsive_framework/responsive_breakpoints.dart';
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
      allowMuting: true,
      // isLive: true,

      additionalOptions: (context) {
        print("object");
        return [
          OptionItem(
              onTap: () {
                if (_controller.value.volume == 1) {
                  _controller.setVolume(0);
                  // if (_controller.value.isPlaying) {
                  //   _controller.pause();
                  // } else {
                  //   _controller.play();
                  // }
                }

                // _controller.pause();
                // _controller.value.isPlaying;
                // _controller.play();
                print("hre ");
              },
              iconData: Icons.abc_rounded,
              title: "hrere"),
          OptionItem(
              onTap: () {
                if (_controller.value.volume == 0) {
                  // _controller.
                  _controller.setVolume(1);
                  // if (_controller.value.isPlaying) {
                  //   _controller.pause();
                  // } else {
                  //   _controller.play();
                  // }
                }
                // _controller.play();
                // _controller.setVolume(1);
                // _controller.play();
                print("hre ");
              },
              iconData: Icons.add_box_outlined,
              title: "there"),
        ];
      },
      // customControls: InkWell(
      //   child: Icon(Icons.r_mobiledata),
      // ),
      showOptions: false,

      materialProgressColors: ChewieProgressColors(
        backgroundColor: Colors.black,
        playedColor: Colors.red,
        bufferedColor: Colors.transparent,
      ),
      cupertinoProgressColors: ChewieProgressColors(
        backgroundColor: Colors.green,
        playedColor: Colors.yellow,
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
                    child: InkWell(
                      // on
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.read_more,
                            color: Colors.white,
                            size: 15,
                          ),
                          onPressed: () {
                            _controller.setVolume(0);
                            _controller.play();
                          },
                        ),
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
                          color: Colors.white,
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
