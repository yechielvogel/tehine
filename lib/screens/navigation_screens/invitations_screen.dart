import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Should move this to a provider file. 
final selectedInvitationScreenChipIndexProvider =
    StateProvider<int>((ref) => 0);

class InvitationsScreen extends ConsumerStatefulWidget {
  bool showSearchBar = true;
  InvitationsScreen({
    required this.showSearchBar,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomeState();
}

class _HomeState extends ConsumerState<InvitationsScreen> {
  // bool showSearchBar = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedChipIndex =
        ref.watch(selectedInvitationScreenChipIndexProvider);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Column(
            children: [
              widget.showSearchBar
                  ? TextFormField(
                      cursorColor: Colors.grey[850],
                             decoration: InputDecoration(
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3)),
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.grey[850]),
                              fillColor: Colors.grey[350] ?? Colors.grey,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3.0)),
                              errorStyle: TextStyle(
                                color: Colors.grey[850],
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey[350] ?? Colors.grey,
                                    width: 3.0),
                              ),
                            ),
                      style: TextStyle(color: Colors.grey[850]),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int index = 0; index < chipLabels.length; index++)
                        ChoiceChip(
                          selectedColor: Color(0xFFE6D3B3),
                          backgroundColor: selectedChipIndex == index
                              ? Color(0xFFE6D3B3)
                              : Color(0xFFF5F5F5),
                          label: Text(
                            chipLabels[index],
                            style: TextStyle(
                                color: selectedChipIndex == index
                                    ? Colors.grey[850]
                                    : Colors.grey[850]),
                          ),
                          selected: selectedChipIndex == index,
                          onSelected: (selected) {
                            if (selected) {
                              ref
                                  .read(
                                      selectedInvitationScreenChipIndexProvider
                                          .state)
                                  .state = index;
                            }
                          },
                        ),
                      SizedBox(width: 7),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  final List<String> chipLabels = [
    'Today',
    'All',
    'Going',
    'Expired',
    'Upcoming',
    'Not Going'
  ];
}
