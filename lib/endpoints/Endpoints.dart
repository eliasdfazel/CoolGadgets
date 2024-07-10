import 'package:cool_gadgets/resources/private/Privates.dart';

class Endpoints {

  String brandsCollection() {

    return '/CoolGadgets/Products/Brands';
  }

  String categoriesCollection() {

    return '/CoolGadgets/Products/Categories';
  }

  String offersCollection() {

    return '/CoolGadgets/Exclusive/Offers';
  }

  String searchEndpoint(String searchQuery) {

    return 'https://GeeksEmpire.co/search/?searchQuery=$searchQuery';
  }

  String keywordEndpoint(String keywordQuery) {

    return 'https://geeksempire.co/storefront/?yith_wcan=1&product_cat=$keywordQuery';
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

  String magazineByTag({String tagsCsv = "5884,7136"}) {

    return "https://geeksempire.co/wp-json/wp/v2/posts?tags=$tagsCsv&per_page=100&page=1";
  }

  String mediaUrl(String mediaId) {

    return "https://geeksempire.co/wp-json/wp/v2/media/$mediaId";
  }

}