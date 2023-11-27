import 'package:code_mid/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            ref.read(userMeProvider.notifier).logout();
          },
          child: const Text('logout')),
    );
  }
}
