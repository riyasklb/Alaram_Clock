import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/model/clinical_visit_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClinicalVisitScreen extends StatefulWidget {
  const ClinicalVisitScreen({super.key});

  @override
  State<ClinicalVisitScreen> createState() => _ClinicalVisitScreenState();
}

class _ClinicalVisitScreenState extends State<ClinicalVisitScreen> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedAppointmentType;

List<ClinicalVisit> visits = [];




late Box<ClinicalVisit> visitBox;

@override
void initState() {
  super.initState();
  visitBox = Hive.box<ClinicalVisit>('clinical_visits');
  loadVisits();
}
void loadVisits() {
  final data = visitBox.values.toList();
  setState(() {
    visits = data;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F4F8),
      appBar: AppBar(
        title: Text(
          'Clinical Visits',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade600,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Column(
          children: [
            _buildAddVisitCard(),
            SizedBox(height: 24.h),
            _buildVisitList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddVisitCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.indigo.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.08),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Schedule New Visit",
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.indigo,
            ),
          ),
          SizedBox(height: 16.h),

          ElevatedButton.icon(
            onPressed: _pickDate,
            icon: Icon(Icons.calendar_today, color: Colors.white, size: 18.sp),
            label: Text(
              _selectedDate == null
                  ? 'Pick Visit Date'
                  : DateFormat.yMMMMd().format(_selectedDate!),
              style: GoogleFonts.poppins(fontSize: 14.sp,color: kwhite),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            ),
          ),
          SizedBox(height: 16.h),

          DropdownButtonFormField<String>(
            value: _selectedAppointmentType,
            items: ['GP', 'Hospital', 'Others']
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type, style: GoogleFonts.poppins()),
                    ))
                .toList(),
            onChanged: (val) => setState(() => _selectedAppointmentType = val),
            decoration: InputDecoration(
              labelText: 'Appointment Type',
              labelStyle: GoogleFonts.poppins(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
          SizedBox(height: 16.h),

          TextField(
            controller: _medicalHistoryController,
            style: GoogleFonts.poppins(fontSize: 14.sp),
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Medical History',
              labelStyle: GoogleFonts.poppins(fontSize: 14.sp),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              prefixIcon: Icon(Icons.history),
            ),
          ),
          SizedBox(height: 16.h),

          TextField(
            controller: _noteController,
            maxLines: 3,
            style: GoogleFonts.poppins(fontSize: 14.sp),
            decoration: InputDecoration(
              labelText: 'Notes (Doctor, Clinic, Reason...)',
              labelStyle: GoogleFonts.poppins(fontSize: 13.sp),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              prefixIcon: Icon(Icons.note_alt_rounded),
            ),
          ),
          SizedBox(height: 20.h),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addVisit,
              icon: Icon(Icons.add_circle_outline, size: 18.sp),
              label: Text(
                'Add Visit',
                style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitList() {
    if (visits.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 60.h),
          child: Text(
            'No clinical visits added yet.',
            style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: visits.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final visit = visits[index];
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.05),
                blurRadius: 10.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 24.r,
                  backgroundColor: Colors.indigo.shade100,
                  child: Icon(Icons.local_hospital_rounded, color: Colors.indigo, size: 22.sp),
                ),
                title: Text(
                  DateFormat.yMMMMd().format(visit.date),
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  visit.notes,
                  style: GoogleFonts.poppins(fontSize: 13.sp),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent, size: 22.sp),
                onPressed: () async {
  await visits[index].delete();
  setState(() => visits.removeAt(index));
},

                ),
              ),
              SizedBox(height: 8.h),
              _infoRow('Type', visit.appointmentType),
              if (visit.history != null && visit.history.isNotEmpty)
                _infoRow('History', visit.history),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              color: Colors.grey.shade800,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  void _addVisit() async {
  if (_selectedDate == null ||
      _noteController.text.trim().isEmpty ||
      _selectedAppointmentType == null) {
    Get.snackbar(
      'Missing Info',
      'Please fill in all required fields',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(12.w),
    );
    return;
  }

  final visit = ClinicalVisit()
    ..date = _selectedDate!
    ..notes = _noteController.text.trim()
    ..appointmentType = _selectedAppointmentType!
    ..history = _medicalHistoryController.text.trim();

  await visitBox.add(visit);

  setState(() {
    visits.add(visit);
    _selectedDate = null;
    _selectedAppointmentType = null;
    _noteController.clear();
    _medicalHistoryController.clear();
  });

  Get.snackbar(
    'Visit Added',
    'Your clinical visit has been scheduled.',
    backgroundColor: Colors.green,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    margin: EdgeInsets.all(12.w),
  );
}

}
