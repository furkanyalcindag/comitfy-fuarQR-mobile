import 'dart:async';
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
import 'package:fuar_qr/core/utility/themes.dart';
import 'package:fuar_qr/view/componentbuilders/qrscanner_user_information_builder.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Data
  bool _isCameraPaused = false;
  bool _isFlashActive = false;
  bool _isUserInfoScrollScrollable = false;
  bool _isShowUserInfoScrollHasMoreDataButton = false;
  var scanAreaHeight;
  var scanAreaWidth;
  Barcode? result;
  Map<String, dynamic>? _articleData;
  String? _errorMessage;

  // Controllers
  late ScrollController _scrollController;
  var optimizeTimer = Timer(Duration.zero, () => {});
  QRViewController? controller;

  // View control
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Color _scannerBorderColor = primary;
  Color _scannerOverlayColor = const Color.fromRGBO(0, 0, 0, 80);

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
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_controlScroll);
  }

  Future<void> _controlScroll() async {
    optimizeTimer.cancel();
    optimizeTimer = Timer(
      const Duration(milliseconds: 25),
      () async {
        if (_scrollController.hasClients) {
          // If didnt scrolled yet
          if (_isUserInfoScrollScrollable &&
              _scrollController.offset <=
                  _scrollController.position.maxScrollExtent - 25 &&
              _scrollController.position.maxScrollExtent >= 5.0) {
            // We dont want to setstate and build whole screen everytime since its already true lol
            if (!_isShowUserInfoScrollHasMoreDataButton) {
              setState(() {
                _isShowUserInfoScrollHasMoreDataButton = true;
              });
            }
          } else if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent - 25) {
            // We dont want to setstate and build whole screen everytime since its already true lol
            if (_isShowUserInfoScrollHasMoreDataButton) {
              setState(() {
                _isShowUserInfoScrollHasMoreDataButton = false;
              });
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    scanAreaHeight = MediaQuery.of(context).size.height * 0.5;
    scanAreaWidth = scanAreaHeight;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isUserInfoScrollScrollable =
          _scrollController.position.maxScrollExtent > 0;
      _controlScroll();
    });
    print(
        "BUILLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLDDDDDDDDDD----------------------------------------------");

    /* if (_isUserInfoScrollScrollable) {
      _scrollController.removeListener(_controlScroll);
      _scrollController.addListener(_controlScroll);
    } else {
      _scrollController.removeListener(_controlScroll);
    } */
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Dont put any widget on top of the QR Code scanner
          _buildQrView(context),
          Column(
            children: [
              Expanded(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Stack(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // User Detail Texts -------------------IMPORTANT
                                if (_articleData != null) ...[
                                  if (_errorMessage == null) ...[
                                    buildQrCodeUserInfo(
                                      context: context,
                                      info: {
                                        AppLocalizations.of(context)!.name:
                                            "${_articleData!['title']}\n",
                                        AppLocalizations.of(context)!
                                            .companyName: "Comitfy\n",
                                        AppLocalizations.of(context)!.telNo:
                                            "+90(TR)542 103 20 65\n",
                                        AppLocalizations.of(context)!.email:
                                            "yunusyld7@gmail.com",
                                      },
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ],
                        ),
                        if (_isShowUserInfoScrollHasMoreDataButton)
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(
                              Icons.arrow_downward,
                              color: white,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // We wont use expanded since the scan are can change
              SizedBox(
                width: scanAreaWidth,
                height: scanAreaHeight,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if (_articleData != null)
                      // Is it Accepted Or NOT -------------------------IMPORTANT
                      Text(
                        'Title: ${_articleData!['likeCount'] > 0}',
                        style: Theme.of(context).textTheme.bodyLarge!.merge(
                              TextStyle(color: white),
                            ),
                      )
                    else if (_errorMessage != null)
                      Text(
                        _errorMessage ?? '',
                        style: Theme.of(context).textTheme.bodyLarge!.merge(
                              const TextStyle(color: errorColor),
                            ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: Material(
                            shape: CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            color: _isFlashActive
                                ? whiteSecondary.withOpacity(0.5)
                                : Themes.darkTheme.buttonTheme.colorScheme!
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
                                  : const Icon(
                                      Icons.flashlight_off,
                                      color: whiteSecondary,
                                    ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: Material(
                            shape: CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            color: Themes
                                .darkTheme.buttonTheme.colorScheme!.background,
                            child: IconButton(
                              onPressed: () async {
                                _toggleCameraPause();
                              },
                              icon: _isCameraPaused
                                  ? const Icon(
                                      Icons.play_arrow,
                                      color: whiteSecondary,
                                    )
                                  : Icon(
                                      Icons.pause,
                                      color: Themes.darkTheme.buttonTheme
                                          .colorScheme!.surface,
                                    ),
                            ),
                          ),
                        ),
                        // Clear scan
                        if (_articleData != null || _errorMessage != null)
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: Material(
                              shape: CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              color: _isFlashActive
                                  ? whiteSecondary.withOpacity(0.5)
                                  : Themes.darkTheme.buttonTheme.colorScheme!
                                      .background,
                              child: IconButton(
                                  onPressed: () async {
                                    _clearScan();
                                  },
                                  icon: Icon(
                                    Icons.task_alt_outlined,
                                    color: Themes.darkTheme.buttonTheme
                                        .colorScheme!.surface,
                                  )),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              )
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
        overlayColor: _scannerOverlayColor,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.noPermission)),
      );
    }
  }

  Future<void> _getArticleTitle({required String? uuid}) async {
    print("IT TAKESSS");
    if (uuid != null && uuid.isNotEmpty) {
      var data = await ArticleService.fetchArticleByID(
        path: "http://89.252.140.57:8080/article/",
        uuid: uuid,
      );

      if (data == null) {
        setState(() {
          _articleData = data;
          _errorMessage = AppLocalizations.of(context)!.errorDataNotCorrect;
          _scannerBorderColor = Colors.red;
          _scannerOverlayColor = const Color.fromRGBO(255, 0, 0, 0.5);
        });
      } else {
        setState(() {
          _articleData = data;
          _errorMessage = null;
          _scannerBorderColor = Colors.green;
          _scannerOverlayColor = const Color.fromRGBO(0, 255, 0, 0.5);
        });
      }
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

  Future<void> _clearScan() async {
    setState(() {
      result = null;
      _errorMessage = null;
      _articleData = null;
      _scannerBorderColor = primary;
      _scannerOverlayColor = const Color.fromRGBO(0, 0, 0, 80);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    _scrollController.removeListener(_controlScroll);
    super.dispose();
  }
}
