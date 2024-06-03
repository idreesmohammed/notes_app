import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupWithGoogle {
  Future<UserCredential> signupWithGoogle() async {
    GoogleSignInAccount? userCred = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await userCred?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential;
  }
}
