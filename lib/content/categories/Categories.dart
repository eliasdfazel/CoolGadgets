import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_gadgets/cache/process/CacheTime.dart';
import 'package:cool_gadgets/content/categories/CategoriesItem.dart';
import 'package:cool_gadgets/data/CategoriesDataStructure.dart';
import 'package:cool_gadgets/endpoints/Endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Categories extends StatefulWidget {

  FirebaseFirestore firebaseFirestore;

  Categories({Key? key, required this.firebaseFirestore}) : super(key: key);

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
          mainAxisExtent: 357,
          mainAxisSpacing: 37.0,
          crossAxisSpacing: 37.0,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: const []
    );

    retrieveCategories(widget.firebaseFirestore);

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

  void retrieveCategories(FirebaseFirestore firebaseFirestore) {
    debugPrint('Loading Categories');

    GetOptions getOptions = const GetOptions(source: Source.server);

    cacheTime.afterTime('CATEGORIES').then((afterSevenDays) {
      debugPrint('CATEGORIES Cached Time: $afterSevenDays');

      if (afterSevenDays) {

        getOptions = const GetOptions(source: Source.cache);

      } else {

        getOptions = const GetOptions(source: Source.server);

        cacheTime.store('CATEGORIES', DateTime.now().microsecondsSinceEpoch.toString());

      }

    });

    firebaseFirestore.collection(endpoints.categoriesCollection())
        .orderBy(CategoriesDataStructure.categoryIndex)
        .get(getOptions).then((querySnapshot) {

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
            mainAxisExtent: 357,
            mainAxisSpacing: 37.0,
            crossAxisSpacing: 37.0,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: allCategories
      );

    });

  }

}