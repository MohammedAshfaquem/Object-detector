import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class Scancontroller extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initcamera();
    initTFLite();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var iscameraInitilaized = false.obs;
  var cameracount = 0;

  var x, y, w, h = 0.0;
  var label = "";

  initcamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.max,
      );
      await cameraController.initialize().then(
        (value) {
          cameraController.startImageStream((image) {
            cameracount++;
            if (cameracount % 10 == 0) {
              cameracount = 0;
              objectDetector(image);
            }
            update();
          });
        },
      );
      iscameraInitilaized(true);
      update();
    } else {
      print("permission denied");
    }
  }

  initTFLite() async {
    await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false);
  }

  objectDetector(CameraImage image) async {
    var detector = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((e) {
          return e.bytes;
        }).toList(),
        asynch: true,
        imageHeight: image.height,
        imageWidth: image.width,
        imageStd: 127.5,
        imageMean: 127.5,
        numResults: 1,
        rotation: 90,
        threshold: 0.4);
    if (detector != null) {
     
       var ourDetectedObject = detector.forEach((response) {
        label = response["label"];
      });
      /* if (ourDetectedObject['confidenceInClass'] * 100 > 45) {
        h = ourDetectedObject['rect']['h'];
        w = ourDetectedObject['rect']['w'];
        x = ourDetectedObject['rect']['x'];
        y = ourDetectedObject['rect']['y'];
       } */
      update();
    }
  }
}
