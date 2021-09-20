import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qoutesapp/Services/AuthService.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool checkCurrentPassword = true;

  @override
  Widget build(BuildContext context) {
    var currentTime = DateTime.now();

    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.teal),
            title: Text(
              currentTime.hour < 12 ? "Good Morning" : "Good Evening!",
              style: TextStyle(color: Colors.teal),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            brightness: Brightness.light),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 80, 10, 0),
            width: 300,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    controller: oldPasswordController,
                    decoration: InputDecoration(
                      labelText: "Enter Your Current Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    maxLines: 1,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please Enter the old password';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      labelText: "Enter Your New Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please Enter the new password';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    controller: confirmedPasswordController,
                    decoration: InputDecoration(
                      labelText: "Confirm Your New Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      return newPasswordController.text == value
                          ? null
                          : "Please Validate your entered matched password";
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.teal),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            checkCurrentPassword = await AuthService()
                                .ChangePassword(oldPasswordController.text,
                                    confirmedPasswordController.text);
                            if (checkCurrentPassword) {
                              final snackBar = SnackBar(
                                content: Container(
                                    child: Text(
                                  'Password updated successfully!',
                                )),
                                action: SnackBarAction(
                                  label: '',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              var timer = Timer(Duration(seconds: 2),
                                  () => Navigator.pop(context));
                            } else {
                              final snackBar = SnackBar(
                                content: Container(
                                    child: Text(
                                  'Change Password failed! Please make sure you inserted the right old passwrod!',
                                )),
                                action: SnackBarAction(
                                  label: '',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);

                              //Navigator.pop(context);
                            }
                          }
                        },
                        child: Text('Update Password'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
