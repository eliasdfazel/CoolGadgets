import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesDataStructure {

  static const String categoryId = "categoryId";
  static const String categoryName = "categoryName";
  static const String categoryImage = "categoryImage";
  static const String categoryDescription = "categoryDescription";
  static const String categoryColor = "categoryColor";

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

  String categoryColorValue() {

    return documentData[CategoriesDataStructure.categoryColor];
  }

}