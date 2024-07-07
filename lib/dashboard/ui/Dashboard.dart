import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cool_gadgets/dashboard/ui/sections/categories.dart';
import 'package:cool_gadgets/dashboard/ui/sections/header.dart';
import 'package:cool_gadgets/dashboard/ui/sections/menus.dart';
import 'package:cool_gadgets/dashboard/ui/sections/search.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:cool_gadgets/utils/calculations/display.dart';
import 'package:cool_gadgets/utils/calculations/numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Dashboard extends StatefulWidget {

  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => DashboardState();
}
class DashboardState extends State<Dashboard> with TickerProviderStateMixin {

  /*
   * Start - Menu
   */
  late AnimationController animationController;

  late Animation<Offset> offsetAnimation;
  late Animation<double> scaleAnimation;
  BorderRadius radiusAnimation = BorderRadius.circular(0);

  late Animation<Offset> offsetAnimationItems;
  double opacityAnimation = 0.37;

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

    offsetAnimation = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.51, 0))
        .animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn
    ));
    scaleAnimation = Tween<double>(begin: 1, end: 0.91)
        .animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut
    ));

    offsetAnimationItems = Tween<Offset>(begin: const Offset(-0.19, 0), end: const Offset(0, 0))
        .animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn
    ));

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
              prepareContent(),
              /*
               * End - Content
               */

            ]
        )
    );
  }

  Widget prepareContent() {

    return SlideTransition(
        position: offsetAnimation,
        child: ScaleTransition(
            scale: scaleAnimation,
            child: Stack(
                children: [

                  /* Start - Content */
                  AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastOutSlowIn,
                      decoration: BoxDecoration(
                          color: ColorsResources.premiumDark,
                          borderRadius: radiusAnimation,
                          border: Border.all(
                              color: Colors.transparent,
                              width: 0
                          )
                      ),
                      child: const Categories()
                  ),
                  /* End - Content */

                  /* Start - Header */
                  Header(dashboardState: this),
                  /* End - Header */

                  /* Start - Search */
                  const Search(),
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
            position: offsetAnimationItems,
            child: AnimatedOpacity(
                opacity: opacityAnimation,
                duration: Duration(milliseconds: menuOpen ? 753 : 137),
                child: const Menus()
            )
        )
    );
  }

}