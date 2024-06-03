import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/feature/presentation/home_components/constants/constants.dart';
import 'package:notes/feature/presentation/home_components/pages/homepage.dart';
import 'package:notes/feature/presentation/login_components/bloc/login_bloc.dart';
import 'package:notes/feature/presentation/login_components/bloc/login_event.dart';
import 'package:notes/feature/presentation/login_components/bloc/login_state.dart';
import 'package:notes/feature/presentation/login_components/constants/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E121B),
      body: BlocConsumer<LoginBloc, LoginState>(
        bloc: context.read<LoginBloc>(),
        listener: (context, state) {
          if (state is LoginCredentialNullState) {
            const snackBar = SnackBar(
              content: Text(HomePageConstants.error),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          if (state is LoginSuccessState) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          }
        },
        builder: (context, state) {
          if (state is LoginLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
              child: InkWell(
            onTap: () => context.read<LoginBloc>().add(LoginActionEvent()),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: state is LoginLoadingState
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Center(
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(FontAwesomeIcons.google,
                              color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            LoginConstants.signUpUsingGoogle,
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      )),
              ),
            ),
          ));
        },
      ),
    );
  }
}
