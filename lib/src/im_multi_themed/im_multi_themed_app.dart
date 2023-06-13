import 'package:flutter/material.dart';

import 'im_multi_theme_controller.dart';
import 'im_multi_theme_provider.dart';

export 'context_extensions.dart';

class ImMultiThemedApp extends StatefulWidget {
  final Widget app;
  final Map<String, ThemeData>? initialThemes;

  const ImMultiThemedApp({
    super.key,
    required this.app,
    this.initialThemes,
  });

  @override
  State<ImMultiThemedApp> createState() => _ImMultiThemedAppState();
}

class _ImMultiThemedAppState extends State<ImMultiThemedApp> {
  late final controller = ImMultiThemeController(
    themes: widget.initialThemes ?? {'default': ThemeData()},
  );

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ImMultiThemeProvider(
      controller: controller,
      child: widget.app,
    );
  }
}
