import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_gadgets/content/Content.dart';
import 'package:cool_gadgets/dashboard/ui/sections/Header.dart';
import 'package:cool_gadgets/dashboard/ui/sections/Menus.dart';
import 'package:cool_gadgets/dashboard/ui/sections/Search.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:cool_gadgets/utils/calculations/display.dart';
import 'package:cool_gadgets/utils/calculations/numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Dashboard extends StatefulWidget {

  FirebaseFirestore firebaseFirestore;

  Dashboard({Key? key, required this.firebaseFirestore}) : super(key: key);

  @override
  State<Dashboard> createState() => DashboardState();
}
class DashboardState extends State<Dashboard> with TickerProviderStateMixin {

  /*
   * Start - Menu
   */
  late AnimationController animationController;

  late Animation<Offset> menuOffsetAnimation;
  late Animation<double> menuScaleAnimation;
  BorderRadius menuRadiusAnimation = BorderRadius.circular(0);

  late Animation<Offset> menuOffsetAnimationItems;
  double menuOpacityAnimation = 0.37;

  bool menuOpen = false;
  /*
   * End - Menu
   */

  bool aInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {

    SystemNavigator.pop();

    return true;
  }

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(aInterceptor);

    animationController = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 777),
        reverseDuration: const Duration(milliseconds: 333),
        animationBehavior: AnimationBehavior.preserve);

    /*
     * Start - Menu
     */
    menuOffsetAnimation = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.51, 0))
        .animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn
    ));
    menuScaleAnimation = Tween<double>(begin: 1, end: 0.91)
        .animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut
    ));

    menuOffsetAnimationItems = Tween<Offset>(begin: const Offset(-0.19, 0), end: const Offset(0, 0))
        .animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn
    ));
    /*
     * End - Menu
     */

  }

  @override
  void dispose() {
    super.dispose();

    BackButtonInterceptor.remove(aInterceptor);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorsResources.black,
        body: Stack(
            children: [

              /*
               * Start - Menu
               */
              prepareMenu(),
              /*
               * End - Menu
               */

              /*
               * Start - Content
               */
              prepareContent(widget.firebaseFirestore),
              /*
               * End - Content
               */

            ]
        )
    );
  }

  Widget prepareContent(FirebaseFirestore firebaseFirestore) {

    return SlideTransition(
        position: menuOffsetAnimation,
        child: ScaleTransition(
            scale: menuScaleAnimation,
            child: Stack(
                children: [

                  /* Start - Content */
                  AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      decoration: BoxDecoration(
                          color: ColorsResources.premiumDark,
                          borderRadius: menuRadiusAnimation,
                          border: Border.all(
                              color: Colors.transparent,
                              width: 0
                          )
                      ),
                      child: Content(firebaseFirestore: firebaseFirestore)
                  ),
                  /* End - Content */

                  /* Start - Header */
                  Align(
                    alignment: Alignment.topCenter,
                    child: Header(dashboardState: this, firebaseFirestore: widget.firebaseFirestore)
                  ),
                  /* End - Header */

                  /* Start - Search */
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: Search(),
                  )
                  /* End - Search */

                ]
            )
        )
    );
  }

  Widget prepareMenu() {

    return Container(
        width: calculatePercentage(53, displayLogicalWidth(context)),
        alignment: AlignmentDirectional.centerStart,
        color: Colors.black,
        child: SlideTransition(
            position: menuOffsetAnimationItems,
            child: AnimatedOpacity(
                opacity: menuOpacityAnimation,
                duration: Duration(milliseconds: menuOpen ? 753 : 137),
                child: const Menus()
            )
        )
    );
  }

}