import 'dart:io';

import 'package:alaram/tools/constans/model/hive_model.dart';
import 'package:alaram/tools/constans/model/profile_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';




class PdfGenerateController extends GetxController {
  late Box<ActivityModel> activityBox;
  late Box<ProfileModel> profileBox;
  ProfileModel? profile;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    activityBox = Hive.box<ActivityModel>('activityBox');
    profileBox = Hive.box<ProfileModel>('profileBox');
    profile = profileBox.get('userProfile');
  }

  List<ActivityModel> filterDailyData() {
    String today = DateTime.now().toString().split(' ')[0];
    return activityBox.values
        .where((activity) => activity.date.toString().split(' ')[0] == today)
        .toList();
  }

  List<ActivityModel> filterWeeklyData() {
    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));
    return activityBox.values
        .where((activity) => activity.date.isAfter(sevenDaysAgo))
        .toList();
  }

  List<ActivityModel> filterMonthlyData() {
    DateTime now = DateTime.now();
    return activityBox.values
        .where((activity) =>
            activity.date.month == now.month && activity.date.year == now.year)
        .toList();
  }

  Future<void> generateAndSharePdf(List<ActivityModel> activities) async {
    if (activities.isEmpty) {
      Get.snackbar('Error', 'No data available for export');
      return;
    }

    isLoading.value = true;

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(16.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Activity Report',
                    style: pw.TextStyle(
                      fontSize: 26,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  if (profile != null) _buildPdfProfileSection(),
                  pw.SizedBox(height: 20),
                  _buildPdfOverviewSection(),
                  pw.SizedBox(height: 20),
                  ...activities.map((activity) => _buildPdfRow(activity)).toList(),
                  _buildPdfConclusionSection(),
                ],
              ),
            );
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/activity_report.pdf");
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(file.path)], text: 'Here is your activity report!');
    } finally {
      isLoading.value = false;
    }
  }

  pw.Widget _buildPdfProfileSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Profile Details',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Text('Username: ${profile!.username}'),
        pw.Text('NHS Number: ${profile!.nhsNumber}'),
      ],
    );
  }

  pw.Widget _buildPdfOverviewSection() {
    int totalActivities = activityBox.length;
    double averageWalking = activityBox.values
            .map((e) => e.minutesWalked)
            .reduce((a, b) => a + b) /
        totalActivities;
    double averageSleep = activityBox.values
            .map((e) => e.hoursSlept)
            .reduce((a, b) => a + b) /
        totalActivities;
    double averageWaterIntake = activityBox.values
            .map((e) => e.waterIntake)
            .reduce((a, b) => a + b) /
        totalActivities;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Activity Overview',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Text('Total Activities: $totalActivities'),
        pw.Text(
            'Average Walking Time: ${averageWalking.toStringAsFixed(1)} minutes'),
        pw.Text('Average Sleep: ${averageSleep.toStringAsFixed(1)} hours'),
        pw.Text(
            'Average Water Intake: ${averageWaterIntake.toStringAsFixed(1)} liters'),
      ],
    );
  }

  pw.Widget _buildPdfRow(ActivityModel activity) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Date: ${activity.date.toString().split(' ')[0]}',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text('Walking: ${activity.minutesWalked} minutes'),
          pw.Text('Sleep: ${activity.hoursSlept} hours'),
          pw.Text('Water Intake: ${activity.waterIntake} liters'),
        ],
      ),
    );
  }

  pw.Widget _buildPdfConclusionSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 20),
        pw.Text(
          'Conclusion',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Tracking your activities is essential for maintaining a healthy lifestyle. '
          'Keep up the great work, and continue to prioritize your health!',
        ),
      ],
    );
  }



 
  

  // // Method to generate and share Excel file
  // Future<void> generateAndShareExcel(List<ActivityModel> activities) async {
  //   if (activities.isEmpty) {
  //     Get.snackbar('Error', 'No data available for export');
  //     return;
  //   }

  //   isLoading.value = true;

  //   try {
  //     final Workbook workbook = new Workbook();
  //     // Create a new Excel document
  //    // final xlsio.Workbook workbook = xlsio.Workbook();
  //     final xlsio.Worksheet sheet = workbook.worksheets[0];

  //     // Set column headers
  //     sheet.getRangeByName('A1').setText('Date');
  //     sheet.getRangeByName('B1').setText('Minutes Walked');
  //     sheet.getRangeByName('C1').setText('Hours Slept');
  //     sheet.getRangeByName('D1').setText('Water Intake (Liters)');

  //     // Add data rows
  //     for (int i = 0; i < activities.length; i++) {
  //       ActivityModel activity = activities[i];
  //       sheet.getRangeByName('A${i + 2}').setText(activity.date.toString().split(' ')[0]);
  //       sheet.getRangeByName('B${i + 2}').setNumber(activity.minutesWalked.toDouble());
  //       sheet.getRangeByName('C${i + 2}').setNumber(activity.hoursSlept.toDouble());
  //       sheet.getRangeByName('D${i + 2}').setNumber(activity.waterIntake.toDouble());
  //     }

  //     // Save the Excel file to a temporary directory
  //     final List<int> bytes = workbook.saveAsStream();
  //     workbook.dispose();

  //     final directory = await getTemporaryDirectory();
  //     final path = "${directory.path}/activity_report.xlsx";
  //     final file = File(path);
  //     await file.writeAsBytes(bytes, flush: true);

  //     // Share the Excel file
  //     await Share.shareXFiles([XFile(file.path)], text: 'Here is your activity report in Excel format!');
  //   } catch (e) {
  //     Get.snackbar('Error', 'Error generating Excel file: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
