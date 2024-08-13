import 'package:cool_gadgets/resources/public/strings_resources.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget coolGadgetsCommunity() {

  return Container(
      constraints: const BoxConstraints(minWidth: 199, maxWidth: 1024),
      padding: const EdgeInsets.only(left: 37, right: 37),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
            onTap: () {

              launchUrl(Uri.parse(StringsResources.communityLink), mode: LaunchMode.externalApplication);

            },
            child: Container(
                constraints: const BoxConstraints(minWidth: 199, maxWidth: 1024),
                alignment: Alignment.topCenter,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: Image.asset(
                      'images/cool_gadgets_community.jpg',
                      fit: BoxFit.cover,
                    )
                )
            ),
        )
      )
  );
}