import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/providers/date_providers.dart';
import '../models/state_model.dart';
import '../providers/create_event_providers.dart';
import '../providers/general_providers.dart';

class SelectStateWidget extends ConsumerStatefulWidget {
  SelectStateWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SelectStateWidget> createState() => _SelectStateWidgetState();
}

List<StateModel> _stateSubList = [];

List<StateModel> _stateList = [];
TextEditingController state = TextEditingController();
TextEditingController city = TextEditingController();

class _SelectStateWidgetState extends ConsumerState<SelectStateWidget> {
  @override
  void initState() {
    super.initState();
    _getState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        color: Color(0xFFF5F5F5),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('State',
                style: TextStyle(
                    color: Colors.grey[850],
                    fontSize: 17,
                    fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 12.0, bottom: 10),
            child: TextFormField(
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
                hintText: 'Search',
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
              onChanged: (value) {
                _filterStates(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              itemCount: _stateSubList.length,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    setState(() {
                      state.text = _stateSubList[index].name;
                      _stateSubList = _stateList;
                    });
                    Navigator.pop(context);
                    ref.read(selectedStateProvider.notifier).state = state.text;
                    print('State State: ${state.text}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20.0, left: 10.0, right: 10.0),
                    child: Text(_stateSubList[index].name,
                        style:
                            TextStyle(color: Colors.grey[850], fontSize: 16.0)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE6D3B3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () async {
                _stateSubList = _stateList;
                print('Selected State: ${state.text}');
                Navigator.pop(context);
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.grey[850]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getState() async {
    _stateList.clear();
    var jsonString = await rootBundle.loadString('lib/assets/state.json');
    List<dynamic> body = json.decode(jsonString);
    setState(() {
      _stateList =
          body.map((dynamic item) => StateModel.fromJson(item)).toList();
      _stateSubList = _stateList;
    });
  }

  void _filterStates(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _stateSubList = _stateList
            .where((state) =>
                state.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        _stateSubList = _stateList;
      }
    });
  }
}
