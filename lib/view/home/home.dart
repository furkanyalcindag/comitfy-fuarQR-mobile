import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuar_qr/core/services/article/article_manager.dart';
import 'package:fuar_qr/core/utility/constants.dart';
import 'package:fuar_qr/core/utility/theme_choice.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Barcode? result;
  Map<String, dynamic>? _articleData;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Color _scannerBorderColor = Colors.red;
  bool _isCameraPaused = false;
  bool _isFlashActive = false;
  // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
  var scanAreaHeight;
  var scanAreaWidth;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    scanAreaHeight = MediaQuery.of(context).size.height * 0.5;
    scanAreaWidth = scanAreaHeight;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Dont put any widget on top of the QR Code scanner
          _buildQrView(context),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ThemeChoice()),
                      ),
                    ),
                    Container(
                      width: scanAreaWidth,
                      height: scanAreaHeight,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          if (_articleData != null)
                            Text('Title: ${_articleData!['title']}')
                          else
                            Text(
                              'Scan a code',
                              style:
                                  Theme.of(context).textTheme.bodyLarge!.merge(
                                        TextStyle(color: white),
                                      ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth: 100, maxHeight: 100),
                                margin: const EdgeInsets.all(8),
                                child: Material(
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  color: _isFlashActive
                                      ? whiteSecondary.withOpacity(0.5)
                                      : Theme.of(context)
                                          .buttonTheme
                                          .colorScheme!
                                          .background,
                                  child: IconButton(
                                    onPressed: () async {
                                      _toggleFlash();
                                    },
                                    icon: _isFlashActive
                                        ? const Icon(
                                            Icons.flashlight_on,
                                            color: blackSecondary,
                                          )
                                        : Icon(
                                            Icons.flashlight_off,
                                            color: Theme.of(context)
                                                .buttonTheme
                                                .colorScheme!
                                                .surface,
                                          ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(8),
                                child: Material(
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme!
                                      .background,
                                  child: IconButton(
                                    onPressed: () async {
                                      _toggleCameraPause();
                                    },
                                    icon: _isCameraPaused
                                        ? Icon(
                                            Icons.play_arrow,
                                            color: Theme.of(context)
                                                .buttonTheme
                                                .colorScheme!
                                                .surface,
                                          )
                                        : Icon(
                                            Icons.pause,
                                            color: Theme.of(context)
                                                .buttonTheme
                                                .colorScheme!
                                                .surface,
                                          ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    /* Fluttertoast.showToast(
      msg: "Camera initialized",
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    ); */
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: _scannerBorderColor,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutWidth: scanAreaWidth,
        cutOutHeight: scanAreaHeight,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.pauseCamera();
    controller.scannedDataStream.listen((scanData) async {
      if (result?.code != scanData.code) {
        _getArticleTitle(uuid: scanData.code);
        setState(() {
          result = scanData;
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      print("NO PERMISSION");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<void> _getArticleTitle({required String? uuid}) async {
    if (uuid != null && uuid.isNotEmpty) {
      var data = await ArticleService.fetchArticleByID(
        path: "http://89.252.140.57:8080/article/",
        uuid: uuid,
      );
      setState(() {
        _articleData = data;
      });
    }
  }

  Future<void> _toggleCameraPause() async {
    if (_isCameraPaused) {
      await controller?.resumeCamera();
      setState(() {
        _isCameraPaused = false;
      });
      return;
    }
    await controller?.pauseCamera();
    setState(() {
      _isCameraPaused = true;
    });
  }

  Future<void> _toggleFlash() async {
    if (_isFlashActive) {
      setState(() {
        _isFlashActive = false;
      });
    } else {
      setState(() {
        _isFlashActive = true;
      });
    }
    await controller?.toggleFlash();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
