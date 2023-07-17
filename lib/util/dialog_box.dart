import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'my_button.dart';

class DialogBox extends StatefulWidget {
  final controller;
  late final startdatecontroller;
  late final timecontroller;
  final interval;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    required this.startdatecontroller,
    required this.timecontroller,
    required this.interval,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[300],
      content: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // get user input
            TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Name of new task",
              ),
            ),
            TextField(
              controller: widget.startdatecontroller,
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_month),
                border: OutlineInputBorder(),
                hintText: "Enter Start Date",
              ),
              onTap: () async {
                DateTime? pickeddate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2026));

                if (pickeddate != null) {
                  setState(() {
                    widget.startdatecontroller.text =
                        DateFormat('yyyy-MM-dd').format(pickeddate);
                  });
                }
              },
            ),
            TextField(
              controller: widget.timecontroller,
              decoration: InputDecoration(
                icon: Icon(Icons.access_time),
                border: OutlineInputBorder(),
                hintText: "Enter Time",
              ),
              onTap: () async {
                TimeOfDay? pickedtime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: 12, minute: 00));

                if (pickedtime != null) {
                  setState(() {
                    widget.timecontroller.text =
                        pickedtime.format(context).toString();
                  });
                }
              },
            ),
            // TextField(
            //   controller: widget.interval,
            //   decoration: InputDecoration(
            //     icon: Icon(Icons.repeat),
            //     border: OutlineInputBorder(),
            //     hintText: "Repeats after",
            //   ),
            //   onTap: () async {
            //     TimeOfDay? pickedtime = await showTimePicker(
            //         context: context,
            //         initialTime: TimeOfDay(hour: 12, minute: 00));
            //
            //     if (pickedtime != null) {
            //       setState(() {
            //         widget.timecontroller.text =
            //             pickedtime.format(context).toString();
            //       });
            //     }
            //   },
            // ),

            // buttons -> save + cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // save button
                MyButton(text: "Save", onPressed: widget.onSave),

                const SizedBox(width: 8),

                // cancel button
                MyButton(text: "Cancel", onPressed: widget.onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
