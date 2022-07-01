import 'package:dummy_try/base/custom_tile.dart';
import 'package:dummy_try/modules/home/utils/video_controls_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = MethodChannel('flutter.rortega.com.channel');

  late VideoPlayerController _controller;

  var _inPIPMode = false;
  var _chanegMode = false;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/sample-mp4-file-small.mp4');

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {
          _controller.play();
        }));
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_inPIPMode && _chanegMode) _inPIPMode = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _inPIPMode
        ? Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          VideoPlayer(_controller),
                          ControlsOverlay(controller: _controller),
                          VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      children: const [
                        CustomTile(
                          title: 'Video Recommendation 1',
                          subTitle: 'Video will be displayed here',
                        ),
                        CustomTile(
                          title: 'Video Recommendation 2',
                          subTitle: 'Video will be displayed here',
                        ),
                        CustomTile(
                          title: 'Video Recommendation 3',
                          subTitle: 'Video will be displayed here',
                        ),
                        CustomTile(
                          title: 'Video Recommendation 4',
                          subTitle: 'Video will be displayed here',
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        _inPIPMode = false;
                      });
                    },
                    child: const Text(
                      'Go Back',
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        // fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  Container(
                    height: 100,
                    color: Colors.pink,
                    child: const Center(
                      child: Text(
                        'PIP Mode Flutter',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  _controller.value.isInitialized
                      ? Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                VideoPlayer(_controller),
                                ControlsOverlay(controller: _controller),
                                VideoProgressIndicator(
                                  _controller,
                                  allowScrubbing: true,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView(
                      children: const [
                        CustomTile(
                          title: 'Comment 1',
                          subTitle: 'Testing A Task for Stage Round 2',
                        ),
                        CustomTile(
                          title: 'Comment 2',
                          subTitle: 'Testing A Task for Stage Round 2',
                        ),
                        CustomTile(
                          title: 'Comment 3',
                          subTitle: 'Testing A Task for Stage Round 2',
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        _inPIPMode = true;
                      });
                      await platform
                          .invokeMethod('showNativeView')
                          .then((value) {
                        setState(() {
                          _chanegMode = true;
                        });
                      });
                    },
                    child: const Text(
                      'Switch to PIP Mode',
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        // fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
