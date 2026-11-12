
# Bangladesh Realistic Car Simulator
## Godot 4.x Android Build Guide

### 1. Required software

- Godot Engine 4.x
- Godot Android Export Templates
- Android SDK
- Android Build Tools
- Android Platform Tools
- Java Development Kit (JDK)

### 2. Project setup

1. Open the project in Godot 4.x.
2. Check that project.godot is present.
3. Check that main.tscn is the main scene.
4. Check that all GDScript files are included.
5. Fix all script errors before exporting.

### 3. Install export templates

1. Open Godot Editor.
2. Open Editor > Manage Export Templates.
3. Download or install the matching Godot 4.x export templates.
4. Confirm that the templates match the installed Godot version.

### 4. Android export setup

1. Open Editor Settings.
2. Find Export > Android.
3. Set the Android SDK path.
4. Set the Java SDK path.
5. Confirm that the required Android tools are installed.

### 5. Create Android export preset

1. Open Project > Export.
2. Add an Android preset.
3. Set the application name:
   Bangladesh Realistic Car Simulator
4. Choose a unique package name, for example:
   com.example.bangladeshcarsimulator
5. Set the version number.
6. Choose the supported screen orientation.
7. Check the required permissions.

### 6. APK test build

1. Select the Android export preset.
2. Choose APK as the export format.
3. Export a debug build.
4. Install it on a compatible Android test device.
5. Test the menu, garage, controls, driving and save system.

### 7. Google Play build

1. Create a secure release signing key.
2. Configure release signing in Godot.
3. Create an Android App Bundle (AAB).
4. Test the release build.
5. Prepare the Play Store listing.
6. Upload the AAB through Google Play Console.

### 8. Important notes

- Never publish an untested build.
- Keep the signing key private and backed up.
- Use original or properly licensed 3D models, sounds and images.
- Test performance on lower-end Android devices.
- Check Google Play policies before publishing.
- A GitHub repository does not automatically create an APK.
- Google Play publication requires a suitable developer account.

### 9. Project status

This project is a development prototype.
It is not yet a completed or verified Play Store release.
Further testing, debugging, asset integration and optimization are required.
