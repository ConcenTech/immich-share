import 'package:album_share/core/components/window_titlebar.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import '../../core/components/app_scaffold.dart';
import '../../core/components/logo_widget.dart';
import 'endpoint_widget.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const DesktopWindowTitlebar(),
          Expanded(
            child: Center(
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Back'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showTitleBar: false,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: const Card(
            child: SingleChildScrollView(
                   padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 45,
                    child: LogoImage(),
                  ),
                  LogoText(),
                  SizedBox(height: 10),
                  AuthScreenContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthScreenContent extends StatefulWidget {
  const AuthScreenContent({super.key});

  @override
  State<AuthScreenContent> createState() => _AuthScreenContentState();
}

class _AuthScreenContentState extends State<AuthScreenContent> {
  _State _state = _State.endpoint;

  @override
  Widget build(BuildContext context) {
    return switch (_state) {
      _State.endpoint => EndpointWidget(
          onEndpointSaved: () {
            // setState(() {
            //   _state = _State.login;
            // });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const TestScreen(),
              ),
            );
          },
        ),
      _State _ => const Placeholder(),
    };
  }
}

enum _State {
  endpoint,
  login,
  oauth,
  resetPassworrd,
}
