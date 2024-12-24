import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexagonal_architecture_dart/adapter/in/controllers/shop_controller.dart';

class CreateShopView extends ConsumerStatefulWidget {
  const CreateShopView({super.key});

  @override
  ConsumerState createState() => _CreateShopViewState();
}

class _CreateShopViewState extends ConsumerState<CreateShopView> {

  final titleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Shop'),),
      body: Center(
        child: Column(
        children: [
          TextField(
            controller: titleController,
          ),
          ElevatedButton(
            onPressed: () async {
                try {
                  await ref.read(shopControllerProvider.notifier).createItem(titleController.text);
                  ref.invalidate(shopControllerProvider);

                  if(context.mounted) {
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  if(context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('エラーが発生しました: $e')),
                    );
                  }
                }
            },
            child: const Text('Create'),
          )
        ],
      )),
    );
  }
}
