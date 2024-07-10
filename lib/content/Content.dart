import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cool_gadgets/content/Brands.dart';
import 'package:cool_gadgets/content/Magazine.dart';
import 'package:cool_gadgets/content/Offers.dart';
import 'package:cool_gadgets/content/categories/Categories.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

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

        DynMouseScroll(
            durationMS: 555,
            scrollSpeed: 5.5,
            animationCurve: Curves.easeInOut,
            builder: (context, controller, physics) => ListView(
                padding: const EdgeInsets.only(top: 157, bottom: 157),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const RangeMaintainingScrollPhysics(),
                children: const [

                  Brands(),

                  Divider(height: 37, color: ColorsResources.transparent),

                  Offers(),

                  Divider(height: 37, color: ColorsResources.transparent),

                  Categories(),

                  Divider(height: 37, color: ColorsResources.transparent),

                  Magazine()

                ]
            )
        )

      ]
    );
  }

}