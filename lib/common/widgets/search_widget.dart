import 'package:flutter/material.dart';
import 'package:task_planner/common/enums/task_status.dart';
import 'package:task_planner/common/extensions/date_extension.dart';
import 'package:task_planner/common/theme/colors/light_colors.dart';

class SearchWidget extends StatefulWidget {
  final void Function(String, TaskStatus? status, DateTime? date)? onSearch;

  const SearchWidget({super.key, required this.onSearch});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _searchEC = TextEditingController();
  TaskStatus? _selectedStatus;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchEC,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: LightColors.kDarkBlue),
                ),
                filled: true,
                fillColor: LightColors.kLightYellow,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () => _showFilterOptions(context),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: LightColors.kLightYellow2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter By',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 22.0,
                      color: LightColors.kDarkBlue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Row(
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(color: LightColors.kDarkBlue),
                        ),
                        if (_selectedDate != null)
                          Chip(
                            label: Text(_selectedDate!.toDateString()),
                            backgroundColor: LightColors.kLightYellow,
                            deleteIcon: const Icon(Icons.close),
                            onDeleted: () =>
                                setModalState(() => _selectedDate = null),
                          ),
                      ],
                    ),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setModalState(() => _selectedDate = pickedDate);
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: Row(
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(color: LightColors.kDarkBlue),
                        ),
                        const SizedBox(width: 16.0),
                        if (_selectedStatus != null)
                          Chip(
                            label: Row(
                              children: [
                                Icon(
                                  _selectedStatus!.icon,
                                  color: _selectedStatus!.color,
                                ),
                                const SizedBox(width: 8.0),
                                Text(_selectedStatus!.text),
                              ],
                            ),
                            backgroundColor: LightColors.kLightYellow,
                            deleteIcon: const Icon(Icons.close),
                            onDeleted: () =>
                                setModalState(() => _selectedStatus = null),
                          ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Select Status'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: TaskStatus.values.map((status) {
                                return RadioListTile<TaskStatus>(
                                  title: Row(
                                    children: [
                                      Icon(status.icon, color: status.color),
                                      const SizedBox(width: 8.0),
                                      Text(status.text),
                                    ],
                                  ),
                                  value: status,
                                  groupValue: _selectedStatus,
                                  onChanged: (value) {
                                    setModalState(
                                        () => _selectedStatus = value);
                                    Navigator.of(context).pop();
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LightColors.kGreen,
                    ),
                    onPressed: () {
                      widget.onSearch?.call(
                        _searchEC.text,
                        _selectedStatus,
                        _selectedDate,
                      );

                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
