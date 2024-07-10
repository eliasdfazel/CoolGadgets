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

    return inputDynamicJson['magazineTitle'];
  }

  String magazineLink() {

    return inputDynamicJson['magazineLink'];
  }

  String magazineImage() {

    return inputDynamicJson['magazineImage'];
  }

}