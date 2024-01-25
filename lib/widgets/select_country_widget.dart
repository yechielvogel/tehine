import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/providers/date_providers.dart';
import '../models/country_model.dart';
import '../providers/create_event_providers.dart';
import '../providers/general_providers.dart';

class SelectCountryWidget extends ConsumerStatefulWidget {
  SelectCountryWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SelectCountryWidget> createState() =>
      _SelectCountryWidgetState();
}

List<CountryModel> _countrySubList = [];

List<CountryModel> _countryList = [];
TextEditingController country = TextEditingController();
TextEditingController state = TextEditingController();
TextEditingController city = TextEditingController();

class _SelectCountryWidgetState extends ConsumerState<SelectCountryWidget> {
  @override
  void initState() {
    super.initState();
    _getCountry();
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
            child: Text('Country',
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
                _filterCountries(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(    
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              itemCount: _countrySubList.length,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    setState(() {
                      country.text = _countrySubList[index].name;
                      _countrySubList = _countryList;
                    });
                    Navigator.pop(context);
                    ref.read(selectedCountryProvider.notifier).state =
                        country.text;
                    print('Selected Country: ${country.text}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20.0, left: 10.0, right: 10.0),
                    child: Text(_countrySubList[index].name,
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
                _countrySubList = _countryList;
                print('Selected Country: ${country.text}');
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

  Future<void> _getCountry() async {
    _countryList.clear();
    var jsonString = await rootBundle.loadString('lib/assets/country.json');
    List<dynamic> body = json.decode(jsonString);
    setState(() {
      _countryList =
          body.map((dynamic item) => CountryModel.fromJson(item)).toList();
      _countrySubList = _countryList;
    });
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _countrySubList = _countryList
            .where((country) =>
                country.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        _countrySubList = _countryList;
      }
    });
  }
}
