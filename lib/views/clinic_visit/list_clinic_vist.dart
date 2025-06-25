
import 'package:alaram/tools/model/clinical_visit_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClinicalVisitListScreen extends StatefulWidget {
  const ClinicalVisitListScreen({super.key});

  @override
  State<ClinicalVisitListScreen> createState() => _ClinicalVisitListScreenState();
}

class _ClinicalVisitListScreenState extends State<ClinicalVisitListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ClinicalVisit> _allVisits = [];
  List<ClinicalVisit> _filteredVisits = [];

  @override
  void initState() {
    super.initState();
    final box = Hive.box<ClinicalVisit>('clinical_visits');
    _allVisits = box.values.toList();
    _filteredVisits = _allVisits;

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredVisits = _allVisits.where((visit) {
          return visit.notes.toLowerCase().contains(query) ||
              visit.appointmentType.toLowerCase().contains(query) ||
              visit.history.toLowerCase().contains(query);
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F5FA),
      appBar: AppBar(
        title: Text(
          'All Clinical Visits',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo.shade600,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            _buildSearchField(),
            SizedBox(height: 12.h),
            _filteredVisits.isEmpty
                ? Expanded(
                    child: Center(
                      child: Text(
                        'No visits found.',
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      itemCount: _filteredVisits.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final visit = _filteredVisits[index];
                        return _buildVisitCard(visit);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      style: GoogleFonts.poppins(fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: 'Search by note, history or type...',
        hintStyle: GoogleFonts.poppins(fontSize: 13.sp),
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildVisitCard(ClinicalVisit visit) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat.yMMMMd().format(visit.date),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
              color: Colors.indigo,
            ),
          ),
          SizedBox(height: 6.h),
          _infoRow('Type', visit.appointmentType),
          _infoRow('Notes', visit.notes),
          if (visit.history.isNotEmpty) _infoRow('History', visit.history),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
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
}
