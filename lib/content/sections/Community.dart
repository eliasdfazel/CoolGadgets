import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:cool_gadgets/resources/public/strings_resources.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget coolGadgetsCommunity() {

  return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage('images/cool_gadgets_community.jpg'),
            fit: BoxFit.cover
        ),
      ),
      constraints: const BoxConstraints(maxHeight: 1024, maxWidth: 1024),
      padding: const EdgeInsets.only(left: 37, right: 37),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
            onTap: () {

              launchUrl(Uri.parse(StringsResources.communityLink), mode: LaunchMode.externalApplication);

            },
            child: Container(
                constraints: const BoxConstraints(maxHeight: 1024, maxWidth: 1024),
                padding: const EdgeInsets.only(left: 37, right: 37),
                decoration: BoxDecoration(
                  color: ColorsResources.premiumDark.withOpacity(0.73),
                ),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                        StringsResources.joinCommunity,
                        style: const TextStyle(
                            fontSize: 37,
                            color: ColorsResources.premiumLight
                        )
                    )
                )
            )
        )
      )
  );
}