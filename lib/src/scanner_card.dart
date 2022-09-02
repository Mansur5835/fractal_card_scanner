import 'package:flutter/material.dart';
import 'card_model.dart';
import 'fractal_scanner_view.dart';

class FractalScannerCard {
  static Future<FractalCardModel?> startScan(BuildContext context,
      {String? title,
      String? notFoundCardLabel,
      Widget? appIcon,
      required Image cardImage,
      Color? primaryColor,
      required Widget confirmationIcon,
      required Widget scannerIcon}) async {
    FractalCardModel? cardModel = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => FractalScannerCardView(
                title: title,
                notFoundCardLabel: notFoundCardLabel,
                scannerIcon: scannerIcon,
                confirmationIcon: confirmationIcon,
                appIcon: appIcon,
                cardImage: cardImage,
                primaryColor: primaryColor))));

    if (cardModel == null) {
      return null;
    }

    return cardModel;
  }
}
