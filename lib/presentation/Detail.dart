import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_survey/widgets/popular_topics.dart';
import 'package:flutter_application_survey/widgets/top_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Detail extends StatefulWidget {
  Detail({super.key, required this.id_report});

  var id_report;
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  var username = '';
  var id_user = '';

  bool isVisible = false;

  List dataDetail = [];

  void initState() {
    super.initState();
    getData();
    fetchDetail();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username')!;
      id_user = prefs.getString('id_user')!;
    });
  }

  Future<void> _launchMapsUrl(dynamic latlng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latlng';
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  Future<void> fetchDetail() async {
    dataDetail.clear();
    setState(() {
      isVisible = true;
    });
    var url = Uri.http("e-sibling.hikmahasiabatamtour.com",
        '/api/fetcDetail.php', {'q': '{https}'});
    var response = await http.post(url, body: {"id_report": widget.id_report});

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      dataDetail = parsed;
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
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // TopBar(),

                  Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
                    child: Text(
                      "Jawaban Pertanyaan",
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
                    height: 600,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: dataDetail.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.all(10),
                          height: 180,
                          width: 170,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 246, 221, 113),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  dataDetail[index]['Question'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      dataDetail[index]['answer'].toString(),
                                      style: new TextStyle(
                                        fontSize: 17.0,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                if (dataDetail[index]['image'].toString() != "")
                                  GestureDetector(
                                      onTap: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (_) => ImageDialog(
                                                url:
                                                    "https://e-sibling.hikmahasiabatamtour.com/api/image/" +
                                                        dataDetail[index]
                                                                ['image']
                                                            .toString()));
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: Image(
                                                  image: CachedNetworkImageProvider(
                                                      "https://e-sibling.hikmahasiabatamtour.com/api/image/" +
                                                          dataDetail[index]
                                                                  ['image']
                                                              .toString())))
                                        ],
                                      )),
                                if (dataDetail[index]['image'].toString() != "")
                                  Text(
                                    "Tap image to detail",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 14.0,
                                    ),
                                  ),
                                if (dataDetail[index]['type'].toString() == "2")
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
                                            _launchMapsUrl(dataDetail[index]
                                                    ['answer']
                                                .toString());
                                          }),
                                          child: const Text(
                                            "View Maps",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                                      ),
                                    ],
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
        ],
      )),
    );
  }
}

class ImageDialog extends StatelessWidget {
  ImageDialog({super.key, required this.url});

  var url;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(url), fit: BoxFit.cover)),
      ),
    );
  }
}
