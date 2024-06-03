import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/global_constants.dart';
import 'package:notes/feature/presentation/home_components/constants/constants.dart';
import 'package:notes/feature/presentation/login_components/pages/loginpage.dart';

class ProfileView {
  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(HomePageConstants.logOut,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
      onPressed: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
        await FirebaseAuth.instance.signOut();
      },
    );
    Widget cancelButton = TextButton(
      child: Text(HomePageConstants.cancel,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(userDetails[1]))),
      ),
      content: Text(userDetails[0],
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
      actions: [okButton, cancelButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
