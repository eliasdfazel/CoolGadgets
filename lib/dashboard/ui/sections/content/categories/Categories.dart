import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Categories extends StatefulWidget {

  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => CategoriesState();
}
class CategoriesState extends State<Categories> {

  Widget categoriesPlaceholder = ListView();

  bool aInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {

    SystemNavigator.pop();

    return true;
  }

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(aInterceptor);

    categoriesPlaceholder = ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: const []
    );

  }

  @override
  void dispose() {
    super.dispose();

    BackButtonInterceptor.remove(aInterceptor);

  }

  @override
  Widget build(BuildContext context) {

    return Container(
        height: 146,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 37, left: 37, right: 37),
        child: Container(
            constraints: const BoxConstraints(maxWidth: 1024),
            child: categoriesPlaceholder
        )
    );
  }

}