// Handles Profile edit action

import 'package:book_adapter/controller/firebase_controller.dart';
import 'package:book_adapter/features/profile/edit_profile_view_controller.dart';
import 'package:book_adapter/features/profile/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditProfileView extends HookConsumerWidget {
  const EditProfileView({Key? key}) : super(key: key);

  static const routeName = '/editProfile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStreamAsyncValue = ref.watch(userChangesProvider);
    final user = userStreamAsyncValue.asData?.value;
    final viewController = ref.watch(editProfileViewController.notifier);
    final usernameController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // TODO: Will never show because there is no way to set the photo
              if (user != null && user.photoURL != null) ... [
                ProfileWidget(
                  photoUrl: user.photoURL!,
                  onPressed: () async {}
                ),
                const SizedBox(height: 24),
              ],
      
              TextField(
                restorationId: 'change_username',
                controller: usernameController,
                autofillHints: const [AutofillHints.name],
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Change Username' ),
                onChanged: (usernameValue) {
                  viewController.updateData(username: usernameValue);
                },
              ),
              const SizedBox(height: 24),
      
              // TODO: Add change email function. Will need to ask for current password.
              // TextFieldWidget(
              //   label: 'Email', 
              //   text: user.email ?? 'Signed in anonymously', 
              //   onChanged: (email) {
              //     // TODO: Save email in controller
              //   },
              // ), 
              const _SubmitButton()
            ],
          ),
        ),
      )
    );    
  }
}

class _SubmitButton extends ConsumerWidget {
  const _SubmitButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(editProfileViewController);
    final viewController = ref.watch(editProfileViewController.notifier);
    return ElevatedButton(
      child: const Text('Submit', style: TextStyle(fontSize: 20.0)),
      onPressed: () async {
        final success = await viewController.submit();
        if (!success) {
            const snackBar = SnackBar(
              content: Text('Updating Userdata Failed')
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          Navigator.of(context).pop();
          final snackBar = SnackBar(
            content: Text('Updated Username to ${data.username}')
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
  }
}