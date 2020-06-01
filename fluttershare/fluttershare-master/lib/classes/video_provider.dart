import 'package:flutter/foundation.dart';

class VideoControl with ChangeNotifier{
  bool _isPlay = false;
  bool get isPlay => _isPlay;
  set isPlay(bool play){
    _isPlay = play;
    notifyListeners();
  }
}