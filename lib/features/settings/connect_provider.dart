import 'dart:async';

import 'package:ACAC/common/services/no_wifi.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  ConnectivityWrapper({required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  bool isConnected = false;
  bool isLoading = true;
  StreamSubscription? internetConnectionStream;

  @override
  void initState() {
    super.initState();
    internetConnectionStream =
        InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnected = true;
            isLoading = false;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnected = false;
            isLoading = false; // Update the loading state
          });
          break;
        default:
          setState(() {
            isConnected = false;
            isLoading = false; // Update the loading state
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show a loading indicator while determining connectivity status
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      // Show the child widget if connected, otherwise show NoInternetScreen
      return Scaffold(
        body: isConnected ? widget.child : const NoInternetScreen(),
      );
    }
  }

  @override
  void dispose() {
    internetConnectionStream?.cancel();
    super.dispose();
  }
}
