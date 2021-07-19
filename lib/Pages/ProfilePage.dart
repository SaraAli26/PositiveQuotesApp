import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Services/AuthService.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Center(
       child: TextButton(
         style: ButtonStyle(
           backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
           foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
         ),
         onPressed: () {
           Provider.of<AuthService>(context, listen: false).logout();
         },
         child: Text('Log out'),
       ),
    );
  }

}
