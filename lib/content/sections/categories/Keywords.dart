
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cool_gadgets/data/Analytics.dart';
import 'package:cool_gadgets/data/ProductDataStructure.dart';
import 'package:cool_gadgets/endpoints/Endpoints.dart';
import 'package:cool_gadgets/utils/calculations/colors.dart';
import 'package:cool_gadgets/utils/operations/CollectionsUtils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Keywords extends StatefulWidget {

  String categoryName;
  Color categoryColor;

  List<ProductDataStructure> allProducts;

  Keywords({Key? key, required this.categoryName, required this.categoryColor, required this.allProducts}) : super(key: key);

  @override
  State<Keywords> createState() => KeywordsState();
}
class KeywordsState extends State<Keywords> {

  Endpoints endpoints = Endpoints();

  Widget allKeywords = ListView();

  bool aInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {

    SystemNavigator.pop();

    return true;
  }

  @override
  void initState() {
    super.initState();
    debugPrint("Category Name: ${widget.categoryName}");

    BackButtonInterceptor.add(aInterceptor);

    allKeywords = ListView();

    prepareKeywords();

  }

  @override
  void dispose() {
    super.dispose();

    BackButtonInterceptor.remove(aInterceptor);

  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 37,
      child: allKeywords
    );
  }

  void prepareKeywords() {

    List<ProductDataStructure> keywordsValue = [];

    List<Widget> keywordsList = [];

    for (var element in widget.allProducts) {

      if (element.productKeyword() != 'Editors Choices'
        && element.productKeyword() != 'Brands') {

        if (!keywordsContains(keywordsValue, element.productKeyword())) {

          keywordsList.add(keywordItem(element));

          keywordsValue.add(element);

        }

      }

    }

    setState(() {

      allKeywords = ListView(
        scrollDirection: Axis.horizontal,
        children: keywordsList
      );

    });

  }

  Widget keywordItem(ProductDataStructure productDataStructure) {
    debugPrint("Product: ${productDataStructure.productName()} - Keyword: ${productDataStructure.productKeyword()}");

    return Padding(
      padding: const EdgeInsets.only(right: 13),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.symmetric(
                vertical: BorderSide(
                    color: widget.categoryColor.withOpacity(0.51),
                    width: 3,
                    style: BorderStyle.solid
                ),
                horizontal: BorderSide(
                    color: widget.categoryColor.withOpacity(0.51),
                    width: 1,
                    style: BorderStyle.solid
                )
            ),
          ),
          child: InkWell(
              onTap: () async {

                keywordProcess(productDataStructure.productKeyword());

              },
              child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Text(
                      productDataStructure.productKeyword(),
                      style: TextStyle(
                        fontSize: 12,
                        color: calculateTextColor(widget.categoryColor),
                        letterSpacing: 1.73
                      ),
                    )
                  )
              )
          )
      )
    );
  }

  void keywordProcess(String keywordQuery) async {

    launchUrl(Uri.parse(endpoints.keywordEndpoint(keywordQuery.replaceAll(" ", "-"))), mode: LaunchMode.externalApplication);

    FirebaseAnalytics.instance.logEvent(
        name: Analytics.keyword,
        parameters: {
          Analytics.keywordTitle: keywordQuery,
        }
    );

  }

}