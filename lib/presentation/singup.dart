import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_survey/presentation/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nama = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  bool isVisible = false;

  void check() {
    if (nama.text.isEmpty || user.text.isEmpty || pass.text.isEmpty) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: 'Data belum lengkap..',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      register();
    }
  }

  Future register() async {
    setState(() {
      isVisible = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("username", "");
    prefs.setString("id_user", "");

    var url = Uri.http("e-sibling.hikmahasiabatamtour.com", '/api/register.php',
        {'q': '{https}'});
    var response = await http.post(url, body: {
      "nama": nama.text.toString(),
      "username": user.text.toString(),
      "password": pass.text.toString(),
    });
    var data = json.decode(response.body);
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
          "Register",
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
          style: const TextStyle(color: Colors.white),
          controller: nama,
          decoration: InputDecoration(
            hintText: 'Nama',
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFF1C1C1C),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          style: const TextStyle(color: Colors.white),
          controller: user,
          decoration: InputDecoration(
            hintText: 'Email',
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFF1C1C1C),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          style: const TextStyle(color: Colors.white),
          obscureText: true,
          controller: pass,
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFF1C1C1C),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF3D657).withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 4,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
              child: GestureDetector(
            onTap: check,
            child: const Text(
              "Daftar",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )),
        ),
        const SizedBox(
          height: 24,
        ),
        const SizedBox(
          height: 16,
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
