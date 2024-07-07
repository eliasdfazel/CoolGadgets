import 'package:back_button_interceptor/back_button_interceptor.dart';
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
      padding: EdgeInsets.only(top: 51, left: 37, right: 37),
      child: SizedBox(
        height: 101,
      )
    );
  }

}