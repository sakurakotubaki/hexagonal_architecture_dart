import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexagonal_architecture_dart/adapter/in/controllers/shop_controller.dart';
import 'package:hexagonal_architecture_dart/adapter/in/views/create_shop_view.dart';

class UserListView extends ConsumerWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shops = ref.watch(shopControllerProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateShopView()));
          }, icon: Icon(Icons.add))
        ],
        title: const Text('User List'),
      ),
      body: switch(shops) {
        AsyncData data => ListView.builder(
          itemCount: data.value.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(data.value[index].item),
            subtitle: Text("${data.value[index].id}"),
            trailing: IconButton(onPressed: () {
              ref.read(shopControllerProvider.notifier).deleteItem(data.value[index].id);
              ref.invalidate(shopControllerProvider);
            }, icon: Icon(Icons.delete)),
          ),
        ),
        AsyncError() => const Center(child: Text('Error')),
        _ => const Center(child: CircularProgressIndicator()),
      }
    );
  }
}
