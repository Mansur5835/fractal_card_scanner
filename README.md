Pub Version analysis Star on Github License: MIT



<h1>UZ</h1>

Bu package asosan UZCARD va HUMO plastik cartalarini scanner qilish uchun android✅ va iosga✅ ishlaydi.


Foydalanish 

Oldin dasturimizga firebaseni o\`rnatishimiz kerak bo\`ladi. Quyidagi havola orqali tanishib chiqing:   https://firebase.flutter.dev/docs/overview/


Keyingi navbatda

<h4>IOS</h4>

Info.plis filega quyidagilarni qo\`shin


```yalm
<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
<key>NSMicrophoneUsageDescription</key>
<string>your usage description here</string>
```

<h4>ANDROID </h4>

android/app/build.gradle filega quyidagicha o\`zgartirish kiriting

minSdkVersion 21



<h1>ENG</h1>

fractal_card_scanner package for android✅ and ios✅ to scan cards.


Getting Started 

First, we need to install firebase in our program. Check out the following link: https://firebase.flutter.dev/docs/overview/


<h4>IOS</h4>

Add the following to the info.plis file

```yalm
<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
<key>NSMicrophoneUsageDescription</key>
<string>your usage description here</string>
```


<h4>ANDROID </h4>

Change the android/app/build.gradle file as follows

minSdkVersion 21




<h2>Installation (o`rnatish) </h2>


pubspac.yaml

```yalm
dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.2
  firebase_core: ^1.21.1
  fractal_card_scanner: ^1.0.8
  ```



Dart code:

```dart
     FractalCardModel? fractalCardModel = await FractalScannerCard.startScan(
                  context,
                  primaryColor: AppColors.primaryColor,
                  cardImage: Image.asset(
                    "assets/images/banners/card-back.jpg",
                    fit: BoxFit.cover,
                  ),
                  confirmationIcon: Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1212212)),
                    child: Image.asset(
                      "assets/images/icons/tick.png",
                      color: AppColors.primaryColor,
                      fit: BoxFit.cover,
                    ),
                  ),
                  scannerIcon: Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(1212212)),
                    child: Image.asset(
                      "assets/images/icons/scanner.png",
                      color: Colors.white,
                      fit: BoxFit.cover,
                      width: 30,
                      height: 30,
                    ),
                  ),
                );
```



Example App GitHub
https://github.com/Mansur5835/card_scanner_example 


https://user-images.githubusercontent.com/96409233/188492958-30183b1b-9459-421c-b9eb-92aa9d359454.MP4








