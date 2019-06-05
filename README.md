# Money Monitor

Expense tracking app built using flutter. Add, edit and track your expenses from your phone or browser using the companion web app found [here](https://moneymonitor-al.herokuapp.com/)

### Build Instructions

#### Requirements
* Requires the Flutter SDK to be installed as well as the android SDK tools. Instructions on how to setup your device for flutter development can be found at the [official flutter install guide](https://flutter.dev/docs/get-started/install)

* You will need to setup your own firebase realtime database and app from the firebase console to develop the app. Instructions on how to do this are available when creating a new project on the firebase site. Once setup grab the `google-services.json` file from the console and place it in `android/app` directory. (Instructions for IOS available in the firebase documentation)

1) Clone repository to your device and navigate to the newly cloned folder.
2) Open a terminal window at the root of the cloned folder and run `flutter pub get` to download all dependencies 
3) Run `Flutter run` from the terminal window with an Android/IOS emulator or physical device plugged in to launch the app for development.

If you just want to build the apk to install on your android device:
1) Follow steps 1 and 2 from above.
2) Run `flutter build apk` from the command line to generate an APK file in the build folder which you can install on your device. Alternativley with your device plugged in you with USB debugging enabled, run `flutter install` to build and push the apk to your device automatically.

### [Screenshots](https://imgur.com/a/9Xa4E14)
<img align="left" src="https://imgur.com/22aExh8.png" width="250">
<img align="left" src="https://imgur.com/3EyEGKQ.png" width="250">
<img align="left" src="https://imgur.com/jYOfp4J.png" width="250">
