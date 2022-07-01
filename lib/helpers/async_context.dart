import 'package:flutter/material.dart';

class AsyncContext {
  const AsyncContext();

  Future<void> asyncMethod(BuildContext context, VoidCallback onSuccess) async {
    await Future.delayed(const Duration(seconds: 2));
    onSuccess.call();
  }
}
