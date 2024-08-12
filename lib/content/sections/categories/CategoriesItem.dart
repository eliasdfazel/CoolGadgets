import 'dart:convert';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cool_gadgets/cache/process/CacheProducts.dart';
import 'package:cool_gadgets/cache/process/CacheTimes.dart';
import 'package:cool_gadgets/content/sections/categories/Keywords.dart';
import 'package:cool_gadgets/data/Analytics.dart';
import 'package:cool_gadgets/data/CategoriesDataStructure.dart';
import 'package:cool_gadgets/data/ProductDataStructure.dart';
import 'package:cool_gadgets/endpoints/Endpoints.dart';
import 'package:cool_gadgets/resources/private/Privates.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:cool_gadgets/utils/calculations/colors.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryItem extends StatefulWidget {

  CategoriesDataStructure categoriesDataStructure;

  CategoryItem({Key? key, required this.categoriesDataStructure}) : super(key: key);

  @override
  State<CategoryItem> createState() => CategoryItemState();
}
class CategoryItemState extends State<CategoryItem> {

  CacheTime cacheTime = CacheTime();

  CacheProducts cacheProducts = CacheProducts();

  Endpoints endpoints = Endpoints();

  Widget categoryProducts = ListView();

  ScrollController scrollController = ScrollController();

  Widget keywordsPlaceholder = Container();

  Color textColor = ColorsResources.premiumLight;

  bool aInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {

    SystemNavigator.pop();

    return true;
  }

  @override
  void initState() {
    super.initState();
    debugPrint(widget.categoriesDataStructure.categoryNameValue());

    BackButtonInterceptor.add(aInterceptor);

    retrieveProducts();

    textColor = calculateTextColor(widget.categoriesDataStructure.categoryColorValue());

  }

  @override
  void dispose() {
    super.dispose();

    BackButtonInterceptor.remove(aInterceptor);

  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 357,
      width: 357,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Container(
          decoration: BoxDecoration(
            color: widget.categoriesDataStructure.categoryColorValue().withOpacity(0.377)
          ),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: Container(
                    height: 111,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: widget.categoriesDataStructure.categoryColorValue().withOpacity(0.73)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(top: 13, left: 19, right: 19),
                          child: InkWell(
                            onTap: () async {

                              launchUrl(Uri.parse(endpoints.keywordEndpoint(widget.categoriesDataStructure.categoryNameValue().replaceAll(" ", "-"))), mode: LaunchMode.externalApplication);

                              FirebaseAnalytics.instance.logEvent(
                                  name: Analytics.keyword,
                                  parameters: {
                                    Analytics.keywordTitle: widget.categoriesDataStructure.categoryNameValue().replaceAll("Cool Gadgets ", ""),
                                  }
                              );

                            },
                            child: SizedBox(
                              width: double.maxFinite,
                              child: Text(
                                  widget.categoriesDataStructure.categoryNameValue().replaceAll("Cool Gadgets ", ""),
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 23,
                                      color: textColor
                                  )
                              )
                            )
                          )
                        ),

                        Padding(
                            padding: const EdgeInsets.only(top: 13, left: 19, right: 19),
                            child: SizedBox(
                              height: 37,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: keywordsPlaceholder
                              )
                            )
                        ),

                      ]
                    )
                  )
                ),

                Expanded(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(19),
                      child: categoryProducts
                  )
                )

              ]
            )
          )
        )
      )
    );
  }

  void retrieveProducts() async {

    cacheProducts.retrieve(widget.categoriesDataStructure.categoryIdValue()).then((value) async {

      if (value.isNotEmpty) {
        debugPrint('Category ${widget.categoriesDataStructure.categoryIdValue()} Cached Products - Restored');

        final productsJson = List.from(jsonDecode(value));

        prepareProducts(productsJson);

        cacheTime.afterTime('Category${widget.categoriesDataStructure.categoryIdValue()}', dayNumber: 5).then((value) {

          if (value) {

            cacheProducts.store(widget.categoriesDataStructure.categoryIdValue(), '');

          }

        });

      } else {

        final productResponse = await http.get(Uri.parse(endpoints.productsByCategory(widget.categoriesDataStructure.categoryIdValue(), "1")),
            headers: {
              "Authorization": Privates.authenticationAPI
            });

        cacheProducts.store(widget.categoriesDataStructure.categoryIdValue(), productResponse.body);
        debugPrint('Category ${widget.categoriesDataStructure.categoryIdValue()} Cached Products - Stored');

        cacheTime.store('Category${widget.categoriesDataStructure.categoryIdValue()}', DateTime.now().microsecondsSinceEpoch.toString());

        final productsJson = List.from(jsonDecode(productResponse.body));

        prepareProducts(productsJson);

      }

    });

  }

  void prepareProducts(productJson) async {

    productJson.shuffle();

    List<Widget> coolGadgetsList = [];

    List<ProductDataStructure> productsDataStructure = [];

    for (var element in productJson) {

      ProductDataStructure productDataStructure = ProductDataStructure(element);

      coolGadgetsList.add(productsItem(productDataStructure));

      productsDataStructure.add(productDataStructure);

    }

    coolGadgetsList.shuffle();

    productsDataStructure.shuffle();

    setState(() {

      categoryProducts = DynMouseScroll(
          durationMS: 555,
          scrollSpeed: 5.5,
          animationCurve: Curves.easeInOut,
          builder: (context, controller, physics) => ListView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const RangeMaintainingScrollPhysics(),
              children: coolGadgetsList
          )
      );

      keywordsPlaceholder = Keywords(categoryName: widget.categoriesDataStructure.categoryNameValue(), categoryColor: widget.categoriesDataStructure.categoryColorValue(), allProducts: productsDataStructure);

    });

  }

  Widget productsItem(ProductDataStructure productDataStructure) {
    debugPrint('Brand: ${productDataStructure.productBrand()} - Product: ${productDataStructure.productName()}');

    return Container(
      padding: const EdgeInsets.only(top: 17, bottom: 17, right: 19),
      alignment: Alignment.center,
      child: InkWell(
          onTap: () async {

            launchUrl(Uri.parse(productDataStructure.productExternalLink()), mode: LaunchMode.externalApplication);

            FirebaseAnalytics.instance.logEvent(
              name: Analytics.product,
              parameters: {
                Analytics.productTitle: productDataStructure.productName(),
                Analytics.productBrand: productDataStructure.productBrand(),
              }
            );

          },
          child: SizedBox(
            height: 193,
            width: 193,
            child: Stack(
                children: [

                  SizedBox(
                    height: 193,
                    width: 193,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(17),
                      child: FastCachedImage(
                        url: productDataStructure.productImage(),
                        fadeInDuration: const Duration(milliseconds: 555),
                        height: 193,
                        width: 193,
                        fit: BoxFit.cover,
                      )
                    )
                  ),

                  SizedBox(
                      height: 193,
                      width: 193,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          gradient: LinearGradient(
                            colors: [
                              widget.categoriesDataStructure.categoryColorValue(),
                              ColorsResources.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: const [0.1, 1.0]
                          )
                        ),
                      )
                  ),

                  Container(
                      width: 193,
                      padding: const EdgeInsets.only(left: 19, right: 13, bottom: 23),
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                          width: 193,
                          child: Row(
                            children: [

                              Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                      productDataStructure.productName().split("-").first,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: textColor,
                                          letterSpacing: 1.37,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold
                                      )
                                  )
                                )
                              ),

                              Expanded(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: SizedBox(
                                        height: 37,
                                        width: 37,
                                        child: InkWell(
                                            onTap: () async {

                                              Share.share('${productDataStructure.productName()}\n'
                                                  '${productDataStructure.productLink()}\n\n'
                                                  '${productDataStructure.productHashtags()}', subject: productDataStructure.productName());

                                            },
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: Image.asset(
                                                'images/share.png',
                                                height: 37,
                                                width: 37,
                                              )
                                            )
                                        )
                                    )
                                ),
                              )

                            ]
                          )
                      )
                  ),

                ]
            )
          )
      )
    );
  }

}