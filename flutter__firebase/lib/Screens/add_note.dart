import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/firestore_services.dart';

class AddNoteScreen extends StatefulWidget {
  final User user;
  const AddNoteScreen(this.user, {super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(
                "Text",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Description",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: descriptionController,
                minLines: 5,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (titleController.text == "" ||
                              descriptionController.text == "") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("All fields are required!")));
                          } else {
                            setState(() {
                              loading = true;
                            });
                            await FireStoreService().insertNote(
                              title: titleController.text,
                              description: descriptionController.text,
                              userId: widget.user.uid,
                            );
                            setState(() {
                              loading = false;
                            });
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          }
                        },
                        // ignore: sort_child_properties_last
                        child: Text(
                          "Add Note",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
