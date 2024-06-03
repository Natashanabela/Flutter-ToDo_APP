import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPage();
}

class _AddTodoPage extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      isEdit = true;
      final title = widget.todo?['title'];
      final description = widget.todo?['description'];
      final completed = widget.todo?['is_completed'];
      titleController.text = title ?? '';
      descriptionController.text = description ?? '';
      isCompleted = completed ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Todo' : 'Add Todo',
          style: TextStyle(
          color: Colors.black, // Warna teks
          ),
        ),
         backgroundColor: Color(0xFF86B6F6),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          CheckboxListTile(
            title: Text('Completed'),
            value: isCompleted,
            onChanged: (value) {
              setState(() {
                isCompleted = value!;
              });
            },
             activeColor: Color(0xFF45A834),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF001D6E), // Warna latar tombol
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isEdit ? 'Update' : 'Submit',
                style: TextStyle(
                  color: Colors.white, // Warna teks tombol
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('You cannot call update without todo data');
      return;
    }

    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": isCompleted,
    };

    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);

    try {
      final response = await http.put(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showSuccessMessage('Update Success');
        Navigator.pop(context, true);
      } else {
        showErrorMessage('Update Failed');
      }
    } catch (e) {
      print('Error: $e');
      showErrorMessage('Update Failed');
    }
  }

  Future<void> submitData() async {
    //get data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": isCompleted,
    };

    //submit data to the server
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    //show success
    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage('Creation Success');
      Navigator.pop(context, true);
    } else {
      showErrorMessage('Creation Failed');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}