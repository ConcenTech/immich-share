import 'package:flutter/material.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'LogoImageWidget',
      child: Image.asset('assets/logo.png'),
    );
  }
}

class LogoText extends StatelessWidget {
  const LogoText({this.tagline = true, super.key});

  final bool tagline;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Hero(
      tag: 'LogoTextWidget',
      child: RichText(
        text: TextSpan(
          text: 'Album share',
          style: tagline ? textTheme.headlineMedium : textTheme.titleMedium,
          children: [
            if (tagline)
              TextSpan(
                text: '\nAn unofficial Immich client',
                style: textTheme.labelMedium,
              ),
          ],
        ),
      ),
    );
  }
}
