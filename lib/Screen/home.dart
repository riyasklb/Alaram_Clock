import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:alaram/Provider/Provier.dart';
import 'package:alaram/Screen/Add_Alarm.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool value = false;

  @override
  void initState() {
    context.read<alarmprovider>().Inituilize(context);
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });

    super.initState();
    context.read<alarmprovider>().GetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Text(
          'Alarm Clock',
          style: GoogleFonts.lato(
            textStyle: TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.red,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(36, 0, 0, 0), // Shadow color
                    offset: Offset(0, 4), // Shadow position (horizontal, vertical)
                    blurRadius: 4, // Blurring the shadow
                    spreadRadius: 2, // Extending the shadow
                  ),
                ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            height: MediaQuery.of(context).size.height * 0.1,
            child: Center(
                child: Text(
              DateFormat.yMEd().add_jms().format(
                    DateTime.now(),
                  ),
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            )),
          ),
          SizedBox(
            height: 20,
          ),
          Consumer<alarmprovider>(builder: (context, alarm, child) {
            if (alarm.modelist.isEmpty) {
              // Show message when the list is empty
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Text(
                    'No alarms set yet.',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              // Show the list of alarms when available
              return Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                    itemCount: alarm.modelist.length,
                    itemBuilder: (BuildContext, index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(29, 0, 0, 0), // Shadow color
                                  offset: Offset(0, 2), // Shadow position
                                  blurRadius: 3, // Blurring the shadow
                                  spreadRadius: 1, // Extending the shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            alarm.modelist[index].dateTime!,
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              "|" +
                                                  alarm.modelist[index].label
                                                      .toString(),
                                              style: GoogleFonts
                                                  .lato(), // Applying Google Fonts
                                            ),
                                          ),
                                        ],
                                      ),
                                      CupertinoSwitch(
                                          activeColor: Colors.red,
                                          value: (alarm.modelist[index]
                                                      .milliseconds! <
                                                  DateTime.now()
                                                      .microsecondsSinceEpoch)
                                              ? false
                                              : alarm.modelist[index].check,
                                          onChanged: (v) {
                                            alarm.EditSwitch(index, v);

                                            alarm.CancelNotification(
                                                alarm.modelist[index].id!);
                                          }),
                                    ],
                                  ),
                                  Text(
                                    alarm.modelist[index].when!,
                                    style: GoogleFonts
                                        .lato(), // Applying Google Fonts
                                  )
                                ],
                              ),
                            ),
                          ));
                    }),
              );
            }
          }),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddAlarm()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Button background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 6, // Add elevation to the button
              padding: EdgeInsets.symmetric(vertical: 16), // Adjusts button size
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Add New Alarm',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
