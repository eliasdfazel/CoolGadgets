import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_gadgets/cache/process/CacheTime.dart';
import 'package:cool_gadgets/data/MagazineDataStructure.dart';
import 'package:cool_gadgets/endpoints/Endpoints.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
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

  Widget magazinePlaceholder = ListView();

  ScrollController scrollController = ScrollController();

  bool aInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {

    SystemNavigator.pop();

    return true;
  }

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(aInterceptor);

    magazinePlaceholder = ListView(
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
        height: 199,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 37, right: 37),
        child: Container(
            constraints: const BoxConstraints(minHeight: 146, maxWidth: 1024),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: magazinePlaceholder
            )
        )
    );
  }

  Future retrieveMagazine() async {

    List<Widget> allMagazine = [];

    GetOptions getOptions = const GetOptions(source: Source.server);

    cacheTime.afterTime('MAGAZINE').then((afterSevenDays) {
      debugPrint('MAGAZINE Cached Time: $afterSevenDays');

      if (afterSevenDays) {

        getOptions = const GetOptions(source: Source.cache);

      } else {

        getOptions = const GetOptions(source: Source.server);

        cacheTime.store('MAGAZINE', DateTime.now().microsecondsSinceEpoch.toString());

      }

    });

    FirebaseFirestore.instance.collection(endpoints.magazineCollection())
        .get(getOptions).then((querySnapshot) async {

          for (var element in querySnapshot.docs) {

            allMagazine.add(magazineItem(MagazineDataStructure(element)));

          }

          setState(() {

            magazinePlaceholder = DynMouseScroll(
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

  Widget magazineItem(MagazineDataStructure magazineDataStructure) {

    return Align(
        alignment: Alignment.center,
        child: Padding(
            padding: const EdgeInsets.only(right: 13),
            child: InkWell(
                onTap: () async {

                  launchUrl(Uri.parse(magazineDataStructure.magazineLink()), mode: LaunchMode.externalApplication);

                },
                child: SizedBox(
                    height: 199,
                    width: 301,
                    child: Stack(
                      children: [

                        SizedBox(
                            height: 199,
                            width: 301,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(19),
                              child: Image.network(
                                magazineDataStructure.magazineImage(),
                                height: 179,
                                width: 301,
                                fit: BoxFit.cover,
                              )
                            )
                        ),

                        SizedBox(
                            height: 199,
                            width: 301,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(19),
                                child: Container(
                                  height: 179,
                                  width: 301,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        ColorsResources.black,
                                        ColorsResources.transparent
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter
                                    )
                                  )
                                )
                            )
                        ),

                        Container(
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.only(bottom: 19, left: 37, right: 37),
                          child: Text(
                            magazineDataStructure.magazineTitle(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: ColorsResources.premiumLight,
                              fontSize: 13,
                              shadows: [
                                Shadow(
                                  color: ColorsResources.black.withOpacity(0.37),
                                  blurRadius: 5,
                                  offset: const Offset(0.0, 5.0)
                                )
                              ]
                            ),
                          )
                        )

                      ]
                    )
                )
            )
        )
    );
  }

}