import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:projek/main.dart';
import 'package:projek/project/halaman/halaman_favorit.dart';
import 'package:projek/project/halaman/halaman_akun.dart';
import 'package:projek/project/query/hive_user.dart';
import 'package:projek/project/model/hive_model.dart';
import 'package:projek/project/model/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form != null) {
      if (form.validate()) {
        print('Form valid');
      } else {
        print('Form tidak valid');
      }
    }
  }

  void _processLogin(String username, String password) async {
    final HiveUser _hive = HiveUser();
    bool found = false;

    found = _hive.checkLogin(username, password);
    if (!found) {
      const snackBar = SnackBar(
        content: Text('Akun tidak ada'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      SharedPreference().setLogin(username, password);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Akun(user: username),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Akun",
          style: TextStyle(
              fontFamily: 'Caveat',
              fontWeight: FontWeight.bold,
              fontSize: 24.0),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(25),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Username',
                ),
                validator: (value) => value!.isEmpty ? 'Username tidak boleh kosong':null,
              ),
              SizedBox(height: 15),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(25),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Password',
                ),
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  onPressed: (){
                    validateAndSave();
                    String currentUsername = _usernameController.value.text;
                    String currentPassword = _passwordController.value.text;
                    if (currentUsername == "" || currentPassword == "") {
                      const snackBar = SnackBar(
                        content: Text('Form tidak boleh kosong'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      _processLogin(currentUsername, currentPassword);
                    }
                  },
                  child: Text('Login',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CurvedNavigationBar(
        index: 2,
        backgroundColor: Colors.orange.shade300,
        items: <Widget>[
          Icon(Icons.home, size: 25),
          Icon(Icons.favorite, size: 25),
          Icon(Icons.account_circle, size: 25),
        ],
        onTap: (index) {
          //Handle button tap
          setState(() {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
                break;

              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Favorit(username: "")),
                );
                break;

              case 2:
                Navigator.pop(context);
                break;
            }
          });
        },
      ),
    );
  }
}

