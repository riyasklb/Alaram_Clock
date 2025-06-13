import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/model/profile_model.dart';
import 'package:alaram/views/auth/set_goals_scrrw.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController nhsNumberController = TextEditingController();
  String? selectedGender;
  String? selectedEthnicity;
  bool isLoading = false;
  bool isPrivacyChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.h),

                    // Logo with a colored border
                    Image.asset(
                      'assets/logo/log-in.png',
                      height: 340,
                    ),

                    SizedBox(height: 40.h),

                    // Card Wrapper for Inputs
                    Card(
                      color: Colors.white.withOpacity(0.9),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: usernameController,
                              labelText: 'Username',
                              hintText: 'Enter your username',
                              icon: Icons.person,
                              validator: (value) => value!.isEmpty
                                  ? 'Username cannot be empty'
                                  : null,
                            ),
                            SizedBox(height: 16.h),
                            _buildTextField(
                              controller: emailController,
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              icon: Icons.email,
                              inputType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Email cannot be empty';
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 16.h),
                            _buildTextField(
                              controller: ageController,
                              labelText: 'Age',
                              hintText: 'Enter your age',
                              icon: Icons.cake,
                              inputType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Age cannot be empty';
                                if (int.tryParse(value) == null ||
                                    int.parse(value) <= 0) {
                                  return 'Enter a valid age';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),
                            _buildTextField(
                              controller: mobileController,
                              labelText: 'Mobile Number',
                              hintText: 'Enter your mobile number',
                              icon: Icons.phone,
                              inputType: TextInputType.phone,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Mobile number cannot be empty';
                                if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                  return 'Enter a valid 10-digit mobile number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),
                            _buildTextField(
                              controller: nhsNumberController,
                              labelText: 'NHS Number',
                              hintText: 'Enter your NHS number',
                              icon: Icons.verified,
                              inputType: TextInputType.number,
                              validator: (value) => value!.isEmpty
                                  ? 'NHS number cannot be empty'
                                  : null,
                            ),
                            SizedBox(height: 16.h),
                            // Gender Dropdown
                            _buildDropdown(
                              label: 'Gender',
                              icon: Icons.people,
                              items: ['Male', 'Female', 'Other'],
                              selectedValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                });
                              },
                            ),
                            SizedBox(height: 16.h),
// Ethnicity Dropdown
                            _buildDropdown(
                              label: 'Ethnicity',
                              icon: Icons.public,
                              items: [
                            //    'Asian: Bangladeshi'
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
                              ],
                              selectedValue: selectedEthnicity,
                              onChanged: (value) {
                                setState(() {
                                  selectedEthnicity = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Checkbox
                    CheckboxListTile(
                      title: Text(
                        "I accept the responsibility for my personal data.",
                        style: GoogleFonts.poppins(
                            fontSize: 14.sp, color: Colors.white),
                      ),
                      value: isPrivacyChecked,
                      onChanged: (value) {
                        setState(() {
                          isPrivacyChecked = value!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.orange,
                      checkColor: Colors.white,
                    ),

                    SizedBox(height: 30.h),

                    // Animated Button with gradient
                _buildRegisterButton(context),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
void _showErrorToast(BuildContext context) {
  DelightToastBar(
    builder: (context) => const ToastCard(
      leading: Icon(
        Icons.warning,
        size: 28,
        color: Colors.red,
      ),
      title: Text(
        "Please complete all fields and confirm responsibility.",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    ),
    snackbarDuration: Duration(milliseconds: 2000),
    position: DelightSnackbarPosition.top,
    autoDismiss: true,
  ).show(context);
}

Widget _buildRegisterButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      if (_formKey.currentState!.validate() &&
          selectedGender != null &&
          selectedEthnicity != null &&
          isPrivacyChecked) {
        _saveData(context);
      } else {
        _showErrorToast(context);
      }
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pinkAccent, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 100.w),
      alignment: Alignment.center,
      child: isLoading
          ? FadeTransition(
              opacity: AlwaysStoppedAnimation(0.8),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              'Register',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
    ),
  );
}

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        obscureText: obscureText,
        keyboardType: inputType,
        style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.black),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle:
              GoogleFonts.poppins(fontSize: 14.sp, color: Colors.blueAccent),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required List<String> items,
    required String? selectedValue,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              GoogleFonts.poppins(fontSize: 14.sp, color: Colors.blueAccent),
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item,
                style:
                    GoogleFonts.poppins(fontSize: 16.sp, color: Colors.black)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _saveData(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    final profileBox = Hive.box<ProfileModel>('profileBox');
    final settingsBox = Hive.box('settingsBox');

    final profile = ProfileModel()
      ..username = usernameController.text
      ..email = emailController.text
      ..age = int.parse(ageController.text)
      ..mobile = mobileController.text
      ..nhsNumber = nhsNumberController.text
      ..gender = selectedGender ?? 'Not specified'
      ..ethnicity = selectedEthnicity ?? 'Not specified';

    await profileBox.put('userProfile', profile);
    await settingsBox.put('isRegistered', true);

    DelightToastBar(
      builder: (context) => const ToastCard(
        leading: Icon(
          Icons.check,
          size: 28,
        ),
        title: Text(
          "Profile successfully saved!",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      snackbarDuration:
          Duration(milliseconds: 2000), // Set toast duration to 2 seconds
      position: DelightSnackbarPosition.top,
      autoDismiss: true, // Automatically dismiss after the specified duration
    ).show(context);

    setState(() {
      isLoading = false;
    });
    Get.offAll(GoalSettingScreen());
  }
}
