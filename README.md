# BLE Scanner App

A Flutter Android app that scans for nearby Bluetooth Low Energy (BLE) devices and shows them in a list.

## Features

- Scans for BLE devices in the area
- Shows the devices found in a simple list
- Displays device information such as [name, ID and signal strength (RSSI)]
- Handles Bluetooth and location permissions

## Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **Bluetooth:** [universal_ble](https://pub.dev/packages/universal_ble)
- **Permissions:** [permission_handler](https://pub.dev/packages/permission_handler)
- **Platform:** Android

## Requirements

- Flutter SDK
- A real Android device with Bluetooth turned on

> BLE scanning does not work on the Android emulator, so you need a physical device.

## Installation

1. Clone the repository:
```bash
   git clone https://github.com/[your-username]/[repo-name].git
   cd [repo-name]
```

2. Install the dependencies:
```bash
   flutter pub get
```

3. Connect your Android phone and run the app:
```bash
   flutter run
```

## Usage

1. Open the app and allow the Bluetooth and location permissions.
2. Start a scan.
3. Nearby BLE devices will appear in the list.

## Permissions

The app requests the following Android permissions:

- `BLUETOOTH_SCAN` and `BLUETOOTH_CONNECT` (Android 12 and newer)
- `ACCESS_FINE_LOCATION` (needed for BLE scanning on Android 11 and older)
