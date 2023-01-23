import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_survey/presentation/Detail.dart';
import 'package:flutter_application_survey/presentation/Formulir.dart';
import 'package:flutter_application_survey/presentation/Profile.dart';
import 'package:flutter_application_survey/presentation/Riwayat.dart';
import 'package:flutter_application_survey/widgets/popular_topics.dart';
import 'package:flutter_application_survey/widgets/top_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Fktp.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var username = '';
  var id_user = '';

  bool isVisible = false;

  bool cekprofile = false;

  bool cek = false;

  List dataHistory = [];

  void initState() {
    super.initState();
    getData();
    _initLocationService();
  }

  Future _initLocationService() async {
    var location = Location();

    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return;
      }
    }

    var permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }

    var loc = await location.getLocation();
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("username", "");
    prefs.setString("id_user", "");

    Navigator.pop(context);
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
    dataHistory.clear();
    setState(() {
      isVisible = false;
    });
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

  Future<void> cekData() async {
    setState(() {
      cekprofile = true;
    });
    var url = Uri.http(
        "e-sibling.hikmahasiabatamtour.com", '/api/user.php', {'q': '{https}'});
    var response = await http.post(url, body: {"id_user": id_user});

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

      if (_nip != "" ||
          _status != "" ||
          unit_kerja != "" ||
          lokasi_fktp != "") {
        setState(() {
          cek = true;
          cekprofile = false;
        });
      } else {
        setState(() {
          cek = false;
          cekprofile = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
              height: 500,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(61, 64, 148, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                    child: Text(
                      "Menu",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  // PopularTopics(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(20),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                                height: 65,
                                child: new IconButton(
                                  padding: new EdgeInsets.all(0),
                                  color: Colors.grey,
                                  icon: new Icon(Icons.article, size: 80),
                                  onPressed: (() async {
                                    cekData();
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    if (cek == true) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Fktp(),
                                        ),
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: 'Update data profile',
                                        backgroundColor: Colors.yellow,
                                        textColor: Colors.white,
                                        toastLength: Toast.LENGTH_SHORT,
                                      );
                                    }
                                  }),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            if (cekprofile)
                              Center(
                                child: Container(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator()),
                              ),
                            if (cekprofile == false)
                              Text(
                                "Tambah Data",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                    letterSpacing: 1),
                              )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(20),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                                height: 65,
                                child: new IconButton(
                                  padding: new EdgeInsets.all(0),
                                  color: Colors.grey,
                                  icon: new Icon(Icons.history, size: 80),
                                  onPressed: (() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Riwayat(),
                                      ),
                                    );
                                  }),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Riwayat",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  letterSpacing: 1),
                            )
                          ],
                        ),
                      )
                    ],
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(20),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                                height: 65,
                                child: new IconButton(
                                  padding: new EdgeInsets.all(0),
                                  color: Colors.grey,
                                  icon: new Icon(Icons.download, size: 80),
                                  onPressed: (() {
                                    Fluttertoast.showToast(
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      msg: 'Disable !',
                                      toastLength: Toast.LENGTH_SHORT,
                                    );
                                  }),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Export Data",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  letterSpacing: 1),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(20),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                                height: 65,
                                child: new IconButton(
                                  padding: new EdgeInsets.all(0),
                                  color: Colors.grey,
                                  icon: new Icon(Icons.person, size: 80),
                                  onPressed: (() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Profile(),
                                      ),
                                    );
                                  }),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  letterSpacing: 1),
                            )
                          ],
                        ),
                      )
                    ],
                  ),

                  // Padding(
                  //   padding:
                  //       EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(
                  //         "History",
                  //         style: TextStyle(
                  //             fontSize: 20,
                  //             color: Colors.black,
                  //             fontWeight: FontWeight.w600),
                  //       ),
                  //       SizedBox(height: 2),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: <Widget>[
                  //           Text(
                  //             "Swipe to refresh",
                  //             style: TextStyle(
                  //               color: Colors.grey.withOpacity(0.6),
                  //               fontSize: 14.0,
                  //             ),
                  //           ),
                  //           GestureDetector(
                  //               onTap: () {
                  //                 getData();
                  //               },
                  //               child: Icon(
                  //                 Icons.history,
                  //                 size: 20,
                  //                 color: Colors.white,
                  //               ))
                  //         ],
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // if (isVisible)
                  //   Center(
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[
                  //         Visibility(
                  //             maintainSize: true,
                  //             maintainAnimation: true,
                  //             maintainState: true,
                  //             visible: isVisible,
                  //             child: Container(
                  //                 margin: EdgeInsets.only(top: 50, bottom: 30),
                  //                 child: CircularProgressIndicator())),
                  //       ],
                  //     ),
                  //   ),
                  // Container(
                  //     height: 440,
                  //     padding: EdgeInsets.only(bottom: 110),
                  //     child: Scaffold(
                  //         body: RefreshIndicator(
                  //       onRefresh: fetchData,
                  //       child: ListView.builder(
                  //         scrollDirection: Axis.vertical,
                  //         itemCount: dataHistory.length,
                  //         itemBuilder: (BuildContext context, int index) {
                  //           return Container(
                  //             padding: EdgeInsets.all(10.0),
                  //             margin: EdgeInsets.all(10),
                  //             height: 170,
                  //             width: 170,
                  //             decoration: BoxDecoration(
                  //               color: Color(0xFFF3D657),
                  //               borderRadius: BorderRadius.circular(8),
                  //             ),
                  //             child: Padding(
                  //               padding: EdgeInsets.all(5),
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: <Widget>[
                  //                   Text(
                  //                     dataHistory[index]['Time_stamp']
                  //                         .toString(),
                  //                     style: TextStyle(
                  //                         color: Colors.red,
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w600,
                  //                         letterSpacing: 1.2),
                  //                   ),
                  //                   Row(children: [
                  //                     SizedBox(
                  //                       width: 150,
                  //                       child: Text(
                  //                         "PEGAWAI : " +
                  //                             dataHistory[index]['Pegawai']
                  //                                 .toString(),
                  //                         style: TextStyle(
                  //                             color: Colors.black,
                  //                             fontSize: 14,
                  //                             letterSpacing: .7),
                  //                       ),
                  //                     ),
                  //                     SizedBox(
                  //                       width: 5,
                  //                     ),
                  //                     SizedBox(
                  //                       width: 150,
                  //                       child: Text(
                  //                         "UNIT : " +
                  //                             dataHistory[index]['Unit_Kerja']
                  //                                 .toString(),
                  //                         style: TextStyle(
                  //                             color: Colors.black,
                  //                             fontSize: 14,
                  //                             letterSpacing: .7),
                  //                       ),
                  //                     )
                  //                   ]),
                  //                   Row(children: [
                  //                     SizedBox(
                  //                       width: 150,
                  //                       child: Text(
                  //                         "NPP / NIP : " +
                  //                             dataHistory[index]['Nip']
                  //                                 .toString(),
                  //                         style: TextStyle(
                  //                             color: Colors.black,
                  //                             fontSize: 14,
                  //                             letterSpacing: .7),
                  //                       ),
                  //                     ),
                  //                     SizedBox(
                  //                       width: 5,
                  //                     ),
                  //                     SizedBox(
                  //                       width: 150,
                  //                       child: Text(
                  //                         "STATUS : " +
                  //                             dataHistory[index]['Statuss']
                  //                                 .toString(),
                  //                         style: TextStyle(
                  //                             color: Colors.black,
                  //                             fontSize: 14,
                  //                             letterSpacing: .7),
                  //                       ),
                  //                     )
                  //                   ]),
                  //                   Row(children: [
                  //                     SizedBox(
                  //                       width: 150,
                  //                       child: Text(
                  //                         "LOKASI FKTP : " +
                  //                             dataHistory[index]['Lokasi_FKTP']
                  //                                 .toString(),
                  //                         style: TextStyle(
                  //                             color: Colors.black,
                  //                             fontSize: 14,
                  //                             letterSpacing: .7),
                  //                       ),
                  //                     ),
                  //                     SizedBox(
                  //                       width: 5,
                  //                     ),
                  //                     SizedBox(
                  //                       width: 150,
                  //                       child: Text(
                  //                         "NAMA FKTP : " +
                  //                             dataHistory[index]['Nama_FKTP']
                  //                                 .toString(),
                  //                         style: TextStyle(
                  //                             color: Colors.black,
                  //                             fontSize: 14,
                  //                             letterSpacing: .7),
                  //                       ),
                  //                     )
                  //                   ]),
                  //                   SizedBox(
                  //                     width: 150,
                  //                     child: Text(
                  //                       "JENIS FKTP : " +
                  //                           dataHistory[index]['Jenis_FKTP']
                  //                               .toString(),
                  //                       style: TextStyle(
                  //                           color: Colors.black,
                  //                           fontSize: 14,
                  //                           letterSpacing: .7),
                  //                     ),
                  //                   ),
                  //                   SizedBox(height: 15),
                  //                   Padding(
                  //                       padding: EdgeInsets.only(left: 10),
                  //                       child: Column(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.start,
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.end,
                  //                           children: <Widget>[
                  //                             //Padding between these please
                  //                             if (dataHistory[index]
                  //                                     ['id_detail'] !=
                  //                                 null)
                  //                               GestureDetector(
                  //                                   onTap: () {
                  //                                     Navigator.push(
                  //                                       context,
                  //                                       MaterialPageRoute(
                  //                                         builder: (context) =>
                  //                                             Detail(
                  //                                           id_report: dataHistory[
                  //                                                       index][
                  //                                                   'Id_reports']
                  //                                               .toString(),
                  //                                         ),
                  //                                       ),
                  //                                     );
                  //                                   },
                  //                                   child: Text(
                  //                                       "Selesai mengisi Formulir",
                  //                                       style: TextStyle(
                  //                                         background: Paint()
                  //                                           ..color =
                  //                                               Colors.green
                  //                                           ..strokeWidth = 20
                  //                                           ..strokeJoin =
                  //                                               StrokeJoin.round
                  //                                           ..strokeCap =
                  //                                               StrokeCap.round
                  //                                           ..style =
                  //                                               PaintingStyle
                  //                                                   .stroke,
                  //                                         color: Colors.white,
                  //                                       ))),
                  //                             if (dataHistory[index]
                  //                                     ['id_detail'] ==
                  //                                 null)
                  //                               GestureDetector(
                  //                                   onTap: () {
                  //                                     Navigator.push(
                  //                                       context,
                  //                                       MaterialPageRoute(
                  //                                         builder: (context) =>
                  //                                             Formulir(
                  //                                           id_form: dataHistory[
                  //                                                       index][
                  //                                                   'Id_reports']
                  //                                               .toString(),
                  //                                         ),
                  //                                       ),
                  //                                     );
                  //                                   },
                  //                                   child: Text(
                  //                                       "Belum  mengisi Formulir",
                  //                                       style: TextStyle(
                  //                                         background: Paint()
                  //                                           ..color = Colors.red
                  //                                           ..strokeWidth = 20
                  //                                           ..strokeJoin =
                  //                                               StrokeJoin.round
                  //                                           ..strokeCap =
                  //                                               StrokeCap.round
                  //                                           ..style =
                  //                                               PaintingStyle
                  //                                                   .stroke,
                  //                                         color: Colors.white,
                  //                                       )))
                  //                           ])),
                  //                 ],
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     )))
                ],
              ))
        ],
      )),
    );
  }
}
