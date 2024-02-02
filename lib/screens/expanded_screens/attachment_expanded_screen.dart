import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/attachment_full_page_view.dart';

class FullImageScreen extends ConsumerStatefulWidget {
  FullImageScreen(
    this.attachment,
    // this.allUrl,
    {
    Key? key,
  }) : super(key: key);

  // List<String> allUrl;
  String? attachment;

  @override
  ConsumerState createState() => _FullImageScreenState();
}

class _FullImageScreenState extends ConsumerState<FullImageScreen>
    with TickerProviderStateMixin {
  // late List<String> allImages;
  // int _currentPageIndex = 0;

  // final PageController _pageController = PageController();
  // late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (widget.profileImagesUrl.isNotEmpty && widget.allUrl.isNotEmpty) {
    //   allImages = [...widget.profileImagesUrl, ...widget.allUrl];
    // } else {
    //   allImages = widget.profileImagesUrl;
    // }

    // print('Number of pics: ${allImages.length}');

    // _tabController = TabController(length: allImages.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0x44000000),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              // controller: _pageController,
              onPageChanged: (index) {
                // setState(() {
                //   _currentPageIndex = index;
                //   _tabController.index = index;
                // });
              },
              children: [AttachmentFullPageView(widget.attachment)],
            ),
          ),
          SizedBox(height: 10),
          // TabPageSelector(
          //   color: Colors.grey,
          //   selectedColor: primaryColor,
          //   controller: _tabController,
          // ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
