import 'package:flutter/material.dart';
import 'package:im_themed/src/im_themed/im_theme_controller.dart';

import 'im_theme_provider.dart';

export 'context_extensions.dart';

class ImThemedApp extends StatefulWidget {
  final Widget app;
  final ThemeData? initialTheme;

  const ImThemedApp({
    super.key,
    required this.app,
    this.initialTheme,
  });

  @override
  State<ImThemedApp> createState() => _ImThemedAppState();
}

class _ImThemedAppState extends State<ImThemedApp> {
  late final controller = ImThemeController(widget.initialTheme ?? ThemeData());

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        /// set theme
        controller.setTheme(widget.initialTheme ?? ThemeData(), notify: false);
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ImThemeProvider(
      controller: controller,
      child: widget.app,
    );
  }
}
