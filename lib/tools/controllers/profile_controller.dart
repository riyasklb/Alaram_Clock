import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:alaram/tools/model/profile_model.dart';

class ProfileController extends GetxController {
  final Rx<ProfileModel?> profile = Rx<ProfileModel?>(null);
  final RxDouble sleepGoal = 0.0.obs;
  final RxDouble walkingGoal = 0.0.obs;
  final RxDouble waterGoal = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    final box = Hive.box<ProfileModel>('profileBox');
    final p = box.get('userProfile');
    profile.value = p;
    sleepGoal.value = p?.sleepGoal ?? 0.0;
    walkingGoal.value = p?.walkingGoal ?? 0.0;
    waterGoal.value = p?.waterIntakeGoal ?? 0.0;
  }

  void refreshProfile() {
    loadProfile();
  }
} 