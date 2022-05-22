import 'package:flutter/material.dart';
import 'package:notes_app/main.dart';
import 'package:notes_app/models/database_helper.dart';

class UpdateNoteScreen extends StatefulWidget {
  late int id;
  // ignore: non_constant_identifier_names, constant_identifier_names
  static const String AddNoteScreenKey = '/AddNoteScreen';
  UpdateNoteScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<UpdateNoteScreen> createState() => _UpdateNoteScreenState();
}

class _UpdateNoteScreenState extends State<UpdateNoteScreen> {
  String _title = '', _contant = '', _color = 'blueAccent';
  Map<String, dynamic> singleElement = {};
  void getData() async {
    singleElement = await DatabaseHelper.instance.getById(widget.id);
    _title = singleElement['title'];
    _color = singleElement['color'];
    _contant = singleElement['contant'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Note'),
      ),
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          child: Icon(Icons.title),
                          margin: EdgeInsets.only(right: 10, left: 10),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: singleElement.isEmpty
                                  ? 'Loading Data'
                                  : singleElement['title'],
                            ),
                            onChanged: (value) {
                              _title = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          child: Icon(Icons.text_fields_sharp),
                          margin: EdgeInsets.only(right: 10, left: 10),
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: singleElement.isEmpty
                                  ? 'Loading Data'
                                  : singleElement['contant'],
                            ),
                            onChanged: (value) {
                              _contant = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _color = 'blueAccent';
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width / 6,
                          width: MediaQuery.of(context).size.width / 6,
                          color: Colors.blueAccent,
                        ),
                      ),
                      GestureDetector(
                        onDoubleTap: () {
                          _color = 'yellowAccent';
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width / 6,
                          width: MediaQuery.of(context).size.width / 6,
                          color: Colors.yellowAccent,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _color = 'greenAccent';
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width / 6,
                          width: MediaQuery.of(context).size.width / 6,
                          color: Colors.greenAccent,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _color = 'redAccent';
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width / 6,
                          width: MediaQuery.of(context).size.width / 6,
                          color: Colors.redAccent,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _color = 'orangeAccent';
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width / 6,
                          width: MediaQuery.of(context).size.width / 6,
                          color: Colors.orangeAccent,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.instance.update({
                  '_id': widget.id,
                  'title': _title,
                  'contant': _contant,
                  'date': DateTime.now().toString(),
                  'color': _color,
                  'is_updated_before': 1
                });
                Navigator.pushNamed(context, HomePage.HomePageKey);
              },
              child: Text('Update Note'),
            )
          ],
        ),
      )),
    );
  }
}
