import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class ControlsOverlay extends StatefulWidget {
  ControlsOverlay({Key key, this.controller, this.vidName})
      : super(key: key);
  final String vidName;
  final VideoPlayerController controller;

  @override
  _ControlsOverlayState createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<ControlsOverlay> {
  bool isControllerVisible = true;
  double _volumeDragStartPoint;
  bool _volIndicatorVisible = false;

  _changeVisibility() {
    setState(() {
      setState(() {
        isControllerVisible = !isControllerVisible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.controller.value.isBuffering);
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            _changeVisibility();
          },
          onVerticalDragStart: (details) {
            if (!isControllerVisible) _changeVisibility();

            setState(() {
              _volumeDragStartPoint = details.localPosition.dy;
              _volIndicatorVisible = true;
            });
          },
          onVerticalDragUpdate: (details) {
            print(
                "${(_volumeDragStartPoint - details.localPosition.dy) / 150},$_volumeDragStartPoint");
            widget.controller.setVolume(widget.controller.value.volume +
                (_volumeDragStartPoint - details.localPosition.dy) / 5000);
          },
          onVerticalDragEnd: (details) {
            _volIndicatorVisible = false;
            _volumeDragStartPoint = null;
            setState(() {});
          },
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: !isControllerVisible
              ? SizedBox.shrink()
              : Container(
                  child: Column(
                    children: [
                      //Top Bar Contains name back
                      Container(
                        color: Colors.black38,
                        width: double.infinity,
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    SystemChrome.setPreferredOrientations([
                                      DeviceOrientation.portraitDown,
                                      DeviceOrientation.portraitUp
                                    ]);
                                  }),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                widget.vidName,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      ),

                      //Middle section contains volume
                      Expanded(
                        child: Stack(
                          children: [
                            _volIndicatorVisible
                                ? Center(
                                    child: Container(
                                      height: 100,
                                      width: 170,
                                      child: Stack(
                                        children: [
                                          widget.controller.value.isBuffering
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : SizedBox.shrink(),
                                          Row(
                                            children: [
                                              Center(
                                                child: Icon(
                                                  Icons.volume_up,
                                                  color: Colors.grey,
                                                  size: 80,
                                                ),
                                              ),
                                              Text(
                                                "${(widget.controller.value.volume * 100).toInt()}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                    shadows: [
                                                      Shadow(
                                                          // bottomLeft
                                                          offset: Offset(
                                                              -0.5, -0.5),
                                                          color: Colors.black),
                                                      Shadow(
                                                          // bottomRight
                                                          offset:
                                                              Offset(0.5, -0.5),
                                                          color: Colors.black),
                                                      Shadow(
                                                          // topRight
                                                          offset:
                                                              Offset(0.5, 0.5),
                                                          color: Colors.black),
                                                      Shadow(
                                                          // topLeft
                                                          offset:
                                                              Offset(-0.5, 0.5),
                                                          color: Colors.black),
                                                    ]),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            GestureDetector(
                              onTap: () {
                                _changeVisibility();
                              },
                            ),
                          ],
                        ),
                      ),

                      //Bottom Section Play Pause
                      Container(
                        color: Colors.black38,
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: Icon(
                                    widget.controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  onPressed: () async {
                                    print(widget.controller.value.duration);
                                    print(await widget.controller.position);
                                    if (widget.controller.value.duration <
                                        await widget.controller.position) {
                                      widget.controller.seekTo(
                                        Duration(seconds: 0),
                                      );
                                    }
                                    widget.controller.value.isPlaying
                                        ? widget.controller.pause()
                                        : widget.controller.play();
                                  }),
                              ValueListenableBuilder(
                                  valueListenable: widget.controller,
                                  builder:
                                      (context, VideoPlayerValue value, child) {
                                    return Text(
                                      value.duration == null
                                          ? "00:00"
                                          : formatDuration(
                                              value.position.inMilliseconds),
                                      style: TextStyle(color: Colors.white),
                                    );
                                  }),
                              SizedBox(width: 15),
                              Expanded(
                                child: VideoProgressIndicator(widget.controller,
                                    allowScrubbing: true),
                              ),
                              SizedBox(width: 15),
                              Text(
                                widget.controller.value.duration == null
                                    ? "00:00"
                                    : formatDuration(widget.controller.value
                                        .duration.inMilliseconds),
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  String formatDuration(int milliseconds) {
    if (milliseconds == null) {
      return "00:00";
    }
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hourStr = (hours % 60).toString().padLeft(2, '0');
    if (hourStr == "00") {
      return "$hourStr:$minutesStr:$secondsStr";
    } else {
      return "$hourStr:$minutesStr:$secondsStr";
    }
  }
}
