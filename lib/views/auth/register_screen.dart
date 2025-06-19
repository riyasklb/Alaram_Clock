import 'dart:io';

import 'package:alaram/tools/constans/color.dart';
import 'package:alaram/tools/controllers/register_controller.dart';
import 'package:alaram/tools/model/profile_model.dart';
import 'package:alaram/views/auth/set_goals_scrrw.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  RegisterScreen({super.key});

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
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.h),
                    
                    // Profile Image Section
                    Obx(() => GestureDetector(
                      onTap: controller.pickImage,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 200.w,
                                height: 200.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: controller.profileImage.value != null
                                      ? FileImage(controller.profileImage.value!)
                                      : const AssetImage('assets/logo/boy.png',) as ImageProvider,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 30.w,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            controller.profileImage.value == null 
                                ? 'Tap to add profile photo' 
                                : 'Change profile photo',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    )),

                    // Form Inputs Card
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
                              controller: controller.usernameController,
                              labelText: 'Username',
                              hintText: 'Enter your username',
                              icon: Icons.person,
                              validator: (value) => value!.isEmpty
                                  ? 'Username cannot be empty'
                                  : null,
                            ),
                            SizedBox(height: 16.h),
                            _buildTextField(
                              controller: controller.emailController,
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              icon: Icons.email,
                              inputType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) return 'Email cannot be empty';
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),
                            _buildTextField(
                              controller: controller.ageController,
                              labelText: 'Age',
                              hintText: 'Enter your age',
                              icon: Icons.cake,
                              inputType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) return 'Age cannot be empty';
                                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                                  return 'Enter a valid age';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),
                            _buildTextField(
                              controller: controller.mobileController,
                              labelText: 'Mobile Number',
                              hintText: 'Enter your mobile number',
                              icon: Icons.phone,
                              inputType: TextInputType.phone,
                                inputFormatters: [
    LengthLimitingTextInputFormatter(11), // Max 11 digits
    FilteringTextInputFormatter.digitsOnly, // Only digits allowed
  ],
                              validator: (value) {
                                if (value!.isEmpty) return 'Mobile number cannot be empty';
                                if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                                  return 'Enter a valid 11-digit mobile number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),
                          _buildTextField(
  controller: controller.nhsNumberController,
  labelText: 'NHS Number',
  hintText: 'Enter your NHS number',
  icon: Icons.verified,
  inputType: TextInputType.number,
  inputFormatters: [
    LengthLimitingTextInputFormatter(10), // Max 10 digits
    FilteringTextInputFormatter.digitsOnly, // Only digits allowed
  ],
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'NHS number cannot be empty';
    } else if (value.length != 10) {
      return 'NHS number must be exactly 10 digits';
    }
    return null;
  },
),

                            SizedBox(height: 16.h),
                            // Gender Dropdown
                           Obx(() => _buildDropdown(
  label: 'Gender',
  icon: Icons.people,
  items: const [
    'Select Gender', // Placeholder
    'Male',
    'Female',
    'Other',
  ],
  selectedValue: controller.selectedGender.value,
  onChanged: (value) {
    controller.selectedGender.value = value ?? 'Select Gender';
  },
)),
                            SizedBox(height: 16.h),
                            // Ethnicity Dropdown
                            Obx(() => _buildDropdown(
  label: 'Ethnicity',
  icon: Icons.public,
  items: const [
    'Select Ethnicity', // Placeholder
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
  selectedValue: controller.selectedEthnicity.value,
  onChanged: (value) {
    controller.selectedEthnicity.value = value ?? 'Select Ethnicity';
  },
)),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Privacy Checkbox
                    Obx(() => CheckboxListTile(
                      title: Text(
                        "I accept the responsibility for my personal data.",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                      value: controller.isPrivacyChecked.value,
                      onChanged: (value) {
                        controller.isPrivacyChecked.value = value ?? false;
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.orange,
                      checkColor: Colors.white,
                    )),

                    SizedBox(height: 30.h),

                    // Register Button
                    Obx(() => _buildRegisterButton(context)),
                    
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
      snackbarDuration: const Duration(milliseconds: 2000),
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
    ).show(context);
  }

  Widget _buildRegisterButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (controller.validateForm()) {
          final success = await controller.saveData();
          if (success) {
            DelightToastBar(
              builder: (context) => const ToastCard(
                leading: Icon(Icons.check, size: 28, color: Colors.green),
                title: Text(
                  "Profile successfully saved!",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
              position: DelightSnackbarPosition.top,
              autoDismiss: true,
            ).show(context);
            
            Get.offAll(() => GoalSettingScreen());
          }
        } else {
          _showErrorToast(context);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
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
        child: controller.isLoading.value
            ? const FadeTransition(
                opacity: AlwaysStoppedAnimation(0.8),
                child: CircularProgressIndicator(
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
    String? Function(String?)? validator,  List<TextInputFormatter> ?inputFormatters,
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
          labelStyle: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: Colors.blueAccent,
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
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
          labelStyle: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: Colors.blueAccent,
          ),
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
        items: items.map((item) {
          final isPlaceholder = items.indexOf(item) == 0;
          return DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                 color: isPlaceholder ? Colors.grey : Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
            validator: (value) {
        if (value == items[0]) { // Check if placeholder is selected
          return 'Please select $label';
        }
        return null;
      },
      ),
    );
  }
}