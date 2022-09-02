import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

mixin ScanLogic {
  CameraController? cameraController;
  List<CameraDescription>? cameras;

  static final textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  String name = '#### ####';
  String cardNumber = '#### #### #### ####';
  String cardDate = '##/##';
  String bankName = '######';

  late AnimationController slideAnimbationController;

  bool scanError = false;

  List<bool> isDone = [false, false, false];
  late Timer timer;
  int timerCout = 0;

  makeDefolund(Function setState) {
    name = '#### ####';
    cardNumber = '#### #### #### ####';
    cardDate = '##/##';
    bankName = '######';
    scanError = false;
    timerCout = 0;

    for (int i = 0; i < isDone.length; i++) {
      isDone[i] = false;
    }
    setState(() {});
  }

  Future<void> timerForScanTime(Function setState) async {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      timerCout++;
      if (timerCout == 10) {
        scanError = true;
        slideAnimbationController.forward();
        _stopStream();
      }
      setState(() {});
    });
  }

  void scanText(CameraImage cameraImage) async {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in cameraImage.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize =
          Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

      final InputImageRotation imageRotation =
          InputImageRotationValue.fromRawValue(
                  cameras!.first.sensorOrientation) ??
              InputImageRotation.rotation0deg;

      final InputImageFormat inputImageFormat =
          InputImageFormatValue.fromRawValue(cameraImage.format.raw) ??
              InputImageFormat.nv21;

      final planeData = cameraImage.planes.map(
        (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList();

      final inputImageData = InputImageData(
        size: imageSize,
        imageRotation: imageRotation,
        inputImageFormat: inputImageFormat,
        planeData: planeData,
      );
      final inputImage =
          InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      for (TextBlock block in recognizedText.blocks) {
        for (int i = 0; i < block.lines.length; i++) {
          // print("line====  " + block.lines[i].text);

          String? _numberCard = _checkNumber(block.lines[i].text);

          if (isDone.contains(false)) {
            if (_numberCard != null) {
              cardNumber = _numberCard;
              isDone[0] = true;
            }

            String? _banckName = _checkBankName(block.lines[i].text);

            if (_banckName != null) {
              bankName = _banckName;
            }

            String? _dateCard = _checkDate(block.lines[i].text);

            if (_dateCard != null) {
              cardDate = _dateCard;
              isDone[1] = true;
            }

            String? _nameCard = _checkName(block.lines[i].text);

            if (_nameCard != null && i != 0) {
              name = _nameCard;
              isDone[2] = true;
            }
          } else {
            slideAnimbationController.forward();
            _stopStream();
          }
        }
      }
    } catch (e) {
      print("error" + e.toString());
    }
  }

  _stopStream() async {
    await Future.delayed(const Duration(milliseconds: 100));
    await cameraController!.stopImageStream();
  }

  String? _checkNumber(String number) {
    String validNumber = number.replaceAll(" ", "");

    if (validNumber.length >= 16) {
      for (int i = 0; i < validNumber.length; i++) {
        if (!(validNumber.codeUnitAt(i) >= 48 &&
            validNumber.codeUnitAt(i) <= 57)) {
          return null;
        }
      }

      return number.trim();
    }

    return null;
  }

  String? _checkDate(String number) {
    String validDate = number.replaceAll(" ", "");

    if (!validDate.contains("/")) {
      if (validDate.length == 4) {
        RegExp hasString = RegExp(r'(\w+)');

        if (hasString.hasMatch(validDate)) {
          return null;
        }
        return validDate.substring(0, 2) + "/" + validDate.substring(2, 3);
      }
    }
    validDate = validDate.replaceAll("/", '');

    if (validDate.length != 4) {
      return null;
    }

    for (int i = 0; i < validDate.length; i++) {
      if (!(validDate.codeUnitAt(i) >= 48 && validDate.codeUnitAt(i) <= 57)) {
        return null;
      }
    }

    return number.trim();
  }

  String? _checkBankName(String text) {
    String validBankName = text.trim();

    validBankName = validBankName.toLowerCase();

    if (validBankName.length < 3) {
      return null;
    }

    if (!validBankName.contains("bank")) {
      return null;
    }

    return text.trim();
  }

  String? _checkName(String text) {
    String validName = text.trim();

    List<String> list = validName.split(" ");

    if (list.length != 2) {
      return null;
    }

    validName = validName.replaceAll(" ", "").toLowerCase();

    for (int i = 0; i < validName.length; i++) {
      if (!(validName.codeUnitAt(i) >= 97 && validName.codeUnitAt(i) <= 122)) {
        return null;
      }
    }

    return text.trim();
  }
}
