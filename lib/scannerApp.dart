import 'package:flutter/material.dart';
import 'package:universal_ble/universal_ble.dart';
import 'scanner.dart';

class ScannerApp extends StatefulWidget {
  const ScannerApp({super.key});

  @override
  State<ScannerApp> createState() => _ScannerAppState();
}

class _ScannerAppState extends State<ScannerApp> {
  final Scanner scanner = Scanner();

  bool _isScanning = false;
  String _scanStatus = "Scan stopped.";

  final List<BleDevice> _devices = [];

  Future<void> _toggleScan() async {
    if (_isScanning) {
      await scanner.stopScan();
      if (!mounted) return;

      setState(() {
        _isScanning = false;
        _scanStatus = "Scan stopped.";
      });
      return;
    }

    setState(() {
      _devices.clear();
      scanner.clear();
      _isScanning = true;
      _scanStatus = "Scanning...";
    });

    try {
      await scanner.startScan((BleDevice device) {
        if (!mounted) return;

        setState(() {
          final exists = _devices.any((d) => d.deviceId == device.deviceId);
          if (!exists) _devices.add(device);
        });
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isScanning = false;
        _scanStatus = "Scan failed: $e";
      });
    }
  }

  void _clearDevices() {
    setState(() {
      scanner.clear();
      _devices.clear();
    });
  }

  @override
  void dispose() {
    scanner.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BLE "),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Start / Stop + Clear buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _toggleScan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    _isScanning ? Colors.red : Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
                  ),
                  child:
                  Text(_isScanning ? "Stop Scan" : "Start Scan"),
                ),
                const SizedBox(width: 15),

                // Clear button (only enabled when NOT scanning)
                ElevatedButton(
                  onPressed: _isScanning ? null : _clearDevices,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
                  ),
                  child: const Text("Clear List"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              _scanStatus,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: _devices.isEmpty
                  ? const Center(child: Text("No devices yet..."))
                  : ListView.separated(
                itemCount: _devices.length,
                separatorBuilder: (_, __) =>
                const Divider(height: 1),
                itemBuilder: (context, index) {
                  final d = _devices[index];
                  final name = (d.name != null &&
                      d.name!.trim().isNotEmpty)
                      ? d.name!.trim()
                      : "Unnamed device";

                  return ListTile(
                    title: Text(name),
                    subtitle: Text(d.deviceId),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
