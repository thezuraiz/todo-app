import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:todo_app/Functions/crudFunctions.dart';

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
        body: readData(context),
        floatingActionButton: FloatingActionButton(
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
                            onPressed: () {
                              createFunc(titleController, descController,
                                  taskKey, context);
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
        ));
  }
}
