import 'package:cloud_firestore/cloud_firestore.dart';

class BrandsDataStructure {

  static const String brandId = "categoryId";
  static const String brandName = "categoryName";
  static const String brandImage = "categoryImage";
  static const String brandDescription = "categoryDescription";
  static const String categoryIndex = "categoryIndex";

  Map<String, dynamic> documentData = <String, dynamic>{};

  BrandsDataStructure(DocumentSnapshot documentSnapshot) {

    documentData = documentSnapshot.data() as Map<String, dynamic>;

  }

  String brandIdValue() {

    return documentData[BrandsDataStructure.brandId].toString();
  }

  String brandNameValue() {

    return documentData[BrandsDataStructure.brandName].toString();
  }

  String brandImageValue() {

    return documentData[BrandsDataStructure.brandImage].toString();
  }

  String brandDescriptionValue() {

    return documentData[BrandsDataStructure.brandDescription].toString();
  }

}