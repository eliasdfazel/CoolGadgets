import 'package:cool_gadgets/resources/public/strings_resources.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget coolGadgetsCommunity() {

  return Container(
      constraints: const BoxConstraints(maxWidth: 1024),
      padding: const EdgeInsets.only(top: 37, bottom: 37),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
            onTap: () {

              launchUrl(Uri.parse(StringsResources.communityLink), mode: LaunchMode.externalApplication);

            },
            child: Image.asset(
              'images/cool_gadgets_community.jpg',
              fit: BoxFit.cover,
            )
        )
      )
  );
}