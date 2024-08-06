import 'package:cool_gadgets/cache/io/CacheIO.dart';
import 'package:flutter/cupertino.dart';

class CacheTime extends CacheIO {

  void store(String contentId, String contentValue) async {

    storeContent(contentId, contentValue);

  }

  Future<int> retrieve(String contentId) async {

    String storedTime = await retrieveContent(contentId) ?? '0';

    return int.parse(storedTime);
  }

  Future<bool> afterTime(String contentId, {int dayNumber = 7}) async {

    // 7 Days = 604800000
    int daysSevenMilliseconds = (86400000 * dayNumber);

    int storedTime = (await retrieve(contentId)).abs();

    int deltaTime = (DateTime.now().millisecondsSinceEpoch - storedTime).abs();
    debugPrint('Stored Time: $storedTime 🔺 Delta Time: $deltaTime');

    return (deltaTime < daysSevenMilliseconds);
  }

}