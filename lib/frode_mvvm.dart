library frode_mvvm;

import 'package:flutter/widgets.dart';
class BaseViewModel<M,S> with ChangeNotifier{
  M _mode;
  S _state;

  BaseViewModel(this._mode,this._state);

  M get mode => _mode;

  S get state => _state;
  set state(S value) {
    _state = value;
  }

  void changeMode(){
    notifyListeners();
  }
}
