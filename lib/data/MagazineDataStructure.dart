import 'dart:convert';

import 'package:cool_gadgets/endpoints/Endpoints.dart';

class MagazineDataStructure extends Endpoints {

  dynamic inputDynamicJson;

  MagazineDataStructure(dynamic dynamicJson) {

    inputDynamicJson = dynamicJson;

  }

  String magazineId() {

    return inputDynamicJson['id'].toString();
  }

  String magazineTitle() {

    return jsonDecode(inputDynamicJson['magazineTitle']);
  }

  String magazineLink() {

    return inputDynamicJson['magazineLink'];
  }

  Future<String> magazineImage() async {

    return jsonDecode(inputDynamicJson['magazineImage']);
  }

}