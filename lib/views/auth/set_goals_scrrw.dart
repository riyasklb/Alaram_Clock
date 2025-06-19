import 'package:alaram/tools/model/profile_model.dart';
import 'package:alaram/views/auth/set_goals_with_remider_screen.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class GoalSettingScreen extends StatefulWidget {
   final bool showExtraOptions;
   
  GoalSettingScreen({Key? key, this.showExtraOptions = false}) : super(key: key);
  @override
  State<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  final TextEditingController waterIntakeController = TextEditingController();
  final TextEditingController sleepController = TextEditingController();
  final TextEditingController walkingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
// <-- This is your flag


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Set Your Goals',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildBackgroundImage(), // Background Image
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 250.h),
                    _buildGoalCard(
                      controller: waterIntakeController,
                      labelText: 'Water Intake Goal (Liters)',
                      hintText: 'Enter your daily water intake goal',
                      icon: Icons.local_drink_rounded,
                    ),
                    SizedBox(height: 16.h),
                    _buildGoalCard(
                      controller: sleepController,
                      labelText: 'Sleep Goal (Hours)',
                      hintText: 'Enter your daily sleep goal',
                      icon: Icons.bedtime_rounded,
                    ),
                    SizedBox(height: 16.h),
                    _buildGoalCard(
                      controller: walkingController,
                      labelText: 'Walking Goal (Hours)',
                      hintText: 'Enter your daily walking goal',
                      icon: Icons.directions_walk_rounded,
                    ),
                    SizedBox(height: 30.h),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading) _buildLoadingIndicator(),
        ],
      ),
    );
  }

  /// 🌟 **Background Image**
  Widget _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/logo/top-view-pills-with-spoon.jpg"), // Add your background image
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
        ),
      ),
    );
  }

  /// 🏆 **Goal Input Card**
  Widget _buildGoalCard({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: TextFormField(
         
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600),
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.blueAccent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$labelText cannot be empty';
            }
            if (double.tryParse(value) == null) {
              return 'Enter a valid number';
            }
            return null;
          },
        ),
      ),
    );
  }

  /// 🎯 **Save Goals Button with Animation**
  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _saveGoals,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: _isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  'Save Goals',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  /// 🔄 **Loading Indicator**
  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      ),
    );
  }

  /// ✅ **Save Goal Logic**
  Future<void> _saveGoals() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(Duration(seconds: 1));

      try {
        final profileBox = Hive.box<ProfileModel>('profileBox');
        final profile = profileBox.get('userProfile')!;

        profile.waterIntakeGoal = double.parse(waterIntakeController.text);
        profile.sleepGoal = double.parse(sleepController.text);
        profile.walkingGoal = double.parse(walkingController.text);

        await profile.save();

        DelightToastBar(
          builder: (context) => const ToastCard(
            leading: Icon(Icons.check_circle, color: Colors.green, size: 28),
            title: Text("Goals saved successfully!", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          ),
          snackbarDuration: Duration(milliseconds: 2000),
          position: DelightSnackbarPosition.top,
          autoDismiss: true,
        ).show(context);

          if (widget.showExtraOptions) {
               Get.back();
        // Navigate to OptionalGoalSettingScreen and remove all routes
     
      } else {
        Get.offAll(() => OptionalGoalSettingScreen());
        // Just pop back to previous screen
      }
      } catch (e) {
        DelightToastBar(
          builder: (context) => const ToastCard(
            leading: Icon(Icons.error, color: Colors.red, size: 28),
            title: Text("Failed to save goals!", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          ),
          snackbarDuration: Duration(milliseconds: 2000),
          position: DelightSnackbarPosition.top,
          autoDismiss: true,
        ).show(context);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
