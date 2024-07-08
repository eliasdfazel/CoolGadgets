import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheIO {

  final Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();

  Future<String?> retrieveContent(String contentId) async {

    return (await sharedPreferences).getString(contentId);
  }

  Future storeContent(String contentId, String contentValue) async {

    sharedPreferences.then((value) async => {

      await value.setString(contentId, contentValue).then((value) => {
        debugPrint("$contentId Cached Successfully: $contentValue")
      })

    });

  }
}