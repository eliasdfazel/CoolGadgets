import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_gadgets/cache/process/CacheTimes.dart';
import 'package:cool_gadgets/data/OffersDataStructure.dart';
import 'package:cool_gadgets/endpoints/Endpoints.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:url_launcher/url_launcher.dart';

class Offers extends StatefulWidget {

  FirebaseFirestore firebaseFirestore;

  Offers({Key? key, required this.firebaseFirestore}) : super(key: key);

  @override
  State<Offers> createState() => OffersState();
}
class OffersState extends State<Offers> {

  Endpoints endpoints = Endpoints();

  CacheTime cacheTime = CacheTime();

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

    retrieveOffers(widget.firebaseFirestore);

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

  Future retrieveOffers(FirebaseFirestore firebaseFirestore) async {
    debugPrint('Loading Offers');

    List<Widget> allOffers = [];

    GetOptions getOptions = const GetOptions(source: Source.server);

    cacheTime.afterTime('OFFERS').then((afterSevenDays) {
      debugPrint('OFFERS Cached Time: $afterSevenDays');

      if (afterSevenDays) {

        getOptions = const GetOptions(source: Source.cache);

      } else {

        getOptions = const GetOptions(source: Source.server);

        cacheTime.store('OFFERS', DateTime.now().microsecondsSinceEpoch.toString());

      }

    });

    firebaseFirestore.collection(endpoints.offersCollection())
        .orderBy(OffersDataStructure.offerIndex)
        .get(getOptions).then((querySnapshot) {

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
                    child: FastCachedImage(
                        url: offersDataStructure.offerImageValue(),
                        fadeInDuration: const Duration(milliseconds: 555),
                        height: 146,
                        width: 356
                    )
                )
            )
        )
    );
  }

}