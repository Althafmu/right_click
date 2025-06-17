import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:right_click/widget/context_menu_interceptor.dart';

class ContextMenu extends StatefulWidget {
  final Widget child;

  const ContextMenu({super.key, required this.child});

  @override
  State<ContextMenu> createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextMenu> {
  final GlobalKey _childKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  Offset _position = Offset.zero;

  void _showContextMenu(BuildContext context, Offset position) {
    _removeContextMenu();

    final RenderBox renderBox =
        _childKey.currentContext!.findRenderObject() as RenderBox;
    final childSize = renderBox.size;
    final screenSize = MediaQuery.of(context).size;

    // Calculate the position ensuring the menu stays within screen bounds
    double x = position.dx;
    double y = position.dy;

    const menuWidth = 150.0;
    const menuHeight = 150.0;

    if (x + menuWidth > screenSize.width) {
      x = screenSize.width - menuWidth;
    }
    if (y + menuHeight > screenSize.height) {
      y = screenSize.height - menuHeight;
    }

    _position = Offset(x, y);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              Positioned(
                left: _position.dx,
                top: _position.dy,
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    width: menuWidth,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Create'),
                          onTap: () {
                            _removeContextMenu();
                          },
                        ),
                        ListTile(
                          title: const Text('Edit'),
                          onTap: () {
                            _removeContextMenu();
                          },
                        ),
                        ListTile(
                          title: const Text('Remove'),
                          onTap: () {
                            _removeContextMenu();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeContextMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeContextMenu();
    super.dispose();
  }

  // Determine if the device is considered "mobile" (small screen or touch-based)
  bool _isMobile(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Consider mobile if screen width is less than 600 (common breakpoint for tablets)
    // or if the platform is typically touch-based
    return screenWidth < 600 ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    return Interceptor(
      child: GestureDetector(
        // Handle right-click for desktop platforms (web and native)
        onSecondaryTapDown: (details) {
          _showContextMenu(context, details.globalPosition);
        },
        // Handle tap for mobile platforms (web and native)
        onTapDown: (details) {
          if (_isMobile(context)) {
            _showContextMenu(context, details.globalPosition);
          }
        },
        child: Container(key: _childKey, child: widget.child),
      ),
    );
  }
}
