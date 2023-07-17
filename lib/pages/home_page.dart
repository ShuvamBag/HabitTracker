import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habittracker/datetime/time_format.dart';
import 'package:habittracker/util/monthly_summary.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schedulers/schedulers.dart';
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
  final user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
     // if this is the 1st time ever openin the app, then create default data
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );

    });
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  // text controller
  final _controller = TextEditingController();
  final TextEditingController _startdatecontroller = TextEditingController();
  final TextEditingController _timecontroller = TextEditingController();
  final TextEditingController _interval = TextEditingController();
  get nameofhabit => _controller.text;
  // checkbox was tapped




  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }




 Future createNewNotification() async {
    String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    String utcTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
        id: 10,
        channelKey: 'scheduled',
        title: _controller.text,
        body: "Remainder for $nameofhabit" ,
        wakeUpScreen: true,

    ),
    );
    _controller.clear();
    _timecontroller.clear();
    _startdatecontroller.clear();
  }
  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([
        _controller.text,
        false,
        _startdatecontroller.text,
        _timecontroller.text

      ]);

    });
    Navigator.of(context).pop();

    db.updateDataBase();
    print(_startdatecontroller.text);
    print(_timecontroller.text);
    int year = int.parse(_startdatecontroller.text.substring(0,4));
    int month = int.parse(_startdatecontroller.text.substring(5,7));
    int date = int.parse(_startdatecontroller.text.substring(8,10));
    int hour = int.parse(Hour(_timecontroller.text));
    int minute = int.parse(Minute(_timecontroller.text));
    final scheduler = TimeScheduler();

    scheduler.run(() {
      createNewNotification();
    }, DateTime(year,month,date,hour,minute));

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
          gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [Colors.green.shade50, Colors.green.shade300])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(onPressed: (){},icon: Icon(Icons.account_circle_rounded),),
            title: Center(child: Text('Track your Habits')),
            actions: [IconButton(onPressed: (signUserOut), icon: Icon(Icons.logout)),],
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: createNewTask,
            child: Icon(Icons.add),
          ),
          body: ListView(
            children: [
              MonthlySummary(
                  datasets: db.heatMapDataSet,
                  startDate: _myBox.get("STARTDATE")),
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
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("Logged in as "+user.email!,style: TextStyle(fontSize: 15),),
              ],),
              SizedBox(height: 20,),
            ],
          )),
    );
  }
}
