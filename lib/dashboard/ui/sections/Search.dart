import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:blur/blur.dart';
import 'package:cool_gadgets/endpoints/Endpoints.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:cool_gadgets/resources/public/strings_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Search extends StatefulWidget {

  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => SearchState();
}
class SearchState extends State<Search> {

  Endpoints endpoints = Endpoints();

  TextEditingController searchController = TextEditingController();

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

    return Container(
        padding: const EdgeInsets.only(bottom: 37, left: 37, right: 37),
        constraints: const BoxConstraints(minHeight: 73, maxWidth: 1024),
        child: SizedBox(
            height: 73,
            child: Blur(
                blur: 7,
                blurColor: ColorsResources.premiumDark,
                colorOpacity: 0.19,
                borderRadius: BorderRadius.circular(19),
                overlay: SizedBox(
                    height: 73,
                    width: double.maxFinite,
                    child: Row(
                        children: [

                          Expanded(
                              child: SizedBox(
                                  height: 73,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 13, right: 7),
                                    alignment: Alignment.centerLeft,
                                    child: TextField(
                                        controller: searchController,
                                        maxLines: 1,
                                        onSubmitted: (searchQuery) async {

                                          searchProcess(searchQuery);

                                        },
                                        cursorColor: ColorsResources.dark.withOpacity(0.51),
                                        cursorWidth: 3,
                                        cursorRadius: const Radius.circular(99),
                                        decoration: InputDecoration(
                                            hintText: StringsResources.hintSearch(),
                                            hintStyle: TextStyle(
                                                fontSize: 23,
                                                color: ColorsResources.premiumLight.withOpacity(0.37),
                                                decoration: TextDecoration.none
                                            ),
                                            enabledBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 0
                                                )
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 0
                                                )
                                            )
                                        ),
                                        style: const TextStyle(
                                            fontSize: 23,
                                            color: ColorsResources.premiumLight,
                                            decoration: TextDecoration.none
                                        )
                                    )
                                  )
                              )
                          ),

                          SizedBox(
                              height: 73,
                              width: 119,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorsResources.premiumDark.withOpacity(0.73),
                                  borderRadius: BorderRadius.circular(13),
                                  boxShadow: [

                                    BoxShadow(
                                      color: ColorsResources.black.withOpacity(0.13),
                                      blurRadius: 13,
                                      offset: const Offset(-13, 0)
                                    )

                                  ]
                                ),
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(13)),
                                    child: Material(
                                        shadowColor: Colors.transparent,
                                        color: Colors.transparent,
                                        child: InkWell(
                                            splashColor: ColorsResources.dark,
                                            splashFactory: InkRipple.splashFactory,
                                            onTap: () async {

                                              searchProcess(searchController.text);

                                            },
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [

                                                  Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                          StringsResources.titleSearch(),
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                              color: ColorsResources.premiumLight,
                                                              fontSize: 15,
                                                              letterSpacing: 3.7,
                                                              fontWeight: FontWeight.bold
                                                          )
                                                      )
                                                  ),

                                                  Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                          StringsResources.titleArwenAi(),
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                              color: ColorsResources.premiumLight,
                                                              letterSpacing: 1.9,
                                                              fontSize: 9
                                                          )
                                                      )
                                                  )

                                                ]
                                            )
                                        )
                                    )
                                )
                              )
                          )

                        ]
                    )
                ),
                child: const SizedBox(
                    height: 73,
                    width: double.maxFinite
                )
            )
        )
    );
  }

  void searchProcess(String searchQuery) async {

    launchUrl(Uri.parse(endpoints.searchEndpoint(searchQuery)), mode: LaunchMode.externalApplication);

  }

}