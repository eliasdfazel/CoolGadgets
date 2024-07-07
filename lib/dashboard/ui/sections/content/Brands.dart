import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:cool_gadgets/resources/public/strings_resources.dart';
import 'package:cool_gadgets/utils/calculations/display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Brands extends StatefulWidget {

  const Brands({Key? key}) : super(key: key);

  @override
  State<Brands> createState() => BrandsState();
}
class BrandsState extends State<Brands> {

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
      padding: const EdgeInsets.only(top: 173, left: 37, right: 37),
      child: SizedBox(
        height: 101,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(
              height: 29,
              width: displayLogicalWidth(context) / 2,
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
            )

          ]
        )
      )
    );
  }

}