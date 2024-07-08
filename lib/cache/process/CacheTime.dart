import 'package:cool_gadgets/cache/io/CacheIO.dart';

class CacheTime extends CacheIO {

  void store(contentValue) {

    storeContent('CachedTime', contentValue);

  }

  Future<int> retrieve() async {

    String storedTime = await retrieveContent('CachedTime') ?? '0';

    return int.parse(storedTime);
  }

  Future<bool> afterTime({int dayNumber = 7}) async {

    int daysSevenMilliseconds = (86400000 * dayNumber);

    int storedTime = await retrieve();

    int deltaTime = DateTime.now().millisecondsSinceEpoch - storedTime;

    return (deltaTime <= daysSevenMilliseconds);
  }

}