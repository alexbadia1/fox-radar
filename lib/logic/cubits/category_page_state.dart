import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CategoryPageState extends Equatable{}

class CategoryPageInitial extends CategoryPageState {
  @override
  List<Object> get props => [];
}// CategoryCategoryInitial

class CategoryPageCategory extends CategoryPageState {
  final String category;
  CategoryPageCategory({@required this.category});

  @override
  List<Object> get props => [category];
}// CategoryPageCategory
