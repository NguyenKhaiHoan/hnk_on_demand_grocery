import 'package:dvhcvn/dvhcvn.dart';
import 'package:get/get.dart';

class DemoData extends GetxController {
  int _latestChange = 1;
  int get latestChange => _latestChange;

  Level1 _level1 = const Level1('id', 'name', Type.quan, []);
  Level1 get level1 => _level1;
  set level1(Level1 v) {
    if (v == _level1) return;

    _level1 = v;
    _level2 = null;
    _level3 = null;
    _latestChange = 1;
  }

  Level2 _level2 = const Level2(0, 'id', 'name', Type.phuong, []);
  Level2 get level2 => _level2;
  set level2(Level2 v) {
    if (v == _level2) return;

    _level2 = v;
    _level3 = null;
    _latestChange = 2;
  }

  Level3 _level3;
  Level3 get level3 => _level3;
  set level3(Level3 v) {
    if (v == _level3) return;

    _level3 = v;
    _latestChange = 3;
  }
}
