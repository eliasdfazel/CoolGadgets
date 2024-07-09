import 'dart:convert';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cool_gadgets/dashboard/data/CategoriesDataStructure.dart';
import 'package:cool_gadgets/dashboard/data/ProductDataStructure.dart';
import 'package:cool_gadgets/dashboard/ui/sections/content/categories/Keywords.dart';
import 'package:cool_gadgets/endpoints/Endpoints.dart';
import 'package:cool_gadgets/resources/private/Privates.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
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
                          child: Text(
                            widget.categoriesDataStructure.categoryNameValue().replaceAll("Cool Gadgets ", ""),
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 23,
                              color: ColorsResources.premiumLight
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

    return Container(
      padding: const EdgeInsets.only(top: 19, bottom: 13, right: 19),
      alignment: Alignment.center,
      child: InkWell(
          onTap: () async {

            launchUrl(Uri.parse(productDataStructure.productExternalLink()), mode: LaunchMode.externalApplication);

          },
          child: ShapedImage(
            imageTye: ImageType.NETWORK,
            path: productDataStructure.productImage(),
            shape: Shape.Rectarcle,
            height: 199,
            width: 199,
            boxFit: BoxFit.cover,
          )
      )
    );
  }

}