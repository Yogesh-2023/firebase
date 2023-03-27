import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/Screens/home_screen.dart';
import 'package:flutter_firebase/models/note.dart';
import 'package:flutter_firebase/services/firestore_services.dart';

class EditNoteScreen extends StatefulWidget {
  NoteModel note;
  EditNoteScreen(this.note, {super.key});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Please confirm"),
                      content: Text("Are you sure to delete note?"),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            await FireStoreService().deleteNote(widget.note.id);
                            setState(() {
                              loading = false;
                            });
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          },
                          child: Text("Yes"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("No"),
                        ),
                      ],
                    );
                  });
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
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
                minLines: 5,
                maxLines: 10,
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text == "" ||
                        descriptionController.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("All field are required!")));
                    } else {
                      setState(() {
                        loading = true;
                      });
                      await FireStoreService().updateNote(
                        id: widget.note.id,
                        title: titleController.text,
                        description: descriptionController.text,
                      );
                      setState(() {
                        loading = false;
                      });
                      Navigator.pop(context);
                    }
                  },
                  // ignore: sort_child_properties_last
                  child: Text(
                    "Update Note",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
