import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_survey/widgets/popular_topics.dart';
import 'package:flutter_application_survey/widgets/top_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Formulir extends StatefulWidget {
  Formulir({super.key, required this.id_form});

  var id_form;

  @override
  _FormulirState createState() => _FormulirState();
}

class _FormulirState extends State<Formulir> {
  var username = '';
  var id_user = '';

  bool isVisible = false;

  List dataHistory = [];

  List radio = [];

  var text = <TextEditingController>[];

  List image = [];

  List proccess = [];

  List cek = [];

  List locations = [];

  Timer _timer = Timer(Duration(milliseconds: 1), () {});

  int count = 0;
  int count_data = 0;

  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        _timer.cancel();
      });
    }

    getData();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  _getFromCamera(int key) async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      Uint8List imagebytes = await imageFile.readAsBytes();
      String base64string = base64.encode(imagebytes);
      image[key] = base64string;
    }
  }

  Uint8List convertBase64Image(String base64String) {
    return Base64Decoder().convert(base64String.split(',').last);
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username')!;
      id_user = prefs.getString('id_user')!;
    });

    fetchData();
  }

  Future<void> cekRequired(int index) async {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      cekAction(index);
    });
  }

  Future<void> cekAction(int index) async {
    setState(() {
      for (var i = index + 1; i < dataHistory.length; i++) {
        dataHistory.removeAt(i);
        radio.removeAt(i);
        count++;
      }
    });

    if (count_data == count) {
      _timer.cancel();
    }
  }

  void cekForm() {
    cek.clear();
    proccess.clear();
    for (var i = 0; i < dataHistory.length; i++) {
      if (radio[i] == "YES" || radio[i] == "NO") {
        cek.add("0");
      }

      if (text[i].text != '') {
        cek.add("0");
      }
    }

    if (dataHistory.length != cek.length) {
      Fluttertoast.showToast(
        msg: 'Formulir masih Kosong..',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      submit();
    }
  }

  void submit() {
    setState(() {
      isVisible = true;
    });

    for (var i = 0; i < dataHistory.length; i++) {
      if (radio[i] == "YES" || radio[i] == "NO") {
        var id = dataHistory[i]['id'];
        if (image[i].toString().isNotEmpty) {
          submitFormulir(widget.id_form, id, radio[i], image[i]);
        } else {
          submitFormulir(widget.id_form, id, radio[i], "");
        }
      }

      if (text[i].text != '') {
        var id = dataHistory[i]['id'];
        if (image[i].toString().isNotEmpty) {
          submitFormulir(widget.id_form, id, text[i].text, image[i]);
        } else {
          submitFormulir(widget.id_form, id, text[i].text, "");
        }
      }
    }
  }

  Future<void> submitFormulir(
      dynamic id_report, String id_forms, String answer, String images) async {
    var url = Uri.http("e-sibling.hikmahasiabatamtour.com", '/api/detail.php',
        {'q': '{https}'});
    var response = await http.post(url, body: {
      "id_report": id_report,
      "id_form": id_forms,
      "answer": answer,
      "image": images
    });

    var data = json.decode(response.body);

    if (data == 'Success') {
      proccess.add("0");
    } else if (data == 'Error') {
      proccess.add("0");
    }

    if (dataHistory.length == proccess.length) {
      setState(() {
        isVisible = false;
      });

      Fluttertoast.showToast(
        msg: 'Success..',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      Navigator.pop(context);
    }
  }

  Future<void> fetchData() async {
    setState(() {
      isVisible = true;
    });
    var url = Uri.http(
        "e-sibling.hikmahasiabatamtour.com", '/api/form.php', {'q': '{https}'});
    var response = await http.post(url, body: {"id_user": id_user});

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      dataHistory = parsed;

      setState(() {
        count_data = dataHistory.length;
      });

      for (var i = 0; i < dataHistory.length; i++) {
        radio.add(i);

        image.add("");
      }
      for (var i = 0; i < dataHistory.length; i++) {
        var ia = TextEditingController();
        text.add(ia);
        if (dataHistory[i]['type'] == '2') {
          var location = Location();
          var loc = await location.getLocation();
          text[i] = new TextEditingController(
              text: "${loc.latitude},${loc.longitude}");
        }
      }

      log(dataHistory.toString());
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
                      "Pertanyaan",
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
                    height: 580,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: dataHistory.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
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
                                Text(
                                  dataHistory[index]['Question'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2),
                                ),
                                SizedBox(height: 5),
                                if (dataHistory[index]['type'] == '0')
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Radio<String>(
                                        value: 'YES',
                                        groupValue: radio[index].toString(),
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.white),
                                        onChanged: (val) async {
                                          setState(() {
                                            radio[index] = val;
                                          });
                                        },
                                      ),
                                      Text(
                                        'YES',
                                        style: new TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Radio<String>(
                                        value: 'NO',
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.white),
                                        groupValue: radio[index].toString(),
                                        onChanged: (val) async {
                                          setState(() {
                                            radio[index] = val;
                                          });
                                          if (dataHistory[index]
                                                      ['isRequired'] ==
                                                  '1' &&
                                              count_data != count) {
                                            await cekRequired(index);
                                          }
                                        },
                                      ),
                                      Text(
                                        'NO',
                                        style: new TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (dataHistory[index]['isRequired'] == '1')
                                  Text(
                                    "Jika anda memilih NO \nmaka formulir selanjut nya\ndi hilangkan oleh sistem",
                                    style: TextStyle(
                                      color: Colors.yellow.withOpacity(0.8),
                                      fontSize: 14.0,
                                    ),
                                  ),
                                if (dataHistory[index]['type'] == '1')
                                  TextField(
                                      controller: text[index],
                                      decoration:
                                          InputDecoration(labelText: '')),
                                SizedBox(height: 10),
                                if (dataHistory[index]['type'] != '2' &&
                                    dataHistory[index]['IsImage'] != '0')
                                  Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 100,
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 15, 189, 242),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                      255, 20, 140, 232)
                                                  .withOpacity(0.2),
                                              spreadRadius: 3,
                                              blurRadius: 4,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                            child: GestureDetector(
                                          onTap: (() {
                                            _getFromCamera(index);
                                          }),
                                          child: const Text(
                                            "Image",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                                      ),
                                      if (image[index] != "")
                                        SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: Image.memory(
                                              convertBase64Image(image[index]),
                                              gaplessPlayback: true,
                                            ))
                                    ],
                                  ),
                                if (dataHistory[index]['type'] == '2')
                                  TextField(
                                      controller: text[index],
                                      enabled: false,
                                      decoration: InputDecoration(
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          labelText: '')),
                                if (dataHistory[index]['type'] == '2')
                                  Text(
                                    "Location value by sistem",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 14.0,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
                cekForm();
              }),
              child: const Text(
                "Simpan",
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
