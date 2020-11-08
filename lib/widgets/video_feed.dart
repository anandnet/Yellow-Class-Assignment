import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class VideoFeed extends StatefulWidget {
  final List<CameraDescription> cameras;
  VideoFeed(this.cameras);
  @override
  _VideoFeedState createState() => _VideoFeedState();
}

class _VideoFeedState extends State<VideoFeed> {
  CameraController _cameraController;
  @override
  void initState() {
    super.initState();
    print(widget.cameras.length);
    _cameraController = CameraController(
      widget.cameras[1],
      ResolutionPreset.medium,
    );
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    print("camera Disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: _cameraController.value.aspectRatio,
        child: CameraPreview(_cameraController));
  }
}
