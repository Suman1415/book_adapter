// Handles Profile edit action

import 'package:book_adapter/model/user.dart';
import 'package:book_adapter/utils/user_preferences.dart';
import 'package:book_adapter/widget/appbar_widget.dart';
import 'package:book_adapter/widget/button_widget.dart';
import 'package:book_adapter/widget/profile_widget.dart';
import 'package:book_adapter/widget/textfield_widget.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User user = UserPreferences.myUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context, "Edit Profile"),
        body: ListView(
          
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            ProfileWidget(
              imagePath: user.imagePath,
              isEdit: true, 
              onClicked: () async {}
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: "Full Name", 
              text: user.name, 
              onChanged: (name){},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: "Email", 
              text: user.email, 
              onChanged: (email){},
            ), 
            Center(child: SubmitButton())
          ],
        ));
        
  }
  Widget SubmitButton() => ButtonWidget(
      text: 'Submit',
      onClicked: () {
        // TODO Submit action
      },
    );
}
