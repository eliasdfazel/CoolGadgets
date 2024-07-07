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
  late AnimationController menuAnimationController;

  late Animation<Offset> menuOffsetAnimation;
  late Animation<double> menuScaleAnimation;
  BorderRadius menuRadiusAnimation = BorderRadius.circular(0);

  late Animation<Offset> menuOffsetAnimationItems;
  double menuOpacityAnimation = 0.37;

  bool menuOpen = false;
  /*
   * End - Menu
   */

  /*
   * Start - Category
   */
  late AnimationController categoryAnimationController;

  late Animation<Offset> categoryOffsetAnimation;
  late Animation<double> categoryScaleAnimation;
  BorderRadius categoryRadiusAnimation = BorderRadius.circular(0);

  late Animation<Offset> categoryOffsetAnimationItems;
  double categoryOpacityAnimation = 0.37;

  bool categoryOpen = false;
  /*
   * End - Category
   */

  bool aInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {

    SystemNavigator.pop();

    return true;
  }

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(aInterceptor);

    /*
     * Start - Menu
     */
    menuAnimationController = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 777),
        reverseDuration: const Duration(milliseconds: 333),
        animationBehavior: AnimationBehavior.preserve);

    menuOffsetAnimation = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.51, 0))
        .animate(CurvedAnimation(
        parent: menuAnimationController,
        curve: Curves.easeIn
    ));
    menuScaleAnimation = Tween<double>(begin: 1, end: 0.91)
        .animate(CurvedAnimation(
        parent: menuAnimationController,
        curve: Curves.easeOut
    ));

    menuOffsetAnimationItems = Tween<Offset>(begin: const Offset(-0.19, 0), end: const Offset(0, 0))
        .animate(CurvedAnimation(
        parent: menuAnimationController,
        curve: Curves.easeIn
    ));
    /*
     * End - Menu
     */

    /*
     * Start - Category
     */
    categoryAnimationController = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 777),
        reverseDuration: const Duration(milliseconds: 333),
        animationBehavior: AnimationBehavior.preserve);

    categoryOffsetAnimation = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.51, 0))
        .animate(CurvedAnimation(
        parent: categoryAnimationController,
        curve: Curves.easeIn
    ));
    categoryScaleAnimation = Tween<double>(begin: 1, end: 0.91)
        .animate(CurvedAnimation(
        parent: categoryAnimationController,
        curve: Curves.easeOut
    ));

    categoryOffsetAnimationItems = Tween<Offset>(begin: const Offset(-0.19, 0), end: const Offset(0, 0))
        .animate(CurvedAnimation(
        parent: categoryAnimationController,
        curve: Curves.easeIn
    ));
    /*
     * End - Category
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
               * Start - Category
               */
              prepareCategory(),
              /*
               * End - Category
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
            position: menuOffsetAnimationItems,
            child: AnimatedOpacity(
                opacity: menuOpacityAnimation,
                duration: Duration(milliseconds: menuOpen ? 753 : 137),
                child: const Menus()
            )
        )
    );
  }

  Widget prepareCategory() {

    return Container(
        width: calculatePercentage(53, displayLogicalWidth(context)),
        alignment: AlignmentDirectional.centerStart,
        color: Colors.black,
        child: SlideTransition(
            position: categoryOffsetAnimationItems,
            child: AnimatedOpacity(
                opacity: categoryOpacityAnimation,
                duration: Duration(milliseconds: menuOpen ? 753 : 137),
                child: const Menus()
            )
        )
    );
  }

}