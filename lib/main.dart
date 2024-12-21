import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexagonal_architecture_dart/adapter/in/views/app.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}