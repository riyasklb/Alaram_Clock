import 'dart:math';

import 'package:alaram/Provider/Provier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddAlarm extends StatefulWidget {
  const AddAlarm({super.key});

  @override
  State<AddAlarm> createState() => _AddAlaramState();
}

class _AddAlaramState extends State<AddAlarm> {
  late TextEditingController controller;

  String? dateTime;
  bool repeat = false;

  DateTime? notificationtime;

  String? name = "none";
  int? Milliseconds;

  @override
  void initState() {
    controller = TextEditingController();
    context.read<alarmprovider>().GetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        title:  Text(
          'Add Alarm',
          style: GoogleFonts.lato( // Apply Google Font here
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: Colors.white),
          ),
        ),
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: CupertinoDatePicker(
              showDayOfWeek: true,
              minimumDate: DateTime.now(),
              dateOrder: DatePickerDateOrder.dmy,
              onDateTimeChanged: (va) {
                dateTime = DateFormat().add_jms().format(va);

                Milliseconds = va.microsecondsSinceEpoch;

                notificationtime = va;

                print(dateTime);
              },
            )),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: CupertinoTextField(
                  placeholder: "Add Label",
                  controller: controller,
                )),
          ),
           SizedBox(height: 20,),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
          'Repeat daily',
          style: GoogleFonts.lato( // Apply Google Font here
            textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
              ),
              CupertinoSwitch(activeColor: Colors.red,
                value: repeat,
                onChanged: (bool value) {
                  repeat = value;

                  if (repeat == false) {
                    name = "none";
                  } else {
                    name = "Everyday";
                  }

                  setState(() {});
                },
              ),
            ],
          ),SizedBox(height: 50,),
          Container(width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: ElevatedButton(
                onPressed: () {
                  Random random = new Random();
                  int randomNumber = random.nextInt(100);

                  context.read<alarmprovider>().SetAlaram(controller.text,
                      dateTime!, true, name!, randomNumber, Milliseconds!);
                  context.read<alarmprovider>().SetData();

                  context
                      .read<alarmprovider>()
                      .SecduleNotification(notificationtime!, randomNumber);

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 6, // Add elevation to the button
                  padding:
                      EdgeInsets.symmetric(vertical: 16), // Adjusts button size
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, ),
                  child: Text(
                    "Set Alaram",
                 style: GoogleFonts.lato( // Apply Google Font here
            textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,color: Colors.white),
          ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
