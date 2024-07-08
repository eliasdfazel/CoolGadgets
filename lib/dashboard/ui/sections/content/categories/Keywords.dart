import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cool_gadgets/dashboard/data/ProductDataStructure.dart';
import 'package:cool_gadgets/endpoints/Endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Keywords extends StatefulWidget {

  Color categoryColor;
  List<ProductDataStructure> allProducts;

  Keywords({Key? key, required this.categoryColor, required this.allProducts}) : super(key: key);

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

    BackButtonInterceptor.add(aInterceptor);

    prepareKeywords();

  }

  @override
  void dispose() {
    super.dispose();

    BackButtonInterceptor.remove(aInterceptor);

  }

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: const EdgeInsets.only(top: 37, left: 37, right: 37),
        constraints: const BoxConstraints(minHeight: 73, maxWidth: 1024),
        child: SizedBox(
          height: 37,
          child: allKeywords
        )
    );
  }

  void prepareKeywords() {

    List<Widget> keywords = [];

    for (var element in widget.allProducts) {

      keywords.add(keywordItem(element));

    }

    setState(() {

      allKeywords = ListView(
        scrollDirection: Axis.horizontal,
        children: keywords
      );

    });

  }

  Widget keywordItem(ProductDataStructure productDataStructure) {
    debugPrint(productDataStructure.productKeyword());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.symmetric(
                vertical: BorderSide(
                    color: widget.categoryColor,
                    width: 3,
                    style: BorderStyle.solid
                ),
                horizontal: BorderSide(
                    color: widget.categoryColor,
                    width: 1,
                    style: BorderStyle.solid
                )
            ),
          ),
          child: InkWell(
              onTap: () async {

                searchProcess(productDataStructure.productKeyword());

              },
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                      productDataStructure.productKeyword()
                  )
              )
          )
      )
    );
  }

  void searchProcess(String searchQuery) async {

    if (searchQuery.length >= 3) {

      launchUrl(Uri.parse(endpoints.searchEndpoint(searchQuery)), mode: LaunchMode.externalApplication);

    }

  }

}