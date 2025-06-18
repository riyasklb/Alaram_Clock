import 'package:alaram/tools/constans/color.dart';
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
  DateTime? _selectedDate;
  List<Map<String, dynamic>> visits = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F7FA),
      appBar: AppBar(
        title: Text(
          'Clinical Visits',
          style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w600,color: kwhite),
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
          ElevatedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today,color: Colors.white,),
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
          child: ListTile(
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
        );
      },
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
    if (_selectedDate == null || _noteController.text.trim().isEmpty) {
      Get.snackbar(
        'Missing Info',
        'Please select a date and enter notes',
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
      });
      _selectedDate = null;
      _noteController.clear();
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
