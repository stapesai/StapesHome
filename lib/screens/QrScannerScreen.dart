// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'dart:convert';

// class QRScannerScreen extends StatefulWidget {
//   @override
//   _QRScannerScreenState createState() => _QRScannerScreenState();
// }

// class _QRScannerScreenState extends State<QRScannerScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   bool isFlashOn = false;
//   bool isDrawerOpen = false;

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) async {
//       controller.pauseCamera();
//       if (scanData.code != null) {
//         // Decode the JSON data from the QR code
//         Map<String, dynamic> bleInfo = jsonDecode(scanData.code!);
//         String deviceName = bleInfo['device_name'];
//         String serviceUuid = bleInfo['service_uuid'];
//         String characteristicUuid = bleInfo['characteristic_uuid'];

//         FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

//         FlutterBluePlus.scanResults.listen((results) {
//           for (ScanResult r in results) {
//             if (r.device.name == deviceName) {
//               FlutterBluePlus.stopScan();

//               r.device.connect().then((_) {
//                 r.device.discoverServices().then((services) {
//                   for (BluetoothService service in services) {
//                     if (service.uuid.toString() == serviceUuid) {
//                       for (BluetoothCharacteristic characteristic
//                           in service.characteristics) {
//                         if (characteristic.uuid.toString() ==
//                             characteristicUuid) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CharacteristicPage(
//                                 deviceName: deviceName,
//                                 serviceUuid: serviceUuid,
//                                 characteristicUuid: characteristicUuid,
//                               ),
//                             ),
//                           );
//                           return;
//                         }
//                       }
//                     }
//                   }
//                 });
//               });
//             }
//           }
//         });
//       }
//     });
//   }

//   void _toggleFlash() {
//     if (controller != null) {
//       controller!.toggleFlash();
//       setState(() {
//         isFlashOn = !isFlashOn;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           QRView(
//             key: qrKey,
//             onQRViewCreated: _onQRViewCreated,
//             overlay: QrScannerOverlayShape(
//               borderColor: Colors.yellow,
//               borderRadius: 20,
//               borderLength: 70,
//               borderWidth: 10,
//               cutOutSize: 315,
//             ),
//           ),
//           Positioned(
//             top: 40,
//             right: 20,
//             child: Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//               ),
//               child: IconButton(
//                 icon: Icon(
//                   isFlashOn ? Icons.flash_on : Icons.flash_off,
//                   color: Colors.black,
//                   size: 25,
//                 ),
//                 onPressed: _toggleFlash,
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 20,
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   isDrawerOpen = !isDrawerOpen;
//                 });
//               },
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//                 width: MediaQuery.of(context).size.width,
//                 height:
//                     isDrawerOpen ? MediaQuery.of(context).size.height / 4 : 60,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: const Offset(0, -3),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           'Instructions',
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.yellow),
//                         ),
//                         Spacer(),
//                         Icon(
//                           isDrawerOpen
//                               ? Icons.keyboard_arrow_down
//                               : Icons.keyboard_arrow_up,
//                           size: 24,
//                         ),
//                       ],
//                     ),
//                     if (isDrawerOpen)
//                       Column(
//                         children: [
//                           SizedBox(height: 8),
//                           Text(
//                             'Your instructions here...',
//                             style: TextStyle(fontSize: 14),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CharacteristicPage extends StatelessWidget {
//   final String deviceName;
//   final String serviceUuid;
//   final String characteristicUuid;

//   const CharacteristicPage({
//     required this.deviceName,
//     required this.serviceUuid,
//     required this.characteristicUuid,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Characteristic Details'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Device Name: $deviceName'),
//             Text('Service UUID: $serviceUuid'),
//             Text('Characteristic UUID: $characteristicUuid'),
//           ],
//         ),
//       ),
//     );
//   }
// }

//////FOR POP UP/// LATER USE//
///
///

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isFlashOn = false;
  bool isDrawerOpen = false;
  bool scanFailed = false; // Track if scan failed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.yellow,
              borderRadius: 20,
              borderLength: 70,
              borderWidth: 10,
              cutOutSize: 315,
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                icon: Icon(
                  isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.black,
                  size: 25,
                ),
                onPressed: _toggleFlash,
              ),
            ),
          ),
          if (result != null)
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  result!.code ?? "No QR code scanned",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isDrawerOpen = !isDrawerOpen;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: MediaQuery.of(context).size.width,
                height:
                    isDrawerOpen ? MediaQuery.of(context).size.height / 4 : 60,
                decoration: BoxDecoration(
                  color: Colors.drawer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Icon(
                        isDrawerOpen
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        size: 24,
                        color: Colors.yellow,
                      ),
                    ),
                    const Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                    ),
                    if (isDrawerOpen)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          if (scanFailed) // Display failed message and button if scan failed
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Failed to scan. Please try again.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      scanFailed = false;
                                    });
                                  },
                                  child: Text('Scan Again'),
                                ),
                              ],
                            )
                          else
                            Text(
                              'Your instructions here...',
                              style: TextStyle(fontSize: 14),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        setState(() {
          result = scanData;
          scanFailed = false; // Reset scan failure flag on successful scan
        });
      } else {
        setState(() {
          scanFailed = true; // Set scan failure flag
        });
      }
    });
  }

  void _toggleFlash() {
    if (controller != null) {
      controller!.toggleFlash();
      setState(() {
        isFlashOn = !isFlashOn;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
