import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/feature/data/datasources/firebase_network_calls.dart';
import 'package:notes/feature/presentation/home_components/constants/constants.dart';
import 'package:notes/feature/presentation/home_components/pages/homepage.dart';
import 'package:notes/feature/presentation/home_components/bloc/notes_bloc.dart';
import 'package:notes/feature/presentation/home_components/bloc/notes_event.dart';
import 'package:notes/feature/presentation/home_components/bloc/notes_state.dart';

class NotesAddPage extends StatefulWidget {
  const NotesAddPage({super.key});

  @override
  State<NotesAddPage> createState() => _NotesAddPageState();
}

class _NotesAddPageState extends State<NotesAddPage> {
  final headingController = TextEditingController();

  final descriptionController = TextEditingController();
  final labelController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool onChanged = false;
  List<String> label = [];
  List<String> selectedDepartments = [];
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff0E121B),
        appBar: AppBar(
          backgroundColor: const Color(0xff0E121B),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                style: GoogleFonts.poppins(color: Colors.white),
                controller: headingController,
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    hintText: HomePageConstants.enterTitle,
                    hintStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w500)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: GoogleFonts.poppins(color: Colors.white),
                controller: descriptionController,
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    hintText: HomePageConstants.addYourNote,
                    hintStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w300)),
              ),
              TextFormField(
                style: GoogleFonts.poppins(color: Colors.white),
                controller: labelController,
                decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    hintText: HomePageConstants.addTag,
                    hintStyle: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w300)),
              ),
              BlocBuilder<NotesBloc, NotesState>(
                bloc: NotesBloc()..add(NotesDataFetchEvent()),
                builder: (context, state) {
                  if (state is NotesDataFetchSuccessState) {
                    return Center(
                      child: FutureBuilder(
                        future: FirebaseNetworkCalls().data(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<String> departments = snapshot.data!
                                .map((e) => e.tag!)
                                .toSet()
                                .toList();

                            return SizedBox(
                              height: 50,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                      departments.map((String department) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: department.isEmpty
                                          ? null
                                          : FilterChip(
                                              selectedColor:
                                                  const Color(0xff007AFE),
                                              checkmarkColor: Colors.white,
                                              backgroundColor:
                                                  const Color(0xff202737),
                                              label: Text(department,
                                                  style: GoogleFonts.poppins(
                                                    color: isSelected
                                                        ? const Color(
                                                            0xff0B5FB3)
                                                        : Colors.white,
                                                    fontSize: 15,
                                                  )),
                                              selected: selectedDepartments
                                                  .contains(department),
                                              onSelected: (bool selected) {},
                                            ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    );
                  }
                  if (state is NotesDataFetchFailureState) {
                    return const Center(child: Text(HomePageConstants.error));
                  }
                  if (state is NotesDataFetchLoadingState) {
                    return const CircularProgressIndicator();
                  }
                  return const SizedBox();
                },
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                    onPressed: () {
                      if (descriptionController.text.isNotEmpty ||
                          headingController.text.isNotEmpty) {
                        NotesBloc().add(NotesActionEvent(
                            tag: labelController.text,
                            heading: headingController.text,
                            description: descriptionController.text));
                        const snackBar = SnackBar(
                          content: Text(HomePageConstants.addedSuccessfully),
                          backgroundColor: Colors.blue,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      } else {
                        const snackBar = SnackBar(
                          content: Text(HomePageConstants.pleaseAddSomeNotes),
                          backgroundColor: Colors.red,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text(
                      HomePageConstants.add,
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        )));
  }
}
