import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppActivityIndicator extends StatelessWidget {

  const AppActivityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.dotsTriangle(
      color: kPrimaryColor,
      size: 50,
    );
  }
}

class AppLoadMoreIndicator extends StatelessWidget {

  const AppLoadMoreIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: kSecondaryColor,
        size: 50,
      ),
    );
  }
}