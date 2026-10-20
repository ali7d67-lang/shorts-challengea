import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isRecording = false;
  int _recordDuration = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(_cameras![0], ResolutionPreset.high);
      await _cameraController!.initialize();
      setState(() {});
    }
  }

  void _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    await _cameraController!.startVideoRecording();
    setState(() {
      _isRecording = true;
      _recordDuration = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordDuration++;
      });
      if (_recordDuration >= 20) {
        _stopRecording();
      }
    });
  }

  void _stopRecording() async {
    _timer?.cancel();
    if (_cameraController == null || !_isRecording) return;
    XFile videoFile = await _cameraController!.stopVideoRecording();
    setState(() {
      _isRecording = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تصوير الفيديو بنجاح! الطول: \$_recordDuration ثانية')),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D0B14),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF00F2FE))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: LinearProgressIndicator(
              value: _recordDuration / 20.0,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00F2FE)),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _isRecording ? _stopRecording : _startRecording,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF00F2FE), width: 4),
                    color: _isRecording ? Colors.red : const Color(0xFF9B51E0),
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.videocam,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
