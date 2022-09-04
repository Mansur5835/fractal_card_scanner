import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fractal_card_scanner/src/scan_logic.dart';
import 'package:fractal_card_scanner/src/slide_animation.dart';

import 'card_model.dart';
import 'heart_animation.dart';

class FractalScannerCardView extends StatefulWidget {
  final String? title;
  final String? notFoundCardLabel;
  final Widget confirmationIcon;
  final Widget scannerIcon;
  final Widget? appIcon;
  final Color? primaryColor;
  final Image cardImage;
  const FractalScannerCardView(
      {Key? key,
      this.title,
      this.notFoundCardLabel,
      this.appIcon,
      this.primaryColor,
      required this.confirmationIcon,
      required this.cardImage,
      required this.scannerIcon})
      : super(key: key);

  @override
  State<FractalScannerCardView> createState() => _FractalScannerCardViewState();
}

class _FractalScannerCardViewState extends State<FractalScannerCardView>
    with TickerProviderStateMixin, ScanLogic {
  @override
  void initState() {
    slideAnimbationController =
        FractalSlideController.getController(vsync: this);

    _getCameras();

    timerForScanTime(setState);

    super.initState();
  }

  _getCameras() async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras!.first,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.bgra8888,
    );

    await cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      }

      _startImageStream();
    }).catchError((er) {
      if (kDebugMode) {
        print("Error=>" + er.toString());
      }
    });
  }

  _startImageStream() async {
    await cameraController!.startImageStream((CameraImage image) async {
      scanText(image);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController?.value.isInitialized ?? false) {
      return Scaffold(
        body: Container(
          alignment: Alignment.topCenter,
          child: Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: (cameraController == null)
                ? Container()
                : CameraPreview(
                    cameraController!,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          height: 60,
                          alignment: Alignment.centerLeft,
                          child: FractalHeartAnimation(
                            animationChild: (size) => Text(
                              widget.title ?? "Kartani To`g`ri tuting",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          child: Container(
                              alignment: Alignment.bottomRight,
                              width: MediaQuery.of(context).size.width - 10,
                              height: MediaQuery.of(context).size.height * 0.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 3,
                                      color: widget.primaryColor ??
                                          const Color(0xff000abc))),
                              child: widget.appIcon ??
                                  const FlutterLogo(
                                    size: 60,
                                  )),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width - 10,
                            height: MediaQuery.of(context).size.height * 0.25,
                            alignment: Alignment.bottomCenter,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Opacity(
                                    opacity: 0.9,
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                10,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        child: widget.cardImage),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Text(
                                        cardNumber,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Text(
                                        cardDate,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Text(
                                        name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.all(15),
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    bankName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                )
                              ],
                            )),
                        const Spacer(),
                        slideAnimbationController.buildWidget(
                            child: (controller) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (scanError) ...{
                                      Text(
                                        widget.notFoundCardLabel ??
                                            "Karta malumotlari topilmadi",
                                        style:
                                            const TextStyle(color: Colors.red),
                                      )
                                    },
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      splashRadius: 1,
                                      color: Colors.white,
                                      onPressed: () {
                                        controller.reverse();
                                        makeDefolund(setState);
                                        _startImageStream();
                                      },
                                      icon: SizedBox(
                                          width: 60,
                                          height: 60,
                                        child: widget.scannerIcon,
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      splashRadius: 1,
                                      color: widget.primaryColor ??
                                          const Color(0xff000abc),
                                      onPressed: () {
                                        if (scanError) {
                                          Navigator.pop(context);
                                          return;
                                        }
                                        FractalCardModel cardModel =
                                            FractalCardModel(
                                                cardNumber: cardNumber,
                                                cardDate: cardDate,
                                                bankName: bankName.contains("#")
                                                    ? null
                                                    : bankName,
                                                cardName: name.contains("#")
                                                    ? null
                                                    : name);

                                        Navigator.pop(context, cardModel);
                                      },
                                      icon: scanError
                                          ? CircleAvatar(
                                              backgroundColor:
                                                  widget.primaryColor ??
                                                      const Color(0xff000abc),
                                              child: const Icon(
                                                Icons.chevron_right,
                                                size: 35,
                                                color: Colors.white,
                                              ),
                                            )
                                          : SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: widget.confirmationIcon,
                                            ),
                                    ),
                                  ],
                                )),
                        const Spacer(),
                      ],
                    ),
                  ),
          ),
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController!.dispose();
    timer.cancel();
  }
}
