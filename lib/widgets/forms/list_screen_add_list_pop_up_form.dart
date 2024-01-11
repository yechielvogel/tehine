import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../providers/list_provider.dart';
import '../../providers/load_data_from_device_on_start.dart';

class ListScreenAddListPopUpForm extends ConsumerStatefulWidget {
  const ListScreenAddListPopUpForm({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _ListScreenAddListPopUpFormState();
}

class _ListScreenAddListPopUpFormState
    extends ConsumerState<ListScreenAddListPopUpForm> {
  String? selectedName;

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
      content: Container(
        height: 135,
        child: Column(
          children: [
            TextFormField(
              cursorColor: Colors.grey[850],
              decoration: InputDecoration(
                hintText: 'Name',
                hintStyle: TextStyle(color: Colors.grey[850]),
                fillColor: Color(0xFFF5F5F5),
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.grey[850] ?? Colors.grey, width: 3.0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.grey[850] ?? Colors.grey, width: 3.0)),
              ),
              style: TextStyle(color: Colors.grey[850]),
              validator: (val) => val!.isEmpty ? 'Enter Name' : null,
              onChanged: (val) {
                newListName = val;
              },
            ),
            SizedBox(height: 10),
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
              final currentList = [
                ...await ref.read(listFromSharedPrefranceProvider.future)
              ];
              currentList.add(newListName!);

              ref.read(listProvider.notifier).state = [...currentList];
              saveListToSP(currentList);
              await ref.read(listProvider);
              await ref.refresh(listFromSharedPrefranceProvider);
              Navigator.pop(context);
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
