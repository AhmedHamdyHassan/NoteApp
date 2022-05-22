import 'package:flutter/material.dart';
import 'package:notes_app/models/database_helper.dart';
import 'package:notes_app/screens/add_note_screen.dart';
import 'package:notes_app/screens/update_note_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        HomePage.HomePageKey: (context) => HomePage(),
        AddNoteScreen.AddNoteScreenKey: ((context) => AddNoteScreen()),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  static const String HomePageKey = '/HomePage';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isUpdated = true;
  bool isHavingData = false;
  List<Map<String, dynamic>> _dataFromDatabase = [];
  void seeDBWorkOrNot() async {
    await DatabaseHelper.instance.initializeDatabase();
    _dataFromDatabase = await DatabaseHelper.instance.getAll();
    setState(() {});
  }

  void deleteElement(int id) async {
    final deleteElement = _dataFromDatabase.reduce((value, element) {
      if (value['_id'] == id) {
        return value;
      } else {
        return element;
      }
    });
    await DatabaseHelper.instance.delete(id);
    _dataFromDatabase = await DatabaseHelper.instance.getAll();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    seeDBWorkOrNot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App'),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AddNoteScreen.AddNoteScreenKey);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
      body: _dataFromDatabase.length != 0
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemCount: _dataFromDatabase.length,
                  itemBuilder: (BuildContext ctx, index) {
                    print(_dataFromDatabase[index]);
                    return NoteWidget(
                      isUpdated: _dataFromDatabase[index]['is_updated_before'],
                      color: _dataFromDatabase[index]['color'],
                      title: _dataFromDatabase[index]['title'],
                      contant: _dataFromDatabase[index]['contant'],
                      date: _dataFromDatabase[index]['date'],
                      id: _dataFromDatabase[index]['_id'],
                      removeElement: deleteElement,
                    );
                  }),
            )
          : Center(
              child: Text(
                'No Notes Add Please Add Some',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}

class NoteWidget extends StatelessWidget {
  int id;
  late String title, date, contant, color;
  late Function removeElement;
  Map<String, dynamic> colors = {
    'orangeAccent': Colors.blueAccent,
    'redAccent': Colors.redAccent,
    'greenAccent': Colors.greenAccent,
    'yellowAccent': Colors.yellowAccent,
    'blueAccent': Colors.blueAccent,
  };
  NoteWidget({
    Key? key,
    required this.isUpdated,
    required this.title,
    required this.color,
    required this.contant,
    required this.date,
    required this.id,
    required this.removeElement,
  }) : super(key: key);

  final int isUpdated;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width / 2.2,
      height: MediaQuery.of(context).size.width / 2.2,
      decoration: BoxDecoration(
        color: colors[color],
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isUpdated == 1
                    ? Icon(
                        Icons.tips_and_updates_rounded,
                        color: Colors.white,
                        size: 18,
                      )
                    : Icon(
                        Icons.tips_and_updates_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateNoteScreen(id: id),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        removeElement(id);
                      },
                      child: Icon(
                        Icons.delete,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            width: double.infinity,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            width: double.infinity,
            child: Text(
              contant,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            width: double.infinity,
            child: Text(
              isUpdated == 1 ? 'Last update: $date' : 'Date: $date',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
