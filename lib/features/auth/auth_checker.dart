import 'package:book_adapter/controller/firebase_controller.dart';
import 'package:book_adapter/features/auth/login_view.dart';
import 'package:book_adapter/features/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStreamAsyncValue = ref.watch(authStateChangesProvider);

    return userStreamAsyncValue.when(
      data: (user) {
        if (user == null) {
          // Route to login screen
          return LoginView();
        }
        // Route to user screen
        return child;
      },
      loading: (userAsync) => const LoadingView(),
      error: (e, st, userAsync) => Scaffold(body: Center(child: Text('Error: $e'),),),
    );
  }
}

