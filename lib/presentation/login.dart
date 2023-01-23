import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_survey/presentation/HomePage.dart';
import 'package:flutter_application_survey/presentation/Register.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  bool isVisible = false;

  void initState() {
    super.initState();
    //cekLogin();
  }

  Future<void> cekLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("id_user") == null) {
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  void cekInput() {
    if (user.text.isEmpty || pass.text.isEmpty) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Masukan user dan password..',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      login();
    }
  }

  Future login() async {
    setState(() {
      isVisible = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.http("e-sibling.hikmahasiabatamtour.com", '/api/login.php',
        {'q': '{https}'});
    var response = await http.post(url, body: {
      "username": user.text,
      "password": pass.text,
    });

    if (response.body.isNotEmpty) {
      var data = json.decode(response.body);
      var username = data['nama'];
      var id_user = data['id_user'];

      prefs.setString("username", username!);
      prefs.setString("id_user", id_user!);

      setState(() {
        isVisible = false;
      });

      Fluttertoast.showToast(
        msg: 'Login Successful',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      setState(() {
        isVisible = false;
      });

      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Username and password invalid',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 50,
        ),
        Image.asset(
          "assets/sibling_ic.png",
          width: 100,
          height: 100,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            child: const Text(
          "e-sibling",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
            height: 1,
          ),
        )),
        const SizedBox(
          height: 90,
        ),
        const Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 36,
            color: Colors.white,
            letterSpacing: 2,
            height: 1,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: user,
          style: const TextStyle(color: Colors.grey),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            hintText: 'Email',
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          obscureText: true,
          style: const TextStyle(color: Colors.grey),
          controller: pass,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.key),
            hintText: 'Password',
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1C1C1C).withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                  child: GestureDetector(
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(),
                    ),
                  );
                }),
                child: const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1C1C1C).withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                  child: GestureDetector(
                onTap: cekInput,
                child: const Text(
                  "Masuk",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),
            ),
          ],
        ),
        const SizedBox(
          height: 23,
        ),
        const Text(
          "Lupa kata sandi?",
          textAlign: TextAlign.center,
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 18,
            color: Colors.white,
            fontStyle: FontStyle.italic,
            letterSpacing: 2,
            height: 1,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        if (isVisible)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: isVisible,
                    child: Container(
                        margin: EdgeInsets.only(top: 50, bottom: 30),
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ))),
              ],
            ),
          ),
      ],
    );
  }
}
