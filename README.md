# Money Monitor

Expense tracking app built using flutter. Add, edit and track your expenses from your phone or browser using the companion web app found [here](https://moneymonitor-al.herokuapp.com/)

### Requirements
* Requires the Flutter SDK to be installed as well as the android SDK tools. Instructions on how to setup your device for flutter development can be found at the [official flutter install guide](https://flutter.dev/docs/get-started/install)

### Configuring Firebase

#### Setting up the database.

1) Visit the [firebase console](https://console.firebase.google.com/) and create a new project.
2) Once your project is ready select `Database` under the `Develop` tab on the left hand side.
3) Scroll down and select the `create database` option under Realtime Database and hit enable. 
4) Select the rules tab on the database page and replace the code in the editor with the security rules from [here](https://gist.github.com/AnushanLingam/998f01ebccd74e7f56c82694be4af501) and hit publish.

#### Setting up authentication.

1) From the main overview screen of your project select `authentication` from the side menu.
2) Select the `setup sign in method` option and then select `Google` from the list of options.
3) Enable Google sign in by pressing the button on the top right then hit save.
4) Repeat the same process with the `Email/Password` option.
5) Finally go back to the project overview page. Select the little cog wheel next to project overview on the top left and click project settings. 
5) Scroll down to where it says public settings and make sure that you have a valid support email selected. This is required for authentication to work.

#### Creating a firebase app for your android device

1) From the project overview screen select the android icon under where it says `Get Started...`.
2) Enter a package name. For example: `com.YOURNAME.APPNAME`. You can also add a nickname for the app if you want but that is optional. Keep note of this package name as you will need it later.
3) Next we need to grab the debug SHA1 signing key from your keystore. Run the following command in the terminal.

    `keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore` 

    When prompted, enter your keystore password. The default password is android.

    ##### NOTE: 
    If you are on windows the keytool command will not work normally. You have to naviagate to the `bin` folder of your
    Java JDK and run a terminal from there.

    Default Java installation 64bit: 

    `C:\Program Files\Java\jdk*\bin`

    Default Java installation 32bit:

    `C:\Program Files (x86)\Java\jdk*\bin`

    ##### NOTE: 
    If you dont already have a keystore you will need to generate a new one. To do this first ensure that keytool is added to your environment path variable. To use keytool the Java JDK bin folder needs to be added to the system path. Instuctions for this can be found [here](https://www.java.com/en/download/help/path.xml).

    First open a terminal in your home directory and generate a debug keystore using the following command.

    `keytool -genkeypair -alias androiddebugkey -keypass android -keystore debug.keystore -storepass android -dname "CN=Android Debug,O=Android,C=US" -validity 9999`

    Now run the following command. 
    `keytool -list -v -keystore debug.keystore -alias androiddebugkey -storepass android -keypass android ` and then move on to step 4.

4) If the command ran succesfully you should be able to grab your SHA1 fingerprint. Copy the long SHA1 string under the certificate fingerprints section and paste it in the third textfield on the create app screen and then hit register app.
5) Download the generated google-services.json. You will need this in a future step.

#### Creating the cloud functions

These functions are run everytime a user registers or deletes their account and it is used to initialise or remove their data from the database.

1) Create a new folder on your device and open a terminal window. Visit the [official documentation](https://firebase.google.com/docs/functions/get-started) and follow steps 1 and 2. 

    In step 2 when you run `firebase init functions` it will ask you to select a default project. Make sure you select the name of the project that you created at the start of this guide. Also when it asks you which language to use please select the Javascript option.
2) Once you have completed those steps you will notice some new files and folders. Navigate to `functions/index.js` and open it in a code editor of your choice.
3) Delete everything in this file and replace it with the code found [here](https://github.com/AnushanLingam/moneymonitor-cloudfunctions/blob/master/index.js).
4) Go back to the terminal opened in step 1 and run the following command to deploy the functions. 
`firebase deploy --only functions`.
5) Once succefully deployed verify by visiting the firebase console and selecting `functions` on the left side menu. There should be two functions present called `createUser` and `deleteUser`.

### Setting up your flutter project
1) Clone this repo to your local device and open a terminal at the root of the project.
2) Firstly run `flutter packages get` to ensure you have all the dependencies for the project.
3) Now navigate to `android/app` and paste the `google-services.json` file you downloaded earlier into this folder.

    Note: This file contain information unique to your firebase project such as api keys. Therefore it is excluded from source control to avoid security issues. Please ensure you do not accidently commit this file.
4) Now open `android/app/build.gradle` in the code editor of your choice and find the following section.
5)  Replace the value of `applicationId` with the package name you used earlier when creating the firebase app and then save the file. If you have forgotten this you can retrieve it by going to the project settings page on the firebase console.
6) Now you can run `flutter run` from the root of the project to build and push your app to a plugged in android device or emulator for development.
7) To generate an APK you can run `flutter build apk` instead.

### [Screenshots](https://imgur.com/a/9Xa4E14)
<img align="left" src="https://imgur.com/22aExh8.png" width="250">
<img align="left" src="https://imgur.com/3EyEGKQ.png" width="250">
<img align="left" src="https://imgur.com/jYOfp4J.png" width="250">
