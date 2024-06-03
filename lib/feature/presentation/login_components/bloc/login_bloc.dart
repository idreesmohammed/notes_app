import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes/feature/data/datasources/firebase_network_calls.dart';
import 'package:notes/feature/domain/usecases/signup_with_google.dart';
import 'package:notes/feature/presentation/login_components/bloc/login_event.dart';
import 'package:notes/feature/presentation/login_components/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginActionEvent>(
      (event, emit) async {
        emit(LoginLoadingState());
        GoogleSignInAccount? userCred = await GoogleSignIn().signIn();
        try {
          if (userCred == null) {
            emit(LoginCredentialNullState());
          }
          final userCredential = await SignupWithGoogle().signupWithGoogle();
          User? user = userCredential.user;
          bool isNewUser = userCredential.additionalUserInfo!.isNewUser;
          if (isNewUser) {
            await FirebaseNetworkCalls().initialSetCall(user);
          }
          emit(LoginSuccessState(userCredential: user!));
        } catch (e) {
          emit(LoginFailState());
        }
      },
    );
  }
}
