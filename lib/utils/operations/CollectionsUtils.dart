import 'package:cool_gadgets/data/ProductDataStructure.dart';

bool keywordsContains(List<ProductDataStructure> inputCollection, String inputKeyword) {

  bool containResult = false;

  for (var element in inputCollection) {

    if (element.productKeyword() == inputKeyword) {

      containResult = true;

      break;

    }

  }

  return containResult;
}