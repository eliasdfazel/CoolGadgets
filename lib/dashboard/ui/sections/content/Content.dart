import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cool_gadgets/dashboard/ui/sections/content/Brands.dart';
import 'package:cool_gadgets/dashboard/ui/sections/content/categories/Categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Content extends StatefulWidget {

  const Content({Key? key}) : super(key: key);

  @override
  State<Content> createState() => ContentState();
}
class ContentState extends State<Content> {

  bool aInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {

    SystemNavigator.pop();

    return true;
  }

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(aInterceptor);
  }

  @override
  void dispose() {
    super.dispose();

    BackButtonInterceptor.remove(aInterceptor);

  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [

        Opacity(
            opacity: 1.0,
            child: Image.asset(
              'images/elements.png',
              height: double.maxFinite,
              width: double.maxFinite,
              fit: BoxFit.cover,
            )
        ),

        const Brands(),

        const Categories(),

      ]
    );
  }

}