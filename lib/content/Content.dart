import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_gadgets/content/sections/Associates.dart';
import 'package:cool_gadgets/content/sections/Brands.dart';
import 'package:cool_gadgets/content/sections/Community.dart';
import 'package:cool_gadgets/content/sections/Magazine.dart';
import 'package:cool_gadgets/content/sections/Offers.dart';
import 'package:cool_gadgets/content/sections/categories/Categories.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

class Content extends StatefulWidget {

  FirebaseFirestore firebaseFirestore;

  Content({Key? key, required this.firebaseFirestore}) : super(key: key);

  @override
  State<Content> createState() => ContentState();
}
class ContentState extends State<Content> {

  Widget brandsContainer = Container();
  Widget offersContainer = Container();
  Widget categoriesContainer = Container();
  Widget magazineContainer = Container();

  bool aInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {

    SystemNavigator.pop();

    return true;
  }

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(aInterceptor);

    categoriesContainer = Categories(firebaseFirestore: widget.firebaseFirestore);
    offersContainer = Offers(firebaseFirestore: widget.firebaseFirestore);
    brandsContainer = Brands(firebaseFirestore: widget.firebaseFirestore);
    magazineContainer = Magazine(firebaseFirestore: widget.firebaseFirestore);

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
            opacity: 0.51,
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
                children: [

                  brandsContainer,

                  const Divider(height: 37, color: ColorsResources.transparent),

                  offersContainer,

                  const Divider(height: 37, color: ColorsResources.transparent),

                  categoriesContainer,

                  const Divider(height: 37, color: ColorsResources.transparent),

                  magazineContainer,

                  const Divider(height: 37, color: ColorsResources.transparent),

                  coolGadgetsCommunity(),

                  const Divider(height: 37, color: ColorsResources.transparent),

                  associatesBranding(),

                ]
            )
        )

      ]
    );
  }

}