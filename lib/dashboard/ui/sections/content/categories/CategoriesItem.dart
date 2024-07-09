import 'dart:convert';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cool_gadgets/dashboard/data/Analytics.dart';
import 'package:cool_gadgets/dashboard/data/CategoriesDataStructure.dart';
import 'package:cool_gadgets/dashboard/data/ProductDataStructure.dart';
import 'package:cool_gadgets/dashboard/ui/sections/content/categories/Keywords.dart';
import 'package:cool_gadgets/endpoints/Endpoints.dart';
import 'package:cool_gadgets/resources/private/Privates.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shaped_image/shaped_image.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryItem extends StatefulWidget {

  CategoriesDataStructure categoriesDataStructure;

  CategoryItem({Key? key, required this.categoriesDataStructure}) : super(key: key);

  @override
  State<CategoryItem> createState() => CategoryItemState();
}
class CategoryItemState extends State<CategoryItem> {

  Endpoints endpoints = Endpoints();

  Widget categoryProducts = ListView();

  ScrollController scrollController = ScrollController();

  Widget keywordsPlaceholder = Container();

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

  }

  @override
  void dispose() {
    super.dispose();

    BackButtonInterceptor.remove(aInterceptor);

  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 313,
      width: 356,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Container(
          decoration: BoxDecoration(
            color: widget.categoriesDataStructure.categoryColorValue().withOpacity(0.377)
          ),
          child: Padding(
            padding: const EdgeInsets.all(7),
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
                        color: widget.categoriesDataStructure.categoryColorValue().withOpacity(0.37)
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
                                  style: const TextStyle(
                                      fontSize: 23,
                                      color: ColorsResources.premiumLight
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

    final productResponse = await http.get(Uri.parse(endpoints.productsByCategory(widget.categoriesDataStructure.categoryIdValue(), "1")),
        headers: {
          "Authorization": Privates.authenticationAPI
        });

    final productsJson = List.from(jsonDecode(productResponse.body));

    prepareProducts(productsJson);

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

    Color textColor = ColorsResources.white;

    if (widget.categoriesDataStructure.categoryColorValue() == Colors.black) {

      textColor = ColorsResources.white;

    } else {

      textColor = ColorsResources.black;

    }

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
            height: 187,
            width: 187,
            child: Stack(
                children: [

                  SizedBox(
                    height: 187,
                    width: 187,
                    child: ShapedImage(
                      imageTye: ImageType.NETWORK,
                      path: productDataStructure.productImage(),
                      shape: Shape.Rectarcle,
                      height: 187,
                      width: 187,
                      boxFit: BoxFit.cover,
                    )
                  ),

                  SizedBox(
                      height: 187,
                      width: 187,
                      child: Opacity(
                        opacity: 0.73,
                        child: ShapedImage(
                          imageTye: ImageType.ASSET,
                          path: 'images/gradient.png',
                          shape: Shape.Rectarcle,
                          height: 187,
                          width: 187,
                          boxFit: BoxFit.cover,
                          color: widget.categoriesDataStructure.categoryColorValue(),
                        )
                      )
                  ),

                  Container(
                      width: 187,
                      padding: const EdgeInsets.only(left: 13, right: 13, bottom: 23),
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                          width: 187,
                          child: Text(
                              productDataStructure.productName().split("-").first,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 13
                              )
                          )
                      )
                  )

                ]
            )
          )
      )
    );
  }

}