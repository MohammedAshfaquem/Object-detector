import 'package:camera/camera.dart';
import 'package:detectot/scancontroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class camerview extends StatelessWidget {
  const camerview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<Scancontroller>(
          init: Scancontroller(),
          builder: (controller) {
            return controller.iscameraInitilaized.value
                ? Stack(
                    children: [
                      CameraPreview(controller.cameraController),
                      Positioned(
                        top: 100,
                        right: 0,
                        child: Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: Colors.green, width: 4.0)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  color: Color.fromARGB(255, 247, 247, 247),
                                  child: Text(
                                    controller.label,
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : Center(
                    child: Text("Laoding privews"),
                  );
          }),
    );
  }
}
