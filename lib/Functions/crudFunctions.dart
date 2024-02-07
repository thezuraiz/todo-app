import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

createFunc(
    TextEditingController titleController,
    TextEditingController descController,
    final taskKey,
    BuildContext context) async {
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
}

readData<Widget>(BuildContext context) {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .doc(uid)
          .collection("mytasks")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final doc = snapshot.data!.docs;
          // final doc = snapshot.data!.docs.reversed.toList();
          return ListView.builder(
              itemCount: doc.length,
              itemBuilder: (context, index) {
                final time = doc[index].id;
                final String title = doc[index]['title'];
                final String description = doc[index]['description'];
                return InkWell(
                  onTap: () =>
                      updateData(context, uid, time, title, description),
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text("${index + 1}"),
                      ),
                      title: Text(title),
                      subtitle: Text(description),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteData(time, uid),
                      ),
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

updateData<Widget>(BuildContext context, final uid, final time, String title,
    final description) async {
  TextEditingController titleController = TextEditingController(text: title);
  TextEditingController descController =
      TextEditingController(text: description);
  final updateFormKey = GlobalKey<FormState>();
  showDialog(
      context: context,
      builder: (context) {
        // print("title: " + title);
        return AlertDialog(
          title: const Text('Update Data'),
          content: Form(
            key: updateFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Title"),
                  validator: RequiredValidator(errorText: "Required"),
                  controller: titleController,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Title"),
                  validator: RequiredValidator(errorText: "Required"),
                  controller: descController,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                    child: ElevatedButton(onPressed: ()async{
                      try{
                        FocusManager.instance.primaryFocus!.unfocus();
                        Navigator.pop(context);
                        await FirebaseFirestore.instance.collection("tasks").doc(uid).collection("mytasks").doc(time).set(
                            {
                                'title': titleController.text.toString(),
                                'description': descController.text.toString()
                            });
                      }catch(e){
                        print(e);
                      }
                    }, child: const Text("Update")))
              ],
            ),
          ),
        );
      });
}


deleteData(String time, String uid) async {
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
