import 'package:cool_gadgets/resources/public/strings_resources.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget associatesBranding() {

  return Container(
    padding: const EdgeInsets.only(top: 37, bottom: 37),
    alignment: Alignment.center,
    child: InkWell(
      onTap: () {

        launchUrl(Uri.parse(StringsResources.linkGeeksEmpire), mode: LaunchMode.externalApplication);

      },
      child: SizedBox(
          height: 31,
          width: 177,
          child: Image.asset(
              'images/associate_branding.png'
          )
      )
    )
  );

}