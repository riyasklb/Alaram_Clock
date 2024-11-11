import 'package:alaram/tools/model/goal_model.dart';
import 'package:alaram/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class OptionalGoalSettingController extends GetxController {
  // List of medicines where each medicine is represented as a map.
  var medicines = <Map<String, dynamic>>[].obs;

  // Reactive variables for toggles
  var enableBreakfast = false.obs;
  var enableLunch = false.obs;
  var enableDinner = false.obs;

  // Method to add a new medicine entry
  void addMedicine() {
    medicines.add({
      'name': null,
      'quantityController': TextEditingController(),
      'selectedTimes': <String>[],
      'frequency': null,
      'dosageController': TextEditingController(),
    });
  }

  // Method to update medicine name at a specific index
  void updateMedicineName(int index, String? name) {
    medicines[index]['name'] = name;
    medicines.refresh(); // Notify observers
  }

  // Method to update selected times for medicine at a specific index
  void updateSelectedTimes(int index, List<String> selectedTimes) {
    medicines[index]['selectedTimes'] = selectedTimes;
    medicines.refresh(); // Notify observers
  }

  // Method to update frequency for medicine at a specific index
  void updateFrequency(int index, String? frequency) {
    medicines[index]['frequency'] = frequency;
    medicines.refresh(); // Notify observers
  }

  // Method to remove a medicine entry at a specific index
  void removeMedicine(int index) {
    medicines.removeAt(index);
  }

  // Method to save optional goals (validation example)
  void saveOptionalGoals(GlobalKey<FormState> formKey) async {
    if (formKey.currentState?.validate() ?? false) {
      print('------------------1-------------------------');
      final box = await Hive.openBox<Goal>('goals');
      print('-----------------------2--------------------');
      List<Medicine> medicinesData = medicines.map((medicine) {
        print('--------------------------3-----------------');
        return Medicine(
          name: medicine['name'],
          frequencyType: medicine['frequency'],
          dosage: medicine['dosageController'].text,
          quantity: int.parse(medicine['quantityController'].text),
          selectedTimes: List<String>.from(medicine['selectedTimes']),
        );
      }).toList();
      print('--------------------------4-----------------');
      Goal goal = Goal(
        goalId: 1,
        goalType: "Optional",
        date: DateTime.now(),
        MealValue: Meal(
          morning: enableBreakfast.value,
          afternoon: enableLunch.value,
          night: enableDinner.value,
        ),
        medicines: medicinesData,
        skipped: false,
      );
      print('----------------------5---------------------');

      await box.put(goal.goalId, goal);
      Get.offAll(BottumNavBar());
      print('-----------------------6--------------------');
       print('Success , Goals saved successfully');
    } else {
      Get.snackbar('Error', 'Please fill out all fields');
    }
  }

  // Method to skip goals
  void skipGoals() {
    Get.snackbar('Info', 'Skipping optional goals');
  }
}
