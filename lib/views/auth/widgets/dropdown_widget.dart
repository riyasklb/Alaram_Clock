import 'package:alaram/tools/controllers/goal_notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetxDropdownField extends StatelessWidget {
  final String label;
  final IconData icon;
  final NotificationController controller;

  const GetxDropdownField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(text: controller.selectedValue.value);

    return Obx(() {
      textController.text = controller.selectedValue.value;
      textController.selection = TextSelection.collapsed(offset: textController.text.length);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: textController,
            onChanged: controller.filterItems,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: Colors.blueAccent),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 5),
          ...controller.filteredItems.map((item) => ListTile(
                title: Text(item),
                onTap: () {
                  controller.selectItem(item);
                  FocusScope.of(context).unfocus();
                },
              )),
        ],
      );
    });
  }
}
