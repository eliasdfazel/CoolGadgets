import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_gadgets/dashboard/data/OffersDataStructure.dart';
import 'package:cool_gadgets/endpoints/Endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:url_launcher/url_launcher.dart';

class Offers extends StatefulWidget {

  const Offers({Key? key}) : super(key: key);

  @override
  State<Offers> createState() => OffersState();
}
class OffersState extends State<Offers> {

  Endpoints endpoints = Endpoints();

  Widget brandsPlaceholder = ListView();

  ScrollController scrollController = ScrollController();

  bool aInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {

    SystemNavigator.pop();

    return true;
  }

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(aInterceptor);

    brandsPlaceholder = ListView(
        controller: scrollController,
        children: const []
    );

    retrieveOffers();

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
        padding: const EdgeInsets.only(left: 37, right: 37),
        child: Container(
            constraints: const BoxConstraints(minHeight: 146, maxWidth: 1024),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: brandsPlaceholder
            )
        )
    );
  }

  Future retrieveOffers() async {

    List<Widget> allOffers = [];

    FirebaseFirestore.instance.collection(endpoints.offersCollection())
        .get().then((querySnapshot) {

          for (var element in querySnapshot.docs) {

            allOffers.add(offerItem(OffersDataStructure(element)));

          }

          setState(() {

            brandsPlaceholder = DynMouseScroll(
                durationMS: 555,
                scrollSpeed: 5.5,
                animationCurve: Curves.easeInOut,
                builder: (context, controller, physics) => ListView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const RangeMaintainingScrollPhysics(),
                    children: allOffers
                )
            );

          });

        });

  }

  Widget offerItem(OffersDataStructure offersDataStructure) {

    return Align(
        alignment: Alignment.center,
        child: Padding(
            padding: const EdgeInsets.only(right: 13),
            child: InkWell(
                onTap: () async {

                  launchUrl(Uri.parse(offersDataStructure.offerLinkValue()), mode: LaunchMode.externalApplication);

                },
                child: SizedBox(
                    height: 146,
                    width: 356,
                    child: Image.network(
                        offersDataStructure.offerImageValue(),
                        height: 146,
                        width: 356
                    )
                )
            )
        )
    );
  }

}