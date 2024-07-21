import 'package:flutter/material.dart';

Widget associatesBranding() {

  return Container(
    padding: const EdgeInsets.only(top: 37, bottom: 37),
    alignment: Alignment.center,
    child: SizedBox(
        height: 31,
        width: 177,
        child: Image.asset(
            'images/associate_branding.png'
        )
    )
  );
}