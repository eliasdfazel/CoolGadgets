import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:blur/blur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_gadgets/dashboard/ui/Dashboard.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:cool_gadgets/resources/public/strings_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Header extends StatefulWidget {

  DashboardState dashboardState;
  FirebaseFirestore firebaseFirestore;

  Header({Key? key, required this.dashboardState, required this.firebaseFirestore}) : super(key: key);

  @override
  State<Header> createState() => HeaderState();
}
class HeaderState extends State<Header> {

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
      padding: const EdgeInsets.only(top: 37, left: 37, right: 37),
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

                      SizedBox(
                          height: 73,
                          width: 73,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(13)),
                              child: Material(
                                  shadowColor: Colors.transparent,
                                  color: Colors.transparent,
                                  child: InkWell(
                                      splashColor: ColorsResources.dark,
                                      splashFactory: InkRipple.splashFactory,
                                      onTap: () {

                                        if (widget.dashboardState.menuOpen) {

                                          widget.dashboardState.menuOpen = false;

                                          widget.dashboardState.animationController.reverse().whenComplete(() {

                                          });

                                          widget.dashboardState.setState(() {

                                            widget.dashboardState.menuOpacityAnimation = 0.37;

                                            widget.dashboardState.menuRadiusAnimation = BorderRadius.circular(0);

                                          });

                                        } else {


                                          widget.dashboardState.menuOpen = true;

                                          widget.dashboardState.animationController.forward().whenComplete(() {

                                          });

                                          widget.dashboardState.setState(() {

                                            widget.dashboardState.menuOpacityAnimation = 1;

                                            widget.dashboardState.menuRadiusAnimation = BorderRadius.circular(37);

                                          });

                                        }

                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 51,
                                          width: 51,
                                          child: Image.asset(
                                            'images/logo.png',
                                            height: 51,
                                            width: 51,
                                            fit: BoxFit.contain,
                                          )
                                      )
                                  )
                              )
                          )
                      ),

                      Expanded(
                          child: SizedBox(
                              height: 73,
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(13)),
                                  child: Material(
                                      shadowColor: Colors.transparent,
                                      color: Colors.transparent,
                                      child: InkWell(
                                          splashColor: ColorsResources.dark,
                                          splashFactory: InkRipple.splashFactory,
                                          onTap: () {

                                            launchUrl(Uri.parse(StringsResources.communityLink), mode: LaunchMode.externalApplication);

                                          },
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                  StringsResources.titleCoolGadgets,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: ColorsResources.premiumLight,
                                                      fontSize: 19,
                                                      letterSpacing: 1.73,
                                                      fontWeight: FontWeight.bold
                                                  )
                                              )
                                          )
                                      )
                                  )
                              )
                          )
                      ),

                      SizedBox(
                          height: 73,
                          width: 73,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(13)),
                              child: Material(
                                  shadowColor: Colors.transparent,
                                  color: Colors.transparent,
                                  child: InkWell(
                                      splashColor: ColorsResources.dark,
                                      splashFactory: InkRipple.splashFactory,
                                      onTap: () {

                                        launchUrl(Uri.parse('https://GeeksEmpire.co/Exclusive'), mode: LaunchMode.externalApplication);

                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 33,
                                          width: 33,
                                          child: Image.asset(
                                            'images/menu.png',
                                            height: 33,
                                            width: 33,
                                            fit: BoxFit.contain,
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
        ),
      )
    );
  }

}