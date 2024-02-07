import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("TODO App"),
          actions: [
            IconButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                icon: const Icon(Icons.logout))
          ],
        ),
        body: const BodyClass(),
        floatingActionButton: const FloatingActionClass());
  }
}

class BodyClass extends StatefulWidget {
  const BodyClass({super.key});

  @override
  State<BodyClass> createState() => _BodyClassState();
}

class _BodyClassState extends State<BodyClass> {
  String uid = '';

  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("UID: "+uid);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .doc(uid)
            .collection("mytasks")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final doc = snapshot.data!.docs;
            return ListView.builder(
                itemCount: doc.length,
                itemBuilder: (context, index) {
                  var time = doc[index].id;
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text("${index + 1}"),
                      ),
                      title: Text(doc[index]['title']),
                      subtitle: Text(doc[index]['description']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteData(time),
                      ),
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  deleteData(String time) async {
    // print("time: $time");
    try {
      await FirebaseFirestore.instance
          .collection("tasks")
          .doc(uid)
          .collection("mytasks")
          .doc(time)
          .delete();
    } catch (e) {
      print(e);
    }
  }
}

class FloatingActionClass extends StatelessWidget {
  const FloatingActionClass({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            final taskKey = GlobalKey<FormState>();
            TextEditingController titleController = TextEditingController();
            TextEditingController descController = TextEditingController();
            return AlertDialog(
              title: const Text("Enter Task"),
              content: Form(
                key: taskKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        label: const Text("Enter Title"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: RequiredValidator(errorText: "Required"),
                      controller: titleController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        label: const Text("Enter Description"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: RequiredValidator(errorText: "Required"),
                      controller: descController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusManager.instance.primaryFocus!.unfocus();
                          if (taskKey.currentState!.validate()) {
                            try {
                              User? user = FirebaseAuth.instance.currentUser;
                              await FirebaseFirestore.instance
                                  .collection("tasks")
                                  .doc(user!.uid)
                                  .collection("mytasks")
                                  .doc(DateTime.now().toString())
                                  .set({
                                "title": titleController.text.toString(),
                                "description": descController.text.toString()
                              }).then((value) {
                                Fluttertoast.showToast(msg: "Task Added");
                                Navigator.pop(context);
                              });
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: const Text("Add Task"),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
