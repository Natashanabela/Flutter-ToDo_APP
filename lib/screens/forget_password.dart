import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF5FF),
      appBar: AppBar(
        title:Text( "Forget Password",
                style: TextStyle(color: Colors.black),
              ),
        backgroundColor: Color(0xFFB4D4FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement forget password logic
                // You can send a recovery email or perform other actions here.
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text( "Forget Password",
                        style: TextStyle(color: Colors.black),
                      ),
                      content: Text("A password recovery email has been sent to your email address."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),  
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF001D6E), // Ubah warna tombol
              ),
              child: Text('Send Recovery Email'),
            ),
          ],
        ),
      ),
    );
  }
}