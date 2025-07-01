import 'dart:io';

import 'package:alaram/tools/cutomwidget/cutom_home_button.dart';
import 'package:alaram/views/home/home_screen.dart';
import 'package:alaram/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:alaram/tools/model/profile_model.dart';
import 'package:alaram/tools/constans/color.dart';
import '../auth/register_screen.dart';
import 'package:alaram/tools/model/goal_model.dart';
import 'package:alaram/tools/model/activity_log.dart';
import 'package:alaram/tools/model/daily_activity_model.dart';
import 'package:image_picker/image_picker.dart'; // Add for image picking

// Add Edit Profile Screen
class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> ethnicityOptions = [
    'Asian: Bangladeshi',
    'Asian: Chinese',
    'Asian: Indian',
    'Asian: Pakistani',
    'Asian: Other Asian',
    'Black: African',
    'Black: Caribbean',
    'Black: Other Black',
    'Mixed: White and Asian',
    'Mixed: White and Black African',
    'Mixed: White and Black Caribbean',
    'Mixed: Other Mixed',
    'White: British',
    'White: Irish',
    'White: Gypsy or Irish Traveller',
    'White: Roma',
    'White: Other White',
    'Other: Arab',
    'Other: Any other ethnic group',
  ];

  String? selectedGender;
  String? selectedEthnicity;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _mobileController;
  late TextEditingController _nhsController;
  late TextEditingController _genderController;
  late TextEditingController _ethnicityController;
  late TextEditingController _waterController;
  late TextEditingController _sleepController;
  late TextEditingController _walkingController;

  String? _imagePath;
  final ImagePicker _picker = ImagePicker();
  final profileBox = Hive.box<ProfileModel>('profileBox');

  @override
  void initState() {
    super.initState();
    final profile = profileBox.get('userProfile');
    _usernameController = TextEditingController(text: profile?.username);
    _emailController = TextEditingController(text: profile?.email);
    _ageController = TextEditingController(text: profile?.age?.toString());
    _mobileController = TextEditingController(text: profile?.mobile);
    _nhsController = TextEditingController(text: profile?.nhsNumber);
    _genderController = TextEditingController(text: profile?.gender);
    _ethnicityController = TextEditingController(text: profile?.ethnicity);
    _waterController = TextEditingController(
        text: profile?.waterIntakeGoal?.toString() ?? '0');
    _sleepController =
        TextEditingController(text: profile?.sleepGoal?.toString() ?? '0');
    _walkingController =
        TextEditingController(text: profile?.walkingGoal?.toString() ?? '0');
    _imagePath = profile?.imagePath;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Get existing profile or create new one
      final updatedProfile = profileBox.get('userProfile') ?? ProfileModel();

      // Update fields from form controllers
      updatedProfile.username = _usernameController.text;
      updatedProfile.email = _emailController.text;
      updatedProfile.age =
          int.parse(_ageController.text); // Use parse since validated
      updatedProfile.mobile = _mobileController.text;
      updatedProfile.nhsNumber = _nhsController.text;

      // Handle nullable fields
      updatedProfile.gender =
          _genderController.text.isNotEmpty ? _genderController.text : null;
      updatedProfile.ethnicity = _ethnicityController.text.isNotEmpty
          ? _ethnicityController.text
          : null;

      // Convert goal values properly
      updatedProfile.waterIntakeGoal = double.tryParse(_waterController.text);
      updatedProfile.sleepGoal = double.tryParse(_sleepController.text);
      updatedProfile.walkingGoal = double.tryParse(_walkingController.text);

      // Preserve existing image path if not updating
      updatedProfile.imagePath =
          _imagePath; // Uncomment if you have image handling

      // Save updated profile
      profileBox.put('userProfile', updatedProfile);

      Get.to(HomeScreen()); // Return to profile screen
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kwhite,
      appBar: AppBar(
        title: Text('Edit Profile', style: GoogleFonts.poppins(color: kblack)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60.r,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      _imagePath != null && File(_imagePath!).existsSync()
                          ? FileImage(File(_imagePath!))
                          : null,
                  child: _imagePath == null
                      ? Icon(Icons.camera_alt, size: 40.r, color: Colors.blue)
                      : null,
                ),
              ),
              SizedBox(height: 20.h),
              _buildEditableField('Username', _usernameController),
              _buildEditableField('Email', _emailController),
              _buildEditableField('Age', _ageController, isNumber: true),
              _buildEditableField('Mobile', _mobileController),
              _buildEditableField('NHS Number', _nhsController),
              _buildDropdownField('Gender', genderOptions, selectedGender,
                  (val) {
                setState(() => selectedGender = val);
              }),
              _buildDropdownField(
                  'Ethnicity', ethnicityOptions, selectedEthnicity, (val) {
                setState(() => selectedEthnicity = val);
              }),
              _buildEditableField('Water Intake Goal (ml)', _waterController,
                  isNumber: true),
              _buildEditableField('Sleep Goal (hours)', _sleepController,
                  isNumber: true),
              _buildEditableField('Walking Goal (steps)', _walkingController,
                  isNumber: true),
              kheight40,
              ElevatedButton.icon(
                onPressed: _saveProfile,
                icon: Icon(Icons.save, color: kwhite, size: 22.sp),
                label: Text(
                  'Save Profile',
                  style: TextStyle(
                    color: kwhite,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 3, // subtle shadow
                  splashFactory: InkRipple.splashFactory,
                ),
              ),
              kheight40,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        validator: (value) =>
            value == null || value.isEmpty ? 'Please select $label' : null,
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      {bool isNumber = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }

          if (label == 'Mobile') {
            if (!RegExp(r'^\d{11}$').hasMatch(value)) {
              return 'Mobile number must be exactly 11 digits';
            }
          }

          if (label == 'NHS Number') {
            if (!RegExp(r'^\d{1,10}$').hasMatch(value)) {
              return 'NHS Number must be up to 10 digits only';
            }
          }

          if (isNumber && double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }

          return null;
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  Future<void> _openBoxes() async {
    await Hive.openBox<ProfileModel>('profileBox');
    await Hive.openBox<Goal>('goals');
    await Hive.openBox('settingsBox');
    await Hive.openBox<ActivityLog>('activityLogs');
    await Hive.openBox<DailyActivityModel>('dailyActivities');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _openBoxes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Failed to open Hive boxes.'));
        }

        final profileBox = Hive.box<ProfileModel>('profileBox');
        // final goalBox = Hive.box<Goal>('goals');
        // final settingsBox = Hive.box('settingsBox');
        // final activitylog = Hive.box<ActivityLog>('activityLogs');
        // final dailyactivitybox = Hive.box<DailyActivityModel>('dailyActivities');

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Profile',
              style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: kwhite,
              ),
            ),
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purpleAccent, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            elevation: 0,
            actions: [
              TextButton.icon(
                onPressed: () => Get.to(EditProfileScreen()),
                icon: Icon(Icons.edit, color: Colors.white, size: 22.r),
                label: Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(profileBox),
                  SizedBox(height: 20.h),
                  _buildSectionTitle('Profile Information'),
                  SizedBox(height: 10.h),
                  ..._buildProfileCards(profileBox),
                  SizedBox(height: 20.h),
                  CustomHomeButton(),
                  //   _buildLogoutButton(context, profileBox, goalBox, settingsBox, activitylog, dailyactivitybox),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(String label, String? value) {
    IconData iconData;
    switch (label) {
      case 'Username':
        iconData = Icons.person;
        break;
      case 'Email':
        iconData = Icons.email;
        break;
      case 'Age':
        iconData = Icons.cake;
        break;
      case 'Mobile':
        iconData = Icons.phone;
        break;
      case 'NHS Number':
        iconData = Icons.local_hospital;
        break;
      case 'Gender':
        iconData = Icons.transgender;
        break;
      case 'Ethnicity':
        iconData = Icons.people;
        break;
      case 'Water Intake Goal':
        iconData = Icons.local_drink;
        break;
      case 'Sleep Goal':
        iconData = Icons.bed;
        break;
      case 'Walking Goal':
        iconData = Icons.directions_walk;
        break;
      default:
        iconData = Icons.info;
        break;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 4,
      color: Colors.blue[50],
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(iconData, size: 28.r, color: Colors.blueAccent),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800])),
                  SizedBox(height: 4.h),
                  Text(value ?? 'Not Available',
                      style: GoogleFonts.poppins(
                          fontSize: 16.sp, color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: Colors.purpleAccent),
    );
  }

  Widget _buildProfileHeader(Box<ProfileModel> profileBox) {
    final profile = profileBox.get('userProfile');
    final imagePath = profile?.imagePath;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purpleAccent, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black26, blurRadius: 10.r, offset: Offset(0, 4)),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: imagePath != null && File(imagePath).existsSync()
                  ? Image.file(
                      File(imagePath),
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.person,
                      size: 60.r,
                      color: Colors.blueAccent,
                    ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  profileBox.get('userProfile')?.username ?? 'User',
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  profileBox.get('userProfile')?.email ?? 'Email',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
    );
  }

  List<Widget> _buildProfileCards(Box<ProfileModel> profileBox) {
    return [
      _buildProfileCard('Username', profileBox.get('userProfile')?.username),
      _buildProfileCard('Email', profileBox.get('userProfile')?.email),
      _buildProfileCard('Age', profileBox.get('userProfile')?.age?.toString()),
      _buildProfileCard('Mobile', profileBox.get('userProfile')?.mobile),
      _buildProfileCard('NHS Number', profileBox.get('userProfile')?.nhsNumber),
      _buildProfileCard('Gender', profileBox.get('userProfile')?.gender),
      _buildProfileCard('Ethnicity', profileBox.get('userProfile')?.ethnicity),
      _buildProfileCard(
          'Water Intake Goal',
          profileBox.get('userProfile')?.waterIntakeGoal?.toString() ??
              'Not Set'),
      _buildProfileCard('Sleep Goal',
          profileBox.get('userProfile')?.sleepGoal?.toString() ?? 'Not Set'),
      _buildProfileCard('Walking Goal',
          profileBox.get('userProfile')?.walkingGoal?.toString() ?? 'Not Set'),
    ];
  }


  // Widget _buildLogoutButton(BuildContext context, Box profileBox, Box goalBox,
  //     Box settingsBox, Box activityLogsBox, Box dailyActivitiesBox) {
  //   return ElevatedButton(
  //     onPressed: () {
  //       // profileBox.clear();
  //       // goalBox.clear();
  //       // settingsBox.clear();
  //       // activityLogsBox.clear();
  //       // dailyActivitiesBox.clear();
  //       Get.offAll(SplashScreen());
  //     },
  //     style: ElevatedButton.styleFrom(
  //       padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
  //       backgroundColor: Colors.redAccent,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
  //     ),
  //     child: Text(
  //       'Logout',
  //       style: GoogleFonts.poppins(
  //         fontSize: 18.sp,
  //         fontWeight: FontWeight.bold,
  //         color: Colors.white,
  //       ),
  //     ),
  //   );
  // }
}
