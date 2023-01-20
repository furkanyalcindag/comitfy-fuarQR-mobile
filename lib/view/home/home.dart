import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuar_qr/core/config/app_config.dart';
import 'package:fuar_qr/core/services/participant/models/participant_validate_model.dart';
import 'package:fuar_qr/core/services/participant/participant_manager.dart';
import 'package:fuar_qr/core/utility/constants.dart';
import 'package:fuar_qr/core/utility/theme_choice.dart';
import 'package:fuar_qr/core/utility/themes.dart';
import 'package:fuar_qr/view/componentbuilders/qrscanner_user_information_builder.dart';
import 'package:fuar_qr/view/components/slide_menu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Data
  bool _isCameraPaused = true;
  bool _isFlashActive = false;
  bool _isUserInfoScrollScrollable = false;
  bool _isShowUserInfoScrollHasMoreDataButton = false;
  bool _isShowUserInfoOnScreenEnabled = false;
  var scanAreaHeight;
  var scanAreaWidth;
  Barcode? result;
  ParticipantValidateModel? _validatedParticipantData;
  String? _errorMessage;
  late final _participantValidateURL = AppConfig.of(context)!.baseURL +
      AppConfig.of(context)!.participantValidatePath;

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
      setState(() {
        _isCameraPaused = true;
      });
    }
    _toggleCameraPause();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestCameraPermission();
    });
    _scrollController = ScrollController()..addListener(_controlScroll);
  }

  /// Request the files permission and updates the UI accordingly
  Future<void> _requestCameraPermission() async {
    PermissionStatus result;

    // We need to check the platform before requesting
    result = await Permission.camera.request();

    if (result.isDenied || result.isPermanentlyDenied || result.isRestricted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.errorNoPermission)),
      );
    }
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
    if (_isShowUserInfoOnScreenEnabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isUserInfoScrollScrollable =
            _scrollController.position.maxScrollExtent > 0;
        _controlScroll();
      });
    }

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
                child: _isShowUserInfoOnScreenEnabled
                    ? SafeArea(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // User Detail Texts -------------------IMPORTANT
                                      if (_validatedParticipantData !=
                                          null) ...[
                                        if (_errorMessage == null) ...[
                                          buildQrCodeUserInfo(
                                            context: context,
                                            info: {
                                              AppLocalizations.of(context)!
                                                      .name:
                                                  "${_validatedParticipantData?.fairParticipantDTO?.firstName} | ${_validatedParticipantData?.fairParticipantDTO?.lastName}\n",
                                              AppLocalizations.of(context)!
                                                      .companyName:
                                                  "${_validatedParticipantData?.fairParticipantDTO?.companyName}\n",
                                              AppLocalizations.of(context)!
                                                      .telNo:
                                                  "${_validatedParticipantData?.fairParticipantDTO?.mobilePhone}\n",
                                              AppLocalizations.of(context)!
                                                      .email:
                                                  "${_validatedParticipantData?.fairParticipantDTO?.email}",
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
                      )
                    : const SizedBox(),
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
                    if (_validatedParticipantData != null)
                      // Is it Accepted Or NOT -------------------------IMPORTANT
                      Text(
                        _validatedParticipantData?.valid != null &&
                                _validatedParticipantData?.valid == true
                            ? AppLocalizations.of(context)!.participantAllowed
                            : AppLocalizations.of(context)!
                                .errorParticipantNotAllowed,
                        style: Theme.of(context).textTheme.bodyLarge!.merge(
                              TextStyle(
                                  color:
                                      _validatedParticipantData?.valid == true
                                          ? successColor
                                          : errorColor),
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
                            shape: const CircleBorder(),
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
                            shape: const CircleBorder(),
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
                        if (_validatedParticipantData != null ||
                            _errorMessage != null)
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: Material(
                              shape: const CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              color: Themes.darkTheme.buttonTheme.colorScheme!
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
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    _toggleCameraPause();
    controller.scannedDataStream.listen((scanData) async {
      if (result?.code != scanData.code) {
        _validateParticipant(uuid: scanData.code);
        setState(() {
          result = scanData;
        });
      }
    });
  }

  Future<void> _validateParticipant({required String? uuid}) async {
    log("It took uuid now trying to validate...");
    if (uuid != null && uuid.isNotEmpty) {
      var data = await ParticipantService.fetchValidateParticipantByID(
        path: _participantValidateURL,
        uuid: uuid,
      );

      if (data == null) {
        setState(() {
          _validatedParticipantData = data;
          _errorMessage = AppLocalizations.of(context)!.errorDataNotCorrect;
          _scannerBorderColor = Colors.red;
          _scannerOverlayColor = const Color.fromRGBO(255, 0, 0, 0.5);
        });
      } else {
        if (data.valid != false) {
          controller?.pauseCamera();
          setState(() {
            _isCameraPaused = true;
            _validatedParticipantData = data;
            _errorMessage = null;
            _scannerBorderColor = Colors.green;
            _scannerOverlayColor = const Color.fromRGBO(0, 255, 0, 0.5);
          });
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              backgroundColor:
                  Theme.of(context).dialogBackgroundColor.withOpacity(0.8),
              content: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: buildQrCodeUserInfo(
                  context: context,
                  textColor: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .color!
                      .withOpacity(0.9),
                  info: {
                    AppLocalizations.of(context)!.name:
                        "${data.fairParticipantDTO?.firstName} | ${data.fairParticipantDTO?.lastName}\n",
                    AppLocalizations.of(context)!.companyName:
                        "${data.fairParticipantDTO?.companyName}\n",
                    AppLocalizations.of(context)!.telNo:
                        "${data.fairParticipantDTO?.mobilePhone}\n",
                    AppLocalizations.of(context)!.email:
                        "${data.fairParticipantDTO?.email}\n",
                    AppLocalizations.of(context)!.city:
                        "${data.fairParticipantDTO?.city}",
                  },
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: Text(AppLocalizations.of(context)!.iRead),
                ),
              ],
            ),
          ).then((value) {
            setState(() {
              _isCameraPaused = false;
            });
            controller?.resumeCamera();
            _clearScan();
          });
          return;
        } else {
          setState(() {
            _validatedParticipantData = data;
            _errorMessage =
                AppLocalizations.of(context)!.errorParticipantNotAllowed;
            _scannerBorderColor = Colors.red;
            _scannerOverlayColor = const Color.fromRGBO(255, 0, 0, 0.5);
          });
        }
      }
    }
  }

  Future<void> _toggleCameraPause() async {
    if (_isCameraPaused) {
      setState(() {
        _isCameraPaused = false;
      });
      await controller?.resumeCamera();
      return;
    }
    setState(() {
      _isCameraPaused = true;
    });
    await controller?.pauseCamera();
  }

  Future<void> _toggleFlash() async {
    bool? currentFlashStatus = await controller?.getFlashStatus();
    if (currentFlashStatus != null) {
      if (currentFlashStatus == true) {
        setState(() {
          _isFlashActive = false;
        });
      } else {
        setState(() {
          _isFlashActive = true;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.errorNoController)),
      );
    }

    await controller?.toggleFlash();
  }

  Future<void> _clearScan() async {
    setState(() {
      result = null;
      _errorMessage = null;
      _validatedParticipantData = null;
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
