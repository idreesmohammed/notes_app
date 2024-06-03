// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/feature/data/datasources/firebase_network_calls.dart';
import 'package:notes/feature/presentation/home_components/constants/constants.dart';
import 'package:notes/feature/presentation/home_components/pages/notes_add_page.dart';
import 'package:notes/feature/presentation/home_components/bloc/notes_bloc.dart';
import 'package:notes/feature/presentation/home_components/bloc/notes_event.dart';
import 'package:notes/feature/presentation/home_components/bloc/notes_state.dart';
import 'package:notes/feature/presentation/home_components/pages/profile_view.dart';
import 'package:notes/feature/data/model/notesmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> selectedDepartments = [];
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E121B),
      appBar: AppBar(
        backgroundColor: const Color(0xff0E121B),
        leading: const Icon(Icons.menu),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () async {
                ProfileView().showAlertDialog(context);
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    image: FirebaseAuth.instance.currentUser!.photoURL == null
                        ? const DecorationImage(image: NetworkImage(''))
                        : DecorationImage(
                            image: NetworkImage(FirebaseAuth
                                .instance.currentUser!.photoURL
                                .toString())),
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<NotesBloc, NotesState>(
          bloc: context.read<NotesBloc>()..add(NotesDataFetchEvent()),
          builder: (context, state) {
            if (state is NotesDataFetchSuccessState) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Center(
                  child: FutureBuilder(
                    future: FirebaseNetworkCalls().data(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<String> departments = snapshot.data!
                            .map((e) => e.tag ?? '')
                            .toSet()
                            .toList();
                        List<NotesModel> filteredNotes =
                            selectedDepartments.isEmpty
                                ? snapshot.data!
                                : snapshot.data!.where((employee) {
                                    return selectedDepartments
                                        .contains(employee.tag);
                                  }).toList();
                        return Column(children: [
                          Row(
                            children: [
                              Text(
                                DateFormat(HomePageConstants.dateFormat)
                                    .format(DateTime.now()),
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900),
                              )
                            ],
                          ),
                          snapshot.data!
                                  .map((e) => e.description)
                                  .toList()
                                  .isEmpty
                              ? Text(HomePageConstants.addNotesMessage,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800))
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children:
                                        departments.map((String department) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: department == ''
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
                                                onSelected: (bool selected) {
                                                  setState(() {
                                                    isSelected = !isSelected;
                                                    if (selected) {
                                                      selectedDepartments
                                                          .add(department);
                                                    } else {
                                                      selectedDepartments
                                                          .remove(department);
                                                    }
                                                  });
                                                },
                                              ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                          SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.7,
                              child: GridView.custom(
                                gridDelegate: SliverWovenGridDelegate.count(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  pattern: [
                                    const WovenGridTile(1),
                                    const WovenGridTile(
                                      5 / 7,
                                      crossAxisRatio: 0.9,
                                      alignment: AlignmentDirectional.centerEnd,
                                    ),
                                  ],
                                ),
                                childrenDelegate: SliverChildBuilderDelegate(
                                  childCount: filteredNotes.length,
                                  (context, index) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xff202737),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              filteredNotes[index].heading,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  filteredNotes[index]
                                                      .description,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ),
                                            filteredNotes[index].tag == ""
                                                ? const Text("")
                                                : Container(
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xff0E121B),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        filteredNotes[index]
                                                            .tag!,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )),
                          const Spacer(),
                          const Divider(color: Colors.grey),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NotesAddPage()));
                            },
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: const Color(0xff007AFE))),
                                  child: const Icon(Icons.add,
                                      color: Color(0xff007AFE)),
                                ),
                                Text(HomePageConstants.addNotes,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                          if (snapshot.data!.map((e) => e).isNotEmpty)
                            const Expanded(
                                child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: SizedBox(height: 20),
                            ))
                        ]);
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              );
            }
            if (state is NotesDataFetchFailureState) {
              return const Center(child: Text(HomePageConstants.error));
            }
            if (state is NotesDataFetchLoadingState) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Color(0xff202737),
              ));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
