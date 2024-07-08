import 'package:cool_gadgets/cache/io/CacheIO.dart';

class CacheTime extends CacheIO {

  void store(String contentId, String contentValue) {

    storeContent(contentId, contentValue);

  }

  Future<int> retrieve(String contentId) async {

    String storedTime = await retrieveContent(contentId) ?? '0';

    return int.parse(storedTime);
  }

  Future<bool> afterTime(String contentId, {int dayNumber = 7}) async {

    int daysSevenMilliseconds = (86400000 * dayNumber);

    int storedTime = await retrieve(contentId);

    int deltaTime = DateTime.now().millisecondsSinceEpoch - storedTime;

    return (deltaTime <= daysSevenMilliseconds);
  }

}