import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_survey/presentation/Detail.dart';
import 'package:flutter_application_survey/presentation/Formulir.dart';
import 'package:flutter_application_survey/widgets/popular_topics.dart';
import 'package:flutter_application_survey/widgets/top_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Riwayat extends StatefulWidget {
  @override
  _RiwayatState createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  var username = '';
  var id_user = '';
  bool isVisible = false;

  List dataHistory = [];

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

    setState(() {
      isVisible = true;
    });

    fetchData();
  }

  Future<void> fetchData() async {
    dataHistory.clear();

    var url = Uri.http("e-sibling.hikmahasiabatamtour.com", '/api/history.php',
        {'q': '{https}'});
    var response = await http.post(url, body: {"id_user": id_user});

    if (response.body.isNotEmpty) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      dataHistory = parsed;

      setState(() {
        isVisible = false;
      });
    } else {
      setState(() {
        isVisible = false;
      });
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
              padding: EdgeInsets.only(bottom: 20),
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
                        "Riwayat",
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
                                    margin:
                                        EdgeInsets.only(top: 50, bottom: 30),
                                    child: CircularProgressIndicator())),
                          ],
                        ),
                      ),

                    Container(
                        height: 600,
                        child: Scaffold(
                            body: RefreshIndicator(
                          onRefresh: fetchData,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: dataHistory.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.all(10.0),
                                margin: EdgeInsets.all(10),
                                height: 170,
                                width: 170,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF3D657),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        dataHistory[index]['Time_stamp']
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.2),
                                      ),
                                      Row(children: [
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            "PEGAWAI : " +
                                                dataHistory[index]['Pegawai']
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                letterSpacing: .7),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            "UNIT : " +
                                                dataHistory[index]['Unit_Kerja']
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                letterSpacing: .7),
                                          ),
                                        )
                                      ]),
                                      Row(children: [
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            "NPP / NIP : " +
                                                dataHistory[index]['Nip']
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                letterSpacing: .7),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            "STATUS : " +
                                                dataHistory[index]['Statuss']
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                letterSpacing: .7),
                                          ),
                                        )
                                      ]),
                                      Row(children: [
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            "LOKASI FKTP : " +
                                                dataHistory[index]
                                                        ['Lokasi_FKTP']
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                letterSpacing: .7),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            "NAMA FKTP : " +
                                                dataHistory[index]['Nama_FKTP']
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                letterSpacing: .7),
                                          ),
                                        )
                                      ]),
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          "JENIS FKTP : " +
                                              dataHistory[index]['Jenis_FKTP']
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              letterSpacing: .7),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                //Padding between these please
                                                if (dataHistory[index]
                                                        ['id_detail'] !=
                                                    null)
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Detail(
                                                              id_report: dataHistory[
                                                                          index]
                                                                      [
                                                                      'Id_reports']
                                                                  .toString(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                          "Selesai mengisi Formulir",
                                                          style: TextStyle(
                                                            background: Paint()
                                                              ..color =
                                                                  Colors.green
                                                              ..strokeWidth = 20
                                                              ..strokeJoin =
                                                                  StrokeJoin
                                                                      .round
                                                              ..strokeCap =
                                                                  StrokeCap
                                                                      .round
                                                              ..style =
                                                                  PaintingStyle
                                                                      .stroke,
                                                            color: Colors.white,
                                                          ))),
                                                if (dataHistory[index]
                                                        ['id_detail'] ==
                                                    null)
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Formulir(
                                                              id_form: dataHistory[
                                                                          index]
                                                                      [
                                                                      'Id_reports']
                                                                  .toString(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                          "Belum  mengisi Formulir",
                                                          style: TextStyle(
                                                            background: Paint()
                                                              ..color =
                                                                  Colors.red
                                                              ..strokeWidth = 20
                                                              ..strokeJoin =
                                                                  StrokeJoin
                                                                      .round
                                                              ..strokeCap =
                                                                  StrokeCap
                                                                      .round
                                                              ..style =
                                                                  PaintingStyle
                                                                      .stroke,
                                                            color: Colors.white,
                                                          )))
                                              ])),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ))),
                  ]))
        ],
      )),
    );
  }
}
