import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_gadgets/cache/process/CacheTime.dart';
import 'package:cool_gadgets/dashboard/data/CategoriesDataStructure.dart';
import 'package:cool_gadgets/dashboard/ui/sections/content/categories/CategoriesItem.dart';
import 'package:cool_gadgets/endpoints/Endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Categories extends StatefulWidget {

  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => CategoriesState();
}
class CategoriesState extends State<Categories> {

  Endpoints endpoints = Endpoints();

  CacheTime cacheTime = CacheTime();

  Widget categoriesPlaceholder = ListView();

  bool aInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {

    SystemNavigator.pop();

    return true;
  }

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(aInterceptor);

    categoriesPlaceholder = GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.39,
          crossAxisSpacing: 19.0,
          mainAxisSpacing: 19.0,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: const []
    );

    retrieveCategories();

  }

  @override
  void dispose() {
    super.dispose();

    BackButtonInterceptor.remove(aInterceptor);

  }

  @override
  Widget build(BuildContext context) {

    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 37, right: 37),
        child: Container(
            constraints: const BoxConstraints(maxWidth: 1024),
            child: categoriesPlaceholder
        )
    );
  }

  void retrieveCategories() {

    GetOptions getOptions = const GetOptions(source: Source.server);

    cacheTime.afterTime().then((afterSevenDays) {

      if (afterSevenDays) {

        getOptions = const GetOptions(source: Source.server);

      } else {

        getOptions = const GetOptions(source: Source.cache);

      }

    });

    FirebaseFirestore.instance.collection(endpoints.categoriesCollection())
        .orderBy(CategoriesDataStructure.categoryIndex)
        .get(getOptions).then((querySnapshot) {

          cacheTime.store(DateTime.now().microsecondsSinceEpoch);

          prepareCategories(querySnapshot);

        });

  }

  void prepareCategories(QuerySnapshot querySnapshot) async {

    List<Widget> allCategories = [];

    for (var element in querySnapshot.docs) {

      allCategories.add(CategoryItem(categoriesDataStructure: CategoriesDataStructure(element)));

    }

    setState(() {

      int gridColumnCount = 1;

      if (GetPlatform.isDesktop) {

        gridColumnCount = 2;

      } else {

        gridColumnCount = 1;

      }

      categoriesPlaceholder = GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridColumnCount,
            childAspectRatio: 1.39,
            crossAxisSpacing: 37.0,
            mainAxisSpacing: 37.0,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: allCategories
      );

    });

  }

}