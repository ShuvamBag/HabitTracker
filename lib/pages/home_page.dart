import 'package:flutter/material.dart';
import 'package:habittracker/util/monthly_summary.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/database.dart';
import '../main.dart';
import '../util/dialog_box.dart';
import '../util/noti.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    Noti.initialize(flutterLocalNotificationsPlugin);// if this is the 1st time ever openin the app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  // text controller
  final _controller = TextEditingController();
  TextEditingController _startdatecontroller = TextEditingController();
  TextEditingController _timecontroller = TextEditingController();
  TextEditingController _interval = TextEditingController();
  // checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false,_startdatecontroller.text,_timecontroller.text]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    Noti.showBigTextNotification(title: _controller.text, body: ".......", fln: flutterLocalNotificationsPlugin);
    db.updateDataBase();
  }

  // create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          startdatecontroller: _startdatecontroller,
          timecontroller: _timecontroller,
          interval: _interval,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.bottomRight,end: Alignment.topLeft,colors: [Colors.green.shade50,Colors.green.shade300])
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(

          title: Center(child: Text('Track your Habits')),
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewTask,
          child: Icon(Icons.add),
        ),
        body: ListView(
          children: [
            MonthlySummary(datasets: db.heatMapDataSet, startDate: _myBox.get("STARTDATE")),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  taskName: db.toDoList[index][0],
                  taskCompleted: db.toDoList[index][1],
                  onChanged: (value) => checkBoxChanged(value, index),
                  deleteFunction: (context) => deleteTask(index),
                );
              },
            ),
          ],
        )
      ),
    );
  }
}