Pub Version analysis Star on Github License: MIT



<h1>UZ</h1>

Bu package asosan UZCARD va HUMO plastik cartalarini scanner qilish uchun android✅ va iosga✅ ishlaydi.


Foydalanish 

Oldin dasturimizga firebaseni o\`rnatishimiz kerak bo\`ladi. Quyidagi havola orqali tanishib chiqing:   https://firebase.flutter.dev/docs/overview/


Keyingi navbatda

<h4>IOS</h4>

Info.plis filega quyidagilarni qo\`shin


'<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
<key>NSMicrophoneUsageDescription</key>
<string>your usage description here</string>'


<h4>ANDROID </h4>

android/app/build.gradle filega quyidagicha o\`zgartirish kiriting

minSdkVersion 21



<h1>ENG</h1>

fractal_card_scanner package for android✅ and ios✅ to scan cards.

Getting Started 

First, we need to install firebase in our program. Check out the following link: https://firebase.flutter.dev/docs/overview/


pubspac.yaml

 dependencies:
    fractal_card_scanner 1.0.0




Dart code:

FractalCardModel fractalCardModel=await FractalScannerCard.startScan(context);








