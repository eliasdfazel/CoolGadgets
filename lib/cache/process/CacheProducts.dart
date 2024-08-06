import 'package:cool_gadgets/cache/io/CacheIO.dart';

class CacheProducts extends CacheIO {

  void store(contentId, productsJson) async {

    storeContent(contentId, (productsJson));

  }

  Future<String> retrieve(String contentId) async {

    String storedProductsJson = await retrieveContent(contentId) ?? '';

    return storedProductsJson;
  }

}