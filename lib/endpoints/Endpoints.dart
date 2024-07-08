import 'package:cool_gadgets/resources/private/Privates.dart';

class Endpoints {

  String brandsCollection() {

    return '/CoolGadgets/Products/Brands';
  }

  String offersCollection() {

    return '/CoolGadgets/Exclusive/Offers';
  }

  String searchEndpoint(String searchQuery) {

    return 'https://GeeksEmpire.co/search/?searchQuery=$searchQuery';
  }

  String brandsEndpoint(String brandName) {

    return 'https://GeeksEmpire.co/products/editors-choices/brands/$brandName';
  }

  String productsByCategory(String categoryId, String numberOfPage) {

    return 'https://geeksempire.co/wp-json/wc/v3/products?consumer_key=${Privates.woocommerceKey}&consumer_secret=${Privates.woocommerceSecret}'
        '&page=$numberOfPage'
        '&per_page=100'
        '&category=$categoryId'
        '&orderby=date'
        '&order=asc';
  }

}