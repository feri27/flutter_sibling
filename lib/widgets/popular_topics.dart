import 'package:flutter/material.dart';
import 'package:flutter_application_survey/presentation/Fktp.dart';
import 'package:flutter_application_survey/presentation/Formulir.dart';

class PopularTopics extends StatelessWidget {
  List<String> contents = ["Tambah Data"];
  List<Color> colors = [
    Colors.purple,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.redAccent
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: contents.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(left: 20.0),
              height: 180,
              width: 170,
              decoration: BoxDecoration(
                color: colors[index],
                borderRadius: BorderRadius.circular(8),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Fktp(),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        contents[index],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "1 Formulir",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            letterSpacing: .7),
                      )
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
