import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:blur/blur.dart';
import 'package:cool_gadgets/dashboard/ui/Dashboard.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:cool_gadgets/resources/public/strings_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Header extends StatefulWidget {

  DashboardState dashboardState;

  Header({Key? key, required this.dashboardState}) : super(key: key);

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

    return Padding(
      padding: const EdgeInsets.only(top: 37, left: 37, right: 37),
      child: SizedBox(
          height: 73,
          child: Blur(
              blur: 7,
              blurColor: ColorsResources.premiumDark,
              colorOpacity: 0.51,
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
                                      splashColor: ColorsResources.premiumLight.withOpacity(0.37),
                                      splashFactory: InkRipple.splashFactory,
                                      onTap: () {

                                        if (widget.dashboardState.menuOpen) {

                                          widget.dashboardState.menuOpen = false;

                                          widget.dashboardState.animationController.reverse().whenComplete(() {

                                          });

                                          widget.dashboardState.setState(() {

                                            widget.dashboardState.opacityAnimation = 0.37;

                                            widget.dashboardState.radiusAnimation = BorderRadius.circular(0);

                                          });

                                        } else {


                                          widget.dashboardState.menuOpen = true;

                                          widget.dashboardState.animationController.forward().whenComplete(() {

                                          });

                                          widget.dashboardState.setState(() {

                                            widget.dashboardState.opacityAnimation = 1;

                                            widget.dashboardState.radiusAnimation = BorderRadius.circular(37);

                                          });

                                        }

                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 59,
                                          width: 59,
                                          child: Image.asset(
                                            'images/logo.png',
                                            height: 59,
                                            width: 59,
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
                                        splashColor: ColorsResources.premiumLight.withOpacity(0.37),
                                        splashFactory: InkRipple.splashFactory,
                                        onTap: () {

                                        },
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              StringsResources.titleCoolGadgets(),
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
                                        splashColor: ColorsResources.premiumLight.withOpacity(0.37),
                                        splashFactory: InkRipple.splashFactory,
                                        onTap: () {



                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            height: 37,
                                            width: 37,
                                            child: Image.asset(
                                              'images/menu.png',
                                              height: 37,
                                              width: 37,
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
          )
      )
    );
  }

}