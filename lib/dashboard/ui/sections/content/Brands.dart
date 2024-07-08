import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_gadgets/cache/process/CacheTime.dart';
import 'package:cool_gadgets/dashboard/data/BrandsDataStructure.dart';
import 'package:cool_gadgets/endpoints/Endpoints.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:cool_gadgets/resources/public/strings_resources.dart';
import 'package:cool_gadgets/utils/calculations/display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:url_launcher/url_launcher.dart';

class Brands extends StatefulWidget {

  const Brands({Key? key}) : super(key: key);

  @override
  State<Brands> createState() => BrandsState();
}
class BrandsState extends State<Brands> {

  Endpoints endpoints = Endpoints();

  CacheTime cacheTime = CacheTime();

  Widget brandsPlaceholder = Container();

  ScrollController scrollController = ScrollController();

  bool aInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {

    SystemNavigator.pop();

    return true;
  }

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(aInterceptor);

    brandsPlaceholder = initialBrands();

    retrieveBrands();

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
      child: SizedBox(
        height: 108,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              height: 29,
              width: displayLogicalWidth(context) / 2,
                constraints: const BoxConstraints(minHeight: 29, maxWidth: 313),
              child: Padding(
                padding: const EdgeInsets.only(left: 17),
                child: Container(
                  decoration: BoxDecoration(
                    border: const Border.symmetric(
                      vertical: BorderSide(
                        color: ColorsResources.premiumLight,
                        width: 3,
                        style: BorderStyle.solid
                      ),
                      horizontal: BorderSide(
                          color: ColorsResources.premiumLight,
                          width: 1,
                          style: BorderStyle.solid
                      )
                    ),
                    borderRadius: BorderRadius.circular(11)
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      StringsResources.titleBrands(),
                      style: const TextStyle(
                        color: ColorsResources.premiumLight,
                        fontSize: 13
                      ),
                    )
                  )
                )
              )
            ),

            SizedBox(
                height: 79,
                child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Container(
                        constraints: const BoxConstraints(minHeight: 79, maxWidth: 1024),
                        decoration: BoxDecoration(
                            border: const Border.symmetric(
                                vertical: BorderSide(
                                    color: ColorsResources.premiumLight,
                                    width: 5,
                                    style: BorderStyle.solid
                                ),
                                horizontal: BorderSide(
                                    color: ColorsResources.premiumLight,
                                    width: 1,
                                    style: BorderStyle.solid
                                )
                            ),
                            borderRadius: BorderRadius.circular(19)
                        ),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(19),
                              child: brandsPlaceholder
                            )
                        )
                    )
                )
            )

          ]
        )
      )
    );
  }

  Widget initialBrands() {

    List<Widget> previewItems = [];

    List<Color> previewColors = [
      ColorsResources.black,
      ColorsResources.purple,
      ColorsResources.orange,
      ColorsResources.green,
      ColorsResources.red,
      ColorsResources.yellow,
    ];

    for(int i = 1; i < 6; i++) {

      previewItems.add(Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11),
          child: SizedBox(
            height: 51,
            width: 51,
            child: Opacity(
              opacity: (0.73 - i/10),
              child: Image.asset(
                'images/squarcle.png',
                height: 51,
                width: 51,
                color: previewColors[i],
              )
            )
          )
        )
      ));

    }

    return DynMouseScroll(
        durationMS: 555,
        scrollSpeed: 5.5,
        animationCurve: Curves.easeInOut,
        builder: (context, controller, physics) => ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 13),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const RangeMaintainingScrollPhysics(),
            children: previewItems
        )
    );
  }

  Future retrieveBrands() async {

    List<Widget> allBrands = [];

    GetOptions getOptions = const GetOptions(source: Source.server);

    cacheTime.afterTime('BRANDS').then((afterSevenDays) {
      debugPrint('BRANDS Cached Time: $afterSevenDays');

      if (afterSevenDays) {

        getOptions = const GetOptions(source: Source.cache);

      } else {

        getOptions = const GetOptions(source: Source.server);

        cacheTime.store('BRANDS', DateTime.now().microsecondsSinceEpoch.toString());

      }

    });

    FirebaseFirestore.instance.collection(endpoints.brandsCollection())
        .orderBy(BrandsDataStructure.categoryIndex, descending: true)
        .get(getOptions).then((querySnapshot) {

          for (var element in querySnapshot.docs) {

            allBrands.add(brandItem(BrandsDataStructure(element)));

          }

          setState(() {

            brandsPlaceholder = DynMouseScroll(
                durationMS: 555,
                scrollSpeed: 5.5,
                animationCurve: Curves.easeInOut,
                builder: (context, controller, physics) => ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const RangeMaintainingScrollPhysics(),
                    children: allBrands
                )
            );

          });

        });

  }

  Widget brandItem(BrandsDataStructure brandsDataStructure) {

    return Align(
        alignment: Alignment.center,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            child: InkWell(
              onTap: () async {
                
                launchUrl(Uri.parse(endpoints.brandsEndpoint(brandsDataStructure.brandNameValue().replaceAll(" ", "-"))), mode: LaunchMode.externalApplication);
                
              },
              child: SizedBox(
                  height: 51,
                  width: 51,
                  child: Image.network(
                      brandsDataStructure.brandImageValue(),
                      height: 51,
                      width: 51
                  )
              )
            )
        )
    );
  }

}