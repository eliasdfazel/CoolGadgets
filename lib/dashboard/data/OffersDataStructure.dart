import 'package:cloud_firestore/cloud_firestore.dart';

class OffersDataStructure {

  static const String offerId = "offerId";
  static const String offerLink = "offerLink";
  static const String offerImage = "offerImage";
  static const String offerDescription = "offerDescription";
  static const String offerIndex = "offerIndex";

  Map<String, dynamic> documentData = <String, dynamic>{};

  OffersDataStructure(DocumentSnapshot documentSnapshot) {

    documentData = documentSnapshot.data() as Map<String, dynamic>;

  }

  String offerIdValue() {

    return documentData[OffersDataStructure.offerId].toString();
  }

  String offerLinkValue() {

    return documentData[OffersDataStructure.offerLink].toString();
  }

  String offerImageValue() {

    return documentData[OffersDataStructure.offerImage].toString();
  }

  String offerDescriptionValue() {

    return documentData[OffersDataStructure.offerDescription].toString();
  }

}