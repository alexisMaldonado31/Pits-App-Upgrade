import 'package:dp_motors/app_config.dart';
import 'package:dp_motors/src/shared/custom_button.dart';
import 'package:dp_motors/src/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

class CameraPage extends StatefulWidget {
  final String? clienteId;
  CameraPage({this.clienteId});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController _controller;
  Future<void> _initController;

  var isCameraReady = false;
  XFile imageFile;

  @override
  void initState() {
    super.initState();
    initCamera();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState? state) {
    if (state == AppLifecycleState.resumed)
      _initController = _controller.initialize();
    if (!mounted) return;
    setState(() {
      isCameraReady = true;
    });
  }

  cameraWidget(context) {
    var camera = _controller.value;
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * (camera.aspectRatio);

    if (scale < 1) scale = 1 / (camera.aspectRatio);

    return Transform.scale(
      scale: scale / 2,
      child: Center(child: CameraPreview(_controller)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var config = AppConfig.of(context);
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "Tomar Foto",
          fontSize: screenSize.width * 0.025,
          fontWeight: FontWeight.bold,
          colorText: Colors.white,
        ),
        backgroundColor: config?.secondary,
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: _initController,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    cameraWidget(context),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () => captureImage(context),
                child: Container(
                  height: 75,
                  width: 75,
                  child: Icon(
                    Icons.camera_alt,
                    color: config?.primary,
                    size: 40,
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: config?.accent),
                ),
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   isExtended: true,
      //   backgroundColor: config?.accent,
      //   child: Icon(
      //     Icons.camera_alt,
      //     color: config?.primary,
      //   ),
      //   onPressed: () => captureImage(context),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> initCamera() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initController = _controller.initialize();
    if (!mounted) return;

    setState(() {
      isCameraReady = true;
    });
  }

  captureImage(BuildContext? context) async {
    var savePhoto = false;
    await _controller.unlockCaptureOrientation();

    savePhoto = await _controller.takePicture().then((file) async {
      setState(() {
        imageFile = file;
      });
      if (mounted) {
        var isSave = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(image: imageFile),
          ),
        );

        return isSave;
      }

      return false;
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Navigator.pop(context, new File(imageFile.path));
    }
}

class DisplayPictureScreen extends StatefulWidget {
  final XFile? image;
  final String? clienteId;

  const DisplayPictureScreen({
    Key? key,
    this.image,
    this.clienteId,
  }) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  var enviandoFoto = false;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var config = AppConfig.of(context);
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "Guardar Foto",
          fontSize: screenSize.width * 0.025,
          fontWeight: FontWeight.bold,
          colorText: Colors.white,
        ),
        backgroundColor: config?.secondary,
      ),
      backgroundColor: config?.primary,
      body: IgnorePointer(
        ignoring: enviandoFoto,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            AspectRatio(
              aspectRatio: 10 / 3,
              child: Container(
                child: Image.file(
                  File(widget.image.path),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.25,
              ),
              child: CustomButton(
                text: "Guardar Foto",
                color: config?.accent,
                colorText: config?.primary,
                height: screenSize.height * 0.08,
                fontSize: screenSize.width * 0.02,
                onTap: () {
                  Navigator.pop(context, true);
                },
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
