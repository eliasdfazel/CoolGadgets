import 'dart:convert';

import 'package:cool_gadgets/cache/io/CacheIO.dart';

class Cacheproducts extends CacheIO {

  void store(contentId, productsJson) {

    storeContent(contentId, jsonEncode(productsJson));

  }

  Future<dynamic> retrieve(String contentId) async {

    String storedProductsJson = await retrieveContent(contentId) ?? '{}';

    return jsonDecode(storedProductsJson);
  }

}