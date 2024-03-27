import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tehine/shared/style.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: seaSault,
      child: Center(
        child: SpinKitRing(
          color: steelBlue,
          size: 50.0,
        ),
      ),
    );
  }
}

class LoadingTransparent extends StatelessWidget {
  const LoadingTransparent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: seaSault,
      child: Center(
        child: SpinKitRing(
          color: steelBlue,
          size: 50.0,
        ),
      ),
    );
  }
}

showLoader(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: Loading()));
}
