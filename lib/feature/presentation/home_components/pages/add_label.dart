import 'package:flutter/material.dart';
import 'package:notes/feature/data/datasources/firebase_network_calls.dart';

class AddLabel extends StatefulWidget {
  const AddLabel({super.key});

  @override
  State<AddLabel> createState() => _AddLabelState();
}

class _AddLabelState extends State<AddLabel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: FirebaseNetworkCalls().data(),
        builder: (context, snapshot) {
          snapshot.hasData
              ? ListView.builder(itemBuilder: (context, index) {
                  return Text(snapshot.data![index].tag.toString());
                })
              : const CircularProgressIndicator();
          return const SizedBox();
        },
      ),
    );
  }
}
