import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html if (dart.library.io) 'dart:io';

class Interceptor extends StatelessWidget {
  final Widget child;

  const Interceptor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Disable default context menu on web
      html.document.onContextMenu.listen((event) => event.preventDefault());
    }
    return child;
  }
}
