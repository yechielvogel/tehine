import 'package:flutter/material.dart';

class AttachmentFullPageView extends StatelessWidget {

  AttachmentFullPageView(this.attachment, {Key? key}) : super(key: key);
  String? attachment;

  @override
  Widget build(BuildContext context) {

    return InteractiveViewer(
      child: Image.network(
        attachment as String,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        loadingBuilder: (BuildContext context, Widget child,
        ImageChunkEvent? loadingProgress)
    {
      if (loadingProgress == null) return child;
      return Center(
        // child: CircularProgressIndicator(
        //   value: loadingProgress.expectedTotalBytes != null
        //       ? loadingProgress.cumulativeBytesLoaded /
        //       loadingProgress.expectedTotalBytes!
        //       : null,
        // ),
        // child: MyLoaderWidget(),
      );
    }
    ));

  }
}