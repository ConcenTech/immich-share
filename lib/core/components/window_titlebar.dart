import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'logo_widget.dart';

const _desktopPlatforms = [
  TargetPlatform.linux,
  TargetPlatform.macOS,
  TargetPlatform.windows,
];

class DesktopWindowTitlebar extends StatelessWidget {
  const DesktopWindowTitlebar({
    this.showTitle = true,
    super.key,
  });

  static void openWindow() {
    if (_desktopPlatforms.contains(defaultTargetPlatform)) {
      doWhenWindowReady(() {
        appWindow.show();
      });
    }
  }

  /// If true, displays the app logo and name in the top bar.
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    assert(_desktopPlatforms.contains(defaultTargetPlatform));

    return WindowTitleBarBox(
      child: Row(
        children: [
          Expanded(
            child: MoveWindow(
              child: showTitle
                  ? Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 40),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LogoImage(),
                            SizedBox(width: 5),
                            LogoText(tagline: false),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          MinimizeWindowButton(),
          MaximizeWindowButton(),
          CloseWindowButton(),
        ],
      ),
    );
  }
}
