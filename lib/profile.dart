import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String nama = "";
  String email = "";
  String noHp = "";

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    setState(() {

      nama = prefs.getString("nama") ?? "";

      email = prefs.getString("email") ?? "";

      noHp = prefs.getString("no_hp") ?? "";

    });

  }

  Future<void> logout() async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Color.fromARGB(255, 245, 205, 219),
        foregroundColor: Colors.white,
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const CircleAvatar(
              radius: 50,
              backgroundColor: Color.fromARGB(255, 245, 205, 219),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 60,
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Nama"),
                subtitle: Text(nama),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email"),
                subtitle: Text(email),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: const Text("No HP"),
                subtitle: Text(noHp),
              ),
            ),

            const Spacer(),

            SizedBox(

              width: double.infinity,
              child: ElevatedButton.icon(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 197, 229),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15),
                ),

                onPressed: () {

                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text(
                          "Yakin ingin logout?"
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Batal"),
                          ),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),

                            onPressed: logout,
                            child: const Text("Logout"),

                          )
                        ],
                      );
                    },
                  );
                },

                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            )
          ],
        ),
      ),
    );
  }
}