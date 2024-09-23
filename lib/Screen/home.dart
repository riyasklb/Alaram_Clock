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
      backgroundColor: Color(0xFFEEEFF5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          )
        ],
        title: Text(
          'Alarm Clock',
          style: GoogleFonts.lato(
            // Applying Google Fonts
            textStyle: TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(36, 0, 0, 0), // Shadow color
                    offset:
                        Offset(0, 4), // Shadow position (horizontal, vertical)
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
                // Applying Google Fonts
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            )),
          ),
          SizedBox(
            height: 20,
          ),
          Consumer<alarmprovider>(builder: (context, alarm, child) {
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
                                color: const Color.fromARGB(
                                    53, 0, 0, 0), // Shadow color
                                offset: Offset(0, 4), // Shadow position
                                blurRadius: 6, // Blurring the shadow
                                spreadRadius: 2, // Extending the shadow
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          alarm.modelist[index].dateTime!,
                                          style: GoogleFonts.roboto(
                                            // Applying Google Fonts
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
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
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddAlarm()));
        },
        backgroundColor: Colors.red,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        // Optional: You can add elevation or adjust other properties
        elevation: 6,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // Center the FAB
    );
  }
}
