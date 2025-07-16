// lib/controllers/register_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:alaram/tools/model/profile_model.dart';

class RegisterController extends GetxController {
  // Form Controllers
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final ageController = TextEditingController();
  final mobileController = TextEditingController();
  final nhsNumberController = TextEditingController();

  // Reactive State Variables
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxString selectedGender = 'Select Gender'.obs;
  final RxString selectedEthnicity = 'Select Ethnicity'.obs;
  final RxBool isPrivacyChecked = false.obs;
  final RxBool isLoading = false.obs;

  // Form Key
  final formKey = GlobalKey<FormState>();

  // Image Picker Function
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 85,
      );

      if (croppedFile != null) {
        profileImage.value = File(croppedFile.path);
      }
    }
  }

//String registerDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  // Save Data Function
  Future<bool> saveData() async {
    isLoading.value = true;
    
    try {
      String? imagePath;
      if (profileImage.value != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(profileImage.value!.path)}';
        final savedImage = await profileImage.value!.copy('${appDir.path}/$fileName');
        imagePath = savedImage.path;
      }

      final profileBox = Hive.box<ProfileModel>('profileBox');
      final settingsBox = Hive.box('settingsBox');

      final profile = ProfileModel()
        ..username = usernameController.text.trim()
        ..email = emailController.text.trim()
        ..age = int.parse(ageController.text)
        ..mobile = mobileController.text.trim()
        ..nhsNumber = nhsNumberController.text.trim()
         ..gender = selectedGender.value == 'Select Gender' 
        ? 'Not specified' 
        : selectedGender.value
    ..ethnicity = selectedEthnicity.value == 'Select Ethnicity' 
        ? 'Not specified' 
        : selectedEthnicity.value
        ..imagePath = imagePath
        ..registerdate=DateTime.now(); 
      await profileBox.put('userProfile', profile);
      await settingsBox.put('isRegistered', true);

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save profile: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

 bool validateForm() {
    return formKey.currentState?.validate() ?? false &&
        selectedGender.value != 'Select Gender' &&
        selectedEthnicity.value != 'Select Ethnicity' &&
        isPrivacyChecked.value;
  }
  // Reset function
  @override
  void onClose() {
    emailController.dispose();
    usernameController.dispose();
    ageController.dispose();
    mobileController.dispose();
    nhsNumberController.dispose();
    super.onClose();
  }
}