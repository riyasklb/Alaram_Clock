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
        // actions: [
        //   TextButton(
        //     onPressed: () {},
        //     child: Text(
        //       'Skip',
        //       style: TextStyle(color: kwhite, fontSize: 16.sp),
        //     ),
        //   ),
        // ],
      ),
      body: GetBuilder<OptionalGoalSettingController>(
        builder: (_) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Medicine Intake'),
                    Obx(() => ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.medicines.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 3,
                              margin: EdgeInsets.only(bottom: 16.h),
                              child: Padding(
                                padding: EdgeInsets.all(12.w),
                                child: _buildMedicineInput(index),
                              ),
                            );
                          },
                        )),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: controller.addMedicine,
                        icon: Icon(Icons.add, color: kblue),
                        label: Text(
                          'Add Another Medicine',
                          style: TextStyle(color: kblue, fontSize: 16.sp),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          side: BorderSide(color: kblue),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Divider(),
                    _buildSectionHeader('Meals Tracking'),
                    _buildToggleSwitch(
                        'Enable Breakfast', controller.enableBreakfast),
                    _buildToggleSwitch('Enable Lunch', controller.enableLunch),
                    _buildToggleSwitch(
                        'Enable Dinner', controller.enableDinner),
                    SizedBox(height: 30.h),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => controller.saveOptionalGoals(_formKey),
                        child: Text('Save Goals',
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold, color: kwhite)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kblue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.w, vertical: 12.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r)),
                        ),
                      ),
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
        icon: Icons.medical_services_outlined,
        value: controller.medicines[index]['name'],
        items: <String>['Paracetamol', 'Ibuprofen', 'Aspirin', 'Amoxicillin'],
        onChanged: (String? val) => controller.updateMedicineName(index, val),
      ),
      _buildIntTextField(
        controller: controller.medicines[index]['quantityController'],
        labelText: 'Quantity (e.g., 10 tablets)',
        icon: Icons.format_list_numbered,
        validator: (value) => value!.isEmpty ? 'Enter quantity' : null,
      ),
      _buildMultiSelectChip(
        label: 'Select Medicine Times',
        items: <String>['Morning', 'Afternoon', 'Evening', 'Night'],
        selectedItems: controller.medicines[index]['selectedTimes'],
        onSelectionChanged: (List<String> selectedList) {
          controller.updateSelectedTimes(index, selectedList);
        },
      ),kheight10,
      _buildDropdownField(
        label: 'Frequency',
        icon: Icons.repeat,
        value: controller.medicines[index]['frequency'],
        items: ['Daily', 'Every Other Day', 'Weekly'],
        onChanged: (val) => controller.updateFrequency(index, val),
      ),
      _buildTextField(
        controller: controller.medicines[index]['dosageController'],
        labelText: 'Dosage (e.g., 1 tablet)',
        icon: Icons.local_pharmacy,
        validator: (value) => value!.isEmpty ? 'Enter dosage amount' : null,
      ),
      if (index > 0)
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => controller.removeMedicine(index),
            icon: Icon(Icons.delete, color: Colors.red),
            label: Text('Remove Medicine', style: TextStyle(color: Colors.red)),
          ),
        ),
      SizedBox(height: 20.h),
    ],
  );
}
Widget _buildIntTextField({
  required TextEditingController controller,
  required String labelText,
  String? Function(String?)? validator, required IconData icon,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 16.h),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.number, // Ensures the numeric keyboard appears
      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Allows only integers
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(Icons.format_list_numbered, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
      ),
      validator: validator,
    ),
  );
}

Widget _buildTextField({
  required TextEditingController controller,
  required String labelText,
  required IconData icon,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 16.h),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: Colors.grey),
                onPressed: () => controller.clear(),
              )
            : null,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
      ),
      validator: validator,
    ),
  );
}

Widget _buildDropdownField({
  required String label,
  required IconData icon,
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
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
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
            selectedColor: Colors.blueAccent.withOpacity(0.2),
            showCheckmark: true,
            checkmarkColor: Colors.blueAccent,
          );
        }).toList(),
      ),
    ],
  );
}


  Widget _buildToggleSwitch(String title, RxBool value) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: GestureDetector(
          onTap: () {
            value.value = !value.value; // Toggle the switch on tap
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: value.value ? Colors.blue[50] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8.0,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: value.value ? Colors.blue[800] : Colors.black,
                    )),
                Switch(
                  value: value.value,
                  onChanged: (bool newValue) {
                    value.value = newValue;
                  },
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: kblue,
        ),
      ),
    );
  }
}
