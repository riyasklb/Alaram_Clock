import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();
  final TextEditingController _extraDetailsController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedAppointmentType;

  List<Map<String, dynamic>> visits = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F7FA),
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
        backgroundColor: Colors.blueAccent,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.1),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Schedule New Visit",
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 16.h),

          // Date Picker
          ElevatedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            label: Text(
              _selectedDate == null
                  ? 'Pick Visit Date'
                  : DateFormat.yMMMMd().format(_selectedDate!),
              style: GoogleFonts.poppins(fontSize: 14.sp),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            ),
          ),
          SizedBox(height: 16.h),

          // Appointment Type Dropdown
          DropdownButtonFormField<String>(
            value: _selectedAppointmentType,
            items: ['GP', 'Hospital', 'Others']
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            onChanged: (val) => setState(() => _selectedAppointmentType = val),
            decoration: InputDecoration(
              labelText: 'Appointment Type',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
          SizedBox(height: 16.h),

      
        

          // Medical History
        TextField(
  controller: _medicalHistoryController,
  style: GoogleFonts.poppins(fontSize: 16.sp), // Slightly bigger font
  maxLines: 2, // Adjust this number as needed
  decoration: InputDecoration(
    labelText: 'Medical History',
    labelStyle: GoogleFonts.poppins(fontSize: 16.sp),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
    ),
    prefixIcon: Icon(Icons.history),
    contentPadding: EdgeInsets.symmetric(
      horizontal: 16.w,
      vertical: 20.h, // Increases height
    ),
  ),
),

          SizedBox(height: 16.h),

          // Additional Details
    
          // Notes
          TextField(
            controller: _noteController,
            maxLines: 3,
            style: GoogleFonts.poppins(fontSize: 14.sp),
            decoration: InputDecoration(
              labelText: 'Add Notes (Doctor, Clinic, Reason...)',
              labelStyle: GoogleFonts.poppins(fontSize: 13.sp),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              prefixIcon: const Icon(Icons.note_alt_rounded),
            ),
          ),
          SizedBox(height: 16.h),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addVisit,
              child: Text(
                'Add Visit',
                style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
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
        return Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.local_hospital_rounded,
                    size: 28.sp, color: Colors.blueAccent),
                title: Text(
                  DateFormat.yMMMMd().format(visit['date']),
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  visit['notes'],
                  style: GoogleFonts.poppins(fontSize: 13.sp),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent, size: 22.sp),
                  onPressed: () {
                    setState(() {
                      visits.removeAt(index);
                    });
                  },
                ),
              ),
              SizedBox(height: 4.h),
              if (visit['appointmentType'] != null)
                _infoRow('Type', visit['appointmentType']),
              if (visit['doctorName'] != null && visit['doctorName'].isNotEmpty)
                _infoRow('Doctor', visit['doctorName']),
              if (visit['history'] != null && visit['history'].isNotEmpty)
                _infoRow('History', visit['history']),
              if (visit['extra'] != null && visit['extra'].isNotEmpty)
                _infoRow('Details', visit['extra']),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Text('$title: ', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value, style: GoogleFonts.poppins())),
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

  void _addVisit() {
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

    setState(() {
      visits.add({
        'date': _selectedDate!,
        'notes': _noteController.text.trim(),
        'appointmentType': _selectedAppointmentType,
        'doctorName': _doctorController.text.trim(),
        'history': _medicalHistoryController.text.trim(),
        'extra': _extraDetailsController.text.trim(),
      });

      _selectedDate = null;
      _selectedAppointmentType = null;
      _noteController.clear();
      _doctorController.clear();
      _medicalHistoryController.clear();
      _extraDetailsController.clear();
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
