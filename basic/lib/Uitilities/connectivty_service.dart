import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends StatefulWidget {
  final Widget child;

  ConnectivityService({required this.child});

  static _ConnectivityServiceState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ConnectivityServiceState>();

  @override
  _ConnectivityServiceState createState() => _ConnectivityServiceState();
}

class _ConnectivityServiceState extends State<ConnectivityService> {
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _hasConnection = true;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription?.cancel();
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _hasConnection = result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  bool get hasConnection => _hasConnection;
}
