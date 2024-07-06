import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cool_gadgets/dashboard/ui/Dashboard.dart';
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

    return SizedBox(
      height: 73,
      child: Padding(
        padding: EdgeInsets.only(left: 37, right: 37),
        child: Container(
          color: Colors.green,
        )
      ),
    );
  }

}