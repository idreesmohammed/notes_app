import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/global_constants.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/feature/presentation/home_components/pages/homepage.dart';
import 'package:notes/feature/presentation/login_components/bloc/login_bloc.dart';
import 'package:notes/feature/presentation/login_components/pages/loginpage.dart';
import 'package:notes/feature/presentation/home_components/bloc/notes_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Notes());
}

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginBloc()),
          BlocProvider(create: (context) => NotesBloc()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: StreamBuilder(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    uid.add(snapshot.data!.uid);
                    userDetails.add(snapshot.data!.displayName!);
                    userDetails.add(snapshot.data!.photoURL!);
                    return const HomePage();
                  }

                  return const LoginPage();
                })));
  }
}
