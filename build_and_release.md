
# Bangladesh Realistic Car Simulator
# Final Build and Release Guide

## 1. Project requirements

- Godot Engine 4.x
- Existing project.godot
- Existing main.tscn
- Existing GDScript files
- Compatible Android Export Templates
- Android SDK
- Android Build Tools
- JDK

## 2. Before building

1. Open the project in Godot.
2. Scan the project files.
3. Check all script errors.
4. Confirm that main.tscn opens.
5. Test the main menu.
6. Test garage and vehicle selection.
7. Test driving controls.
8. Test road and traffic.
9. Test save and load.
10. Fix errors before exporting.

## 3. Android configuration

1. Install matching Godot Export Templates.
2. Configure Android SDK path.
3. Configure Java SDK path.
4. Install the required Android platform.
5. Install Android Build Tools.
6. Install Android Platform Tools.

## 4. Android application settings

Application name:
Bangladesh Realistic Car Simulator

Suggested package identifier:
com.example.bangladeshcarsimulator

Version:
1.0.0

Version code:
1

Orientation:
Landscape

Renderer:
Compatibility

## 5. Debug APK

1. Open Project > Export.
2. Add Android export preset.
3. Select APK.
4. Export a debug APK.
5. Install it on a test device.
6. Test performance and controls.

## 6. Release AAB

1. Create a secure release signing key.
2. Keep the key and passwords private.
3. Configure release signing.
4. Select Android App Bundle.
5. Export the AAB.
6. Test the release package.

## 7. Performance testing

Test these settings:

LOW:
- Reduced 3D detail
- Lower traffic density
- Lower shadow quality

MEDIUM:
- Balanced graphics
- Medium traffic density

HIGH:
- Higher detail
- More traffic
- Better visual effects

Do not assume Ultra graphics will run smoothly on every phone.

## 8. Google Play preparation

Prepare:
- App icon
- Screenshots
- Feature graphic
- Store description
- Privacy policy if required
- Content rating information
- Data safety information
- AAB release package

Upload through Google Play Console.

## 9. Final status

This guide does not itself generate an APK.
The project must first be built and tested in Godot.

Do not publish an untested project.
Use original or properly licensed assets.
Follow current Google Play requirements.
