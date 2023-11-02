import 'package:flutter/material.dart';
import 'package:youtube_shorts/video.dart';

class TestVideoScreen extends StatefulWidget {
  const TestVideoScreen({super.key});

  @override
  State<TestVideoScreen> createState() => _TestVideoScreenState();
}

class _TestVideoScreenState extends State<TestVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: CustomVideoPlayer(videoURL: ""),
    ));
  }
}
