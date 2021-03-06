import 'dart:async';

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
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();


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
      firstNameController = TextEditingController(text: firstName);
      lastNameController = TextEditingController(text: lastName);

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
           : Container(
         padding: EdgeInsets.fromLTRB(10, 80, 10, 0),
            width: 300,
             child: SingleChildScrollView(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.center,
         children: [
               ClipOval(
               child: Material(
               color: Colors.transparent,
                 child: Ink.image(
                   image:  AssetImage('assets/Images/mandala.png'),
                   fit: BoxFit.cover,
                   width: 200,
                   height: 200,
                   child: InkWell(onTap: (){}),
                 ),
               ),
                ),
               SizedBox(height: 30.0,),
               Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'First Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 1,
            ),
          ],
        ),
           SizedBox(height: 20.0,),
           Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   'Last Name',
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                 ),
                 const SizedBox(height: 8),
                 TextField(
                   controller: lastNameController,
                   decoration: InputDecoration(
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(12),
                     ),
                   ),
                   maxLines: 1,
                 ),
               ],
           ),
           SizedBox(height: 60.0,),
           Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 TextButton(
                   style: ButtonStyle(
                     backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                   ),
                   onPressed: () async {
                     await Provider.of<AuthService>(context, listen: false).updateProfile(
                       firstNameController.text,
                       lastNameController.text
                     );
                     final snackBar = SnackBar(
                       content: Container(child: Text('       Profile updated!', textAlign: TextAlign.right,)),
                       action: SnackBarAction(
                         label: '',
                         onPressed: () {
                           // Some code to undo the change.
                         },
                       ),
                     );
                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                     var timer = Timer(Duration(seconds: 3), () =>  load());
                   },
                   child: Text('Update Profile'),
                 )
               ],
           )
         ],
       ),
             ),
           ),
    );
  }

}
