class ProductDataStructure {

  dynamic inputDynamicJson;

  ProductDataStructure(dynamic dynamicJson) {

    inputDynamicJson = dynamicJson;

  }

  String productId() {

    return inputDynamicJson['id'].toString();
  }

  String productName() {

    return inputDynamicJson['name'];
  }

  String productLink() {

    return inputDynamicJson['permalink'];
  }

  String productExternalLink() {

    return inputDynamicJson['external_url'];
  }

  String productImage() {

    return List.from(inputDynamicJson['images']).first['src'];
  }

  String productKeyword() {

    return List.from(inputDynamicJson['categories']).last['name'];
  }

  String productBrand() {

    String productBrand = '';

    for (var element in List.from(inputDynamicJson['attributes'])) {

      if (element['name'] == 'Brands') {

        productBrand = List.from(element['options']).first.toString();

        break;
      }

    }

    return productBrand;
  }

  String productHashtags() {

    String extraWord = 'with,and,or,a,an';

    String hashtagKeyword = '#GeeksEmpire';

    productName().split('-').first.split(' ').forEach((element) {

      if (!extraWord.contains(element)) {

        hashtagKeyword += ' #$element';

      }

    });

    return hashtagKeyword;
  }

}