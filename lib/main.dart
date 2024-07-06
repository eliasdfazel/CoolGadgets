import 'package:cool_gadgets/dashboard/ui/Dashboard.dart';
import 'package:cool_gadgets/resources/private/Privates.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:cool_gadgets/resources/public/strings_resources.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaEnterpriseProvider(Privates.reCaptchEnterpriseSiteKey)
  );

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringsResources.titleCoolGadgets(),
      color: ColorsResources.premiumDark,
      theme: ThemeData(
        fontFamily: 'Ubuntu',
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: ColorsResources.premiumDark),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        }),
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.unknown,
        },
      ),
      home: const Dashboard(),
      routes: <String, WidgetBuilder> {
        '/Home': (BuildContext context) => const Dashboard()
        // '/Product': (BuildContext context) => const Product(productId: '')
      },
      onGenerateRoute: (routeSettings) {

        Uri uri = Uri.parse(routeSettings.name ?? "");

        Map<String, dynamic> parameters = {};

        uri.queryParameters.forEach((key, value) {

          parameters[key] = value;

        });

        if (parameters["productId"] != null) { // Open A Product
          debugPrint("Product Id: ${parameters["productId"].toString().toUpperCase()}");

          //https://geeks-empire-website.web.app/#/Product?productId=[]
          // return MaterialPageRoute(
          //     builder: (_) => Product(productId: int.parse(parameters["productId"]))
          // );

        }

      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
            settings: settings,
            builder: (BuildContext context) {

              return const Dashboard();
            }
        );
      }
  ));

}