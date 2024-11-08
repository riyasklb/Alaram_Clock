import 'package:alaram/tools/model/profile_model.dart';
import 'package:alaram/views/auth/set_goals_with_remider_screen.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';


class GoalSettingScreen extends StatefulWidget {
  @override
  State<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  final TextEditingController waterIntakeController = TextEditingController();
  final TextEditingController sleepController = TextEditingController();
  final TextEditingController walkingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set Your Goals',
          style: GoogleFonts.poppins(
              fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                _buildGoalField(
                  controller: waterIntakeController,
                  labelText: 'Water Intake Goal (Liters)',
                  hintText: 'Enter your daily water intake goal',
                  icon: Icons.water_drop,
                ),
                SizedBox(height: 16.h),
                _buildGoalField(
                  controller: sleepController,
                  labelText: 'Sleep Goal (Hours)',
                  hintText: 'Enter your daily sleep goal',
                  icon: Icons.bedtime,
                ),
                SizedBox(height: 16.h),
                _buildGoalField(
                  controller: walkingController,
                  labelText: 'Walking Goal (Hours)',
                  hintText: 'Enter your daily walking goal',
                  icon: Icons.directions_walk,
                ),
                SizedBox(height: 30.h),
                ElevatedButton(
                  onPressed: _saveGoals,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(
                        horizontal: 100.w, vertical: 15.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Save Goals',
                    style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        filled: true,
        fillColor: Colors.grey[200],
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
    );
  }

  Future<void> _saveGoals() async {
    if (_formKey.currentState!.validate()) {
      final profileBox = Hive.box<ProfileModel>('profileBox');
      final profile = profileBox.get('userProfile')!;

      profile.waterIntakeGoal = double.parse(waterIntakeController.text);
      profile.sleepGoal = double.parse(sleepController.text);
      profile.walkingGoal = double.parse(walkingController.text);

      await profile.save();
    DelightToastBar(
              builder: (context) => const ToastCard(
                leading: Icon(
                  Icons.flutter_dash,
                  size: 28,
                ),
                title: Text(
                  "Goals saved successfully!",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ).show(context);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Goals saved successfully!'),
      //   ),
      // );

     Get.offAll(OptionalGoalSettingScreen());
    }
  }
}
