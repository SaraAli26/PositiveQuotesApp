import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qoutesapp/Models/UserModel.dart';

import '../Services/AuthService.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = "";
  String lastName = "";
  bool isLoading = false;

  void initState() {
    super.initState();
    load();
  }

  getFullName() async{
    return AuthService().getUserData();
  }

  load() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      UserModel c = await getFullName();
      firstName = c.firstName;
      lastName = c.lastName;
      if (mounted) {
        setState(() {
          isLoading = false;
          firstName = c.firstName;
          lastName = c.lastName;
        });
      }
    } catch (e) {
      print(e);
    }
    //_refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
       child: isLoading ?
       CircularProgressIndicator()
           : Column(
         children: [
           Text(firstName),
           Text(lastName),
           TextButton(
             style: ButtonStyle(
               backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
               foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
             ),
             onPressed: () {
               Provider.of<AuthService>(context, listen: false).logout();
             },
             child: Text('Log out'),
           )
         ],
       ),
    );
  }

}
