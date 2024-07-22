import 'dart:async';

import 'package:ACAC/presentation_layer/pages/user_auth/no_wifi.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  final Function(bool)
      onConnectionChange; // Callback to notify about connection changes

  ConnectivityWrapper({required this.child, required this.onConnectionChange});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  bool isConnected = false;
  StreamSubscription? internetConnectionStream;

  @override
  void initState() {
    super.initState();
    internetConnectionStream =
        InternetConnection().onStatusChange.listen((event) {
      bool connectionStatus = event == InternetStatus.connected;
      setState(() {
        isConnected = connectionStatus;
      });
      widget.onConnectionChange(
          connectionStatus); // Notify about connection status
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: isConnected ? widget.child : NoInternetScreen());
  }

  @override
  void dispose() {
    internetConnectionStream?.cancel();
    super.dispose();
  }
}
