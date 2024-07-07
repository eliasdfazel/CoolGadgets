import 'package:cool_gadgets/resources/private/Privates.dart';

class Endpoints {

  String brandsCollection() {

    return '/CoolGadgets/Products/Brands';
  }

  String searchEndpoint(String searchQuery) {

    return 'https://GeeksEmpire.co/search/?searchQuery=$searchQuery';
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