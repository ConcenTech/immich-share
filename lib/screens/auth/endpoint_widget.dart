import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EndpointWidget extends ConsumerStatefulWidget {
  const EndpointWidget({super.key});

  @override
  ConsumerState<EndpointWidget> createState() => _EndpointWidgetState();
}

class _EndpointWidgetState extends ConsumerState<EndpointWidget> {
  String endpoint = '';

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
              TextFormField(
                initialValue: endpoint,
                
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: Text('Save'),
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
