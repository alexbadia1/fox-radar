import 'package:communitytabs/components/slidingUpNavigationBar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SlidingUpNavigationBar(namedRoute: '/home'),
        ),
    );
  }
} //class
