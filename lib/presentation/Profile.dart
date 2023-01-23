import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_survey/presentation/Formulir.dart';
import 'package:flutter_application_survey/widgets/popular_topics.dart';
import 'package:flutter_application_survey/widgets/top_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var username = '';
  var id_user = '';
  bool isVisible = false;

  var pegawai = TextEditingController();
  var nip = TextEditingController();
  var status = TextEditingController();
  var unit = TextEditingController();
  var lokasi = TextEditingController();
  var nama = TextEditingController();
  var jenis = TextEditingController();

  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username')!;
      id_user = prefs.getString('id_user')!;
    });

    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isVisible = true;
    });
    var url = Uri.http(
        "e-sibling.hikmahasiabatamtour.com", '/api/user.php', {'q': '{https}'});
    var response = await http.post(url, body: {"id_user": id_user});

    log(response.body);

    if (response.body.isNotEmpty) {
      var data = json.decode(response.body);
      var username = data['nama'];
      var id_user = data['id_user'];

      var _nip = data['nip'];
      var _status = data['status'];
      var unit_kerja = data['unit_kerja'];
      var lokasi_fktp = data['lokasi_fktp'];
      var nama_fktp = data['nama_fktp'];
      var jenis_fktp = data['jenis_fktp'];

      setState(() {
        pegawai = new TextEditingController(text: username);
        nip = new TextEditingController(text: _nip);
        status = new TextEditingController(text: _status);
        unit = new TextEditingController(text: unit_kerja);
        lokasi = new TextEditingController(text: lokasi_fktp);
        nama = new TextEditingController(text: nama_fktp);
        jenis = new TextEditingController(text: jenis_fktp);
      });

      setState(() {
        isVisible = false;
      });
    } else {
      setState(() {
        isVisible = false;
      });
    }
  }

  Future<void> update_data() async {
    setState(() {
      isVisible = true;
    });

    var url = Uri.http("e-sibling.hikmahasiabatamtour.com",
        '/api/update_profile.php', {'q': '{https}'});
    var response = await http.post(url, body: {
      "nip": nip.text,
      "status": status.text,
      "unit_kerja": unit.text,
      "lokasi_fktp": lokasi.text,
      "nama_fktp": nama.text,
      "jenis_fktp": jenis.text,
      "id_user": id_user,
    });

    if (response.body.isNotEmpty) {
      setState(() {
        isVisible = false;
      });

      Fluttertoast.showToast(
        msg: 'Update Successful',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      setState(() {
        isVisible = false;
      });
      Fluttertoast.showToast(
        msg: 'Update Error',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 152, 217, 1),
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Color.fromRGBO(0, 152, 217, 1)),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Halo!, $username",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14.0,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            // Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.person_rounded,
                            size: 20,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/sibling_ic.png",
                        width: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "e-sibling",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                          height: 1,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // TopBar(),

                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
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
                                  child: CircularProgressIndicator())),
                        ],
                      ),
                    ),

                  Container(
                      height: 560,
                      width: 500,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.all(10),
                        height: 180,
                        width: 170,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(83, 116, 115, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextField(
                                  controller: pegawai,
                                  decoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      labelText: 'Nama Pegawai')),
                              SizedBox(height: 10),
                              TextField(
                                  controller: nip,
                                  decoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      labelText: 'NPP / NIP')),
                              SizedBox(height: 5),
                              SizedBox(height: 10),
                              TextField(
                                  controller: status,
                                  decoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      labelText: 'Status Kepegawaian')),
                              SizedBox(height: 5),
                              SizedBox(height: 10),
                              TextField(
                                  controller: unit,
                                  decoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      labelText: 'Unit Kerja Pegawai')),
                              SizedBox(height: 5),
                              SizedBox(height: 10),
                              TextField(
                                  controller: lokasi,
                                  decoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      labelText: 'Lokasi FKTP')),
                              SizedBox(height: 5),
                              SizedBox(height: 10),
                              TextField(
                                  controller: nama,
                                  decoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      labelText: 'Nama FKTP')),
                              SizedBox(height: 5),
                              SizedBox(height: 10),
                              TextField(
                                  controller: jenis,
                                  decoration: InputDecoration(
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      labelText: 'Jenis FKTP')),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      )),
                ],
              )),
          Container(
            height: 40,
            margin: EdgeInsets.only(left: 10, right: 10),
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
              onTap: (() {
                update_data();
              }),
              child: const Text(
                "Update",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )),
          ),
        ],
      )),
    );
  }
}
