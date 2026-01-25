import 'package:flutter/foundation.dart';
import 'package:universal_ble/universal_ble.dart';

class Scanner {
  bool _isScanning = false;
  final Map<String, BleDevice> _devicesById = {};

  bool get isScanning => _isScanning;
  List<BleDevice> get devices => _devicesById.values.toList();

  Future<void> startScan(void Function(BleDevice device) onDeviceDiscovered) async {
    if (_isScanning) return;


    try {
      final state = await UniversalBle.getBluetoothAvailabilityState();
      debugPrint("Bluetooth availability: $state");
    } catch (e) {
      debugPrint("Bluetooth state check failed: $e");
    }


    final hasPerms = await UniversalBle.hasPermissions(withAndroidFineLocation: false);
    debugPrint("Has permissions: $hasPerms");

    if (!hasPerms) {
      try {
        await UniversalBle.requestPermissions(withAndroidFineLocation: false);
        debugPrint("Permission request completed.");
      } catch (e) {
        debugPrint("Permission request failed/denied: $e");
        return;
      }
    }

    _devicesById.clear();


    UniversalBle.onScanResult = (BleDevice d) {
      debugPrint("SCAN RESULT: name=${d.name}, id=${d.deviceId}");

      final isNew = !_devicesById.containsKey(d.deviceId);
      _devicesById[d.deviceId] = d;

      if (isNew) {
        onDeviceDiscovered(d);
      }
    };

    try {
      await UniversalBle.startScan();
      _isScanning = true;
      debugPrint("Scan started.");
    } catch (e) {
      debugPrint("startScan threw error: $e");
      UniversalBle.onScanResult = null;
      _isScanning = false;
    }
  }

  Future<void> stopScan() async {
    if (!_isScanning) return;

    try {
      await UniversalBle.stopScan();
    } catch (e) {
      debugPrint("stopScan error: $e");
    }

    _isScanning = false;
    UniversalBle.onScanResult = null;
    debugPrint("Scan stopped.");
  }

  void clear() => _devicesById.clear();
}
