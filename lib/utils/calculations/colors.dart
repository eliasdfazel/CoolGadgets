import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:flutter/material.dart';

Color calculateTextColor(Color inputColor) {

  return inputColor.computeLuminance() >= 0.5 ? ColorsResources.premiumDark : ColorsResources.premiumLight;
}