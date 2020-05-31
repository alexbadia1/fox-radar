import 'package:flutter/material.dart';
import '../components/slidingUpNavigationBar.dart';

class CategoryScreen extends StatefulWidget {
  final String namedRoute;
  CategoryScreen({@required this.namedRoute});
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SlidingUpNavigationBar(namedRoute: this.widget.namedRoute)
      ),
    );
  }
}

