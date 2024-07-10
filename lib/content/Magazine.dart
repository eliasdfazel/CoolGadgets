import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_gadgets/cache/process/CacheTime.dart';
import 'package:cool_gadgets/data/MagazineDataStructure.dart';
import 'package:cool_gadgets/data/OffersDataStructure.dart';
import 'package:cool_gadgets/endpoints/Endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:url_launcher/url_launcher.dart';

class Magazine extends StatefulWidget {

  const Magazine({Key? key}) : super(key: key);

  @override
  State<Magazine> createState() => MagazineState();
}
class MagazineState extends State<Magazine> {

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

    retrieveMagazine();

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

  Future retrieveMagazine() async {

    List<Widget> allMagazine = [];

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

    FirebaseFirestore.instance.collection(endpoints.offersCollection())
        .orderBy(OffersDataStructure.offerIndex)
        .get(getOptions).then((querySnapshot) async {

          for (var element in querySnapshot.docs) {

            MagazineDataStructure magazineDataStructure = MagazineDataStructure(element);

            allMagazine.add(magazineItem(magazineDataStructure));

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
                    children: allMagazine
                )
            );

          });

        });

  }

  Widget magazineItem(MagazineDataStructure magazineDataStructure, String magazineImage) {

    return Align(
        alignment: Alignment.center,
        child: Padding(
            padding: const EdgeInsets.only(right: 13),
            child: InkWell(
                onTap: () async {

                  launchUrl(Uri.parse(magazineDataStructure.magazineLink()), mode: LaunchMode.externalApplication);

                },
                child: SizedBox(
                    height: 179,
                    width: 301,
                    child: Image.network(
                      magazineImage,
                      height: 179,
                      width: 301,
                      fit: BoxFit.cover,
                    )
                )
            )
        )
    );
  }

}