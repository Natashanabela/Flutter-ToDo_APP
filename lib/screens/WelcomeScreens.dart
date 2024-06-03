import 'package:flutter/material.dart';
import 'package:todo/screens/regScreens.dart';
import 'package:todo/screens/loginScreens.dart';

class WelcomeScreens extends StatelessWidget {
  const WelcomeScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,   // Mulai dari sisi ujung kiri bawah
            end: Alignment.topRight,       // Hingga sisi ujung kanan atas
            colors: [
              Color(0xFF001D6E),
              Color(0xFF86B6F6),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: SizedBox(
                  width: 350,
                  height: 260,
                  child: Image(image: AssetImage('assets/logo.png')),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const loginScreens(),
                    ),
                  );
                },
                child: Container(
                  height: 53,
                  width: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white),
                  ),
                  child: const Center(
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const regScreens(),
                    ),
                  );
                },
                child: Container(
                  height: 53,
                  width: 320,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white),
                  ),
                  child: const Center(
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
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