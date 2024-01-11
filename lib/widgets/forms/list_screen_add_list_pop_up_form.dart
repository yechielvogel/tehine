import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/list_provider.dart';
import '../../providers/load_data_from_device_on_start.dart';

class ListScreenAddListPopUpForm extends ConsumerStatefulWidget {
    final void Function(String) onSave;
  const ListScreenAddListPopUpForm({
    required this.onSave,
    Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _ListScreenAddListPopUpFormState();
}

class _ListScreenAddListPopUpFormState
    extends ConsumerState<ListScreenAddListPopUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedName;

  String? nameValidator(String? val) {
    if (val!.isEmpty) {
      return 'Enter Name';
    } else if (val.contains(',')) {
      return 'Name should not contain a comma';
    } else {
      return null; // Validation passed
    }
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String newListName = '';

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Color(0xFFF5F5F5),
      title: Center(
        child: Text(
          'Create List',
          style: TextStyle(color: Colors.grey[850]),
        ),
      ),
      content: Form(
        key: _formKey,
        child: Container(
          height: 170,
          child: Column(
            children: [
              TextFormField(
                cursorColor: Colors.grey[850],
                decoration: InputDecoration(
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[850] ?? Colors.grey, width: 3.0)),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                  ),
                  hintText: 'Name',
                  hintStyle: TextStyle(color: Colors.grey[850]),
                  fillColor: Color(0xFFF5F5F5),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                  ),
                  errorStyle: TextStyle(
                    color: Colors.grey[850],
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                  ),
                ),
                style: TextStyle(color: Colors.grey[850]),
                validator: nameValidator,
                onChanged: (val) {
                  newListName = val;
                },
              ),
              SizedBox(height: 25),
              DropdownButtonFormField<String>(
                value: selectedName,
                onChanged: (value) {
                  setState(() {
                    selectedName = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Select Category',
                  hintStyle: TextStyle(color: Colors.grey[850]),
                  fillColor: Color(0xFFF5F5F5),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                  ),
                ),
                style: TextStyle(color: Colors.grey[850]),
                items: [
                  DropdownMenuItem<String>(
                    value: 'Option 1',
                    child: Text('Wedding'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Option 2',
                    child: Text('Bar Mitzvah'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Option 2',
                    child: Text('Engagement'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Option 2',
                    child: Text("Bris Milah"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE6D3B3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Form is valid, proceed with saving
                final currentList = [
                  ...await ref.read(listFromSharedPrefranceProvider.future),
                ];
                currentList.add(newListName!);

                ref.read(listProvider.notifier).state = [...currentList];
                saveListToSP(currentList);
                 widget.onSave(newListName!);
                await ref.read(listProvider);
                await ref.refresh(listFromSharedPrefranceProvider);
                Navigator.pop(context);
              }
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.grey[850]),
            ),
          ),
        ),
      ],
    );
  }
}
