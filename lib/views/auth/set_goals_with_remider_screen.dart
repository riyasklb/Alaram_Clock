import 'package:alaram/tools/controllers/goal_notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alaram/tools/constans/color.dart';

class OptionalGoalSettingScreen extends StatelessWidget {
  final OptionalGoalSettingController controller =
      Get.put(OptionalGoalSettingController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set Optional Goals',
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: kwhite,
          ),
        ),
        backgroundColor: kblue,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Skip',
              style: TextStyle(color: kwhite, fontSize: 16.sp),
            ),
          ),
        ],
      ),
      body: GetBuilder<OptionalGoalSettingController>(
        builder: (_) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Medicine Intake'),
                    Obx(() => ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.medicines.length,
                          itemBuilder: (context, index) {
                            return _buildMedicineInput(index);
                          },
                        )),
                    TextButton(
                      onPressed: controller.addMedicine,
                      child: Text('Add Another Medicine'),
                    ),
                    _buildToggleSwitch(
                        'Enable Breakfast', controller.enableBreakfast),
                    _buildToggleSwitch('Enable Lunch', controller.enableLunch),
                    _buildToggleSwitch(
                        'Enable Dinner', controller.enableDinner),
                    ElevatedButton(
                      onPressed: () => controller.saveOptionalGoals(_formKey),
                      child:
                          Text('Save Goals', style: TextStyle(fontSize: 18.sp)),
                      style: ElevatedButton.styleFrom(backgroundColor: kblue),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMedicineInput(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownField(
          label: 'Medicine Name',
          value: controller.medicines[index]['name'],
          items: <String>['Paracetamol', 'Ibuprofen', 'Aspirin', 'Amoxicillin'],
          onChanged: (String? val) => controller.updateMedicineName(index, val),
        ),
        _buildIntTextField(
          controller: controller.medicines[index]['quantityController'],
          labelText: 'Quantity (e.g., 10 tablets)',
          validator: (value) => value!.isEmpty ? 'Enter quantity' : null,
        ),
        _buildMultiSelectChip(
          label: 'Select Medicine Times',
          items: <String>['Morning', 'Afternoon', 'Evening', 'Night'],
          selectedItems: controller.medicines[index]['selectedTimes'],
          onSelectionChanged: (List<String> selectedList) {
            controller.updateSelectedTimes(index, selectedList);
          },
        ),
        _buildDropdownField(
          label: 'Frequency',
          value: controller.medicines[index]['frequency'],
          items: ['Daily', 'Every Other Day', 'Weekly'],
          onChanged: (val) => controller.updateFrequency(index, val),
        ),
        _buildTextField(
          controller: controller.medicines[index]['dosageController'],
          labelText: 'Dosage (e.g., 1 tablet)',
          validator: (value) => value!.isEmpty ? 'Enter dosage amount' : null,
        ),
        if (index > 0)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => controller.removeMedicine(index),
              child: Text('Remove Medicine'),
            ),
          ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildIntTextField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        validator: validator,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildMultiSelectChip({
    required String label,
    required List<String> items,
    required List<String> selectedItems,
    required Function(List<String>) onSelectionChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16.sp)),
        Wrap(
          spacing: 8.0,
          children: items.map((item) {
            return FilterChip(
              label: Text(item),
              selected: selectedItems.contains(item),
              onSelected: (selected) {
                selected ? selectedItems.add(item) : selectedItems.remove(item);
                onSelectionChanged(selectedItems);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildToggleSwitch(String title, RxBool value) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16.sp)),
            Switch(
              value: value.value,
              onChanged: (val) => value.value = val,
            ),
          ],
        ));
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Text(
        title,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
