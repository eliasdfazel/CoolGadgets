import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesDataStructure {

  static const String categoryId = "categoryId";
  static const String categoryName = "categoryName";
  static const String categoryImage = "categoryImage";
  static const String categoryDescription = "categoryDescription";
  static const String categoryColor = "categoryColor";
  static const String categoryIndex = "categoryIndex";

  Map<String, dynamic> documentData = <String, dynamic>{};

  CategoriesDataStructure(DocumentSnapshot documentSnapshot) {

    documentData = documentSnapshot.data() as Map<String, dynamic>;

  }

  String categoryIdValue() {

    return documentData[CategoriesDataStructure.categoryId].toString();
  }

  String categoryNameValue() {

    return documentData[CategoriesDataStructure.categoryName].toString();
  }

  String categoryImageValue() {

    return documentData[CategoriesDataStructure.categoryImage].toString();
  }

  String categoryDescriptionValue() {

    return documentData[CategoriesDataStructure.categoryDescription].toString();
  }

  Color categoryColorValue() {

    final colorRGB = documentData[CategoriesDataStructure.categoryColor].toString().split(',');

    return Color.fromARGB(int.parse(colorRGB[3]), int.parse(colorRGB[0]), int.parse(colorRGB[1]), int.parse(colorRGB[2]));
  }

}