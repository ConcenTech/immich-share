import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'logo_widget.dart';
import 'window_titlebar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.showTitleBar,
    required this.body,
    super.key,
  });

  /// Display the title, logo and menu icon.
  final bool showTitleBar;

  final Widget body;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return Scaffold(
          appBar: showTitleBar
              ? AppBar(
                automaticallyImplyLeading: false,
                  title: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 25, child: LogoImage()),
                      SizedBox(width: 5),
                      LogoText(tagline: false),
                    ],
                  ),
                )
              : null,
          body: body,
        );
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return Scaffold(
          body: Column(
            children: [
              DesktopWindowTitlebar(showTitle: showTitleBar),
              Expanded(child: body),
            ],
          ),
        );
    }
  }
}
