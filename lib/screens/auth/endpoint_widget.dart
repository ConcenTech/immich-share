import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:album_share/core/utils/validators.dart';

class EndpointWidget extends ConsumerStatefulWidget {
  const EndpointWidget({
    required this.onEndpointSaved,
    super.key,
  });

  final VoidCallback onEndpointSaved;

  @override
  ConsumerState<EndpointWidget> createState() => _EndpointWidgetState();
}

class _EndpointWidgetState extends ConsumerState<EndpointWidget> {
  final _formKey = GlobalKey<FormState>();

  String endpoint = '';

  void _saveEndpoint() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      widget.onEndpointSaved();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(dummyProvider);

    return provider.maybeWhen(
      data: (data) {
        if (endpoint.isEmpty) {
          endpoint = data;
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  initialValue: endpoint,
                  validator: Validators.required,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'https://demo.immich.app',
                    labelText: 'Server url',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                label: const Text(
                  'Next',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                icon: const Icon(Icons.arrow_right_alt),
                iconAlignment: IconAlignment.end,
                onPressed: _saveEndpoint,
              ),
            ],
          ),
        );
      },
      orElse: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

final dummyProvider = FutureProvider((ref) => Future.value('HI!'));
