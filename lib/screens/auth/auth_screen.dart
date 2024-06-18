import 'package:flutter/material.dart';
import 'package:immich_share/screens/auth/endpoint_widget.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: const Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 60,
                    child: FlutterLogo(),
                  ),
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
      _State.endpoint => const EndpointWidget(),
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
