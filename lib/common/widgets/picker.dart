import 'package:flutter/material.dart';
import 'package:task_planner/common/extensions/date_extension.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

enum PickerType { date, time }

class Picker extends StatefulWidget {
  final String label;
  final Icon? icon;
  final TextEditingController controller;
  final PickerType type;

  const Picker.showDate({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
  }) : type = PickerType.date;

  const Picker.showTime({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
  }) : type = PickerType.time;

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.black87),
      controller: widget.controller,
      focusNode: AlwaysDisabledFocusNode(),
      onTap: () {
        if (widget.type == PickerType.date) {
          _selectDate(context);
        } else if (widget.type == PickerType.time) {
          _selectTime(context);
        }
      },
      decoration: InputDecoration(
          suffixIcon: widget.icon,
          labelText: widget.label,
          labelStyle: const TextStyle(color: Colors.black45),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey))),
    );
  }

  void _selectDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      _selectedDate = newDate;
      widget.controller
        ..text = _selectedDate!.toDateString()
        ..selection = TextSelection.fromPosition(
          TextPosition(
            offset: widget.controller.text.length,
            affinity: TextAffinity.upstream,
          ),
        );
    }
  }

  void _selectTime(BuildContext context) async {
    final newDate = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (newDate != null) {
      _selectedTime = newDate;
      widget.controller
        ..text = _selectedTime!.format(context)
        ..selection = TextSelection.fromPosition(
          TextPosition(
            offset: widget.controller.text.length,
            affinity: TextAffinity.upstream,
          ),
        );
    }
  }
}
