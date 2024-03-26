import 'package:flutter/material.dart';
import 'package:heathtrack/models/user.dart';

import '../objects/patient.dart';
import '../objects/theme.dart';
import '../objects/watcher.dart';

class UserProvider extends ChangeNotifier {
  dynamic _user = User(
      id: "",
      name: '',
      email: '',
      password: '',
      familyCode: "",
      address: "",
      type: "",
      token: "");

  dynamic get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  setPatient() {
    Patient p = Patient(
        id: _user.id,
        name: _user.name,
        email: _user.email,
        password: _user.password,
        familyCode: _user.familyCode,
        address: _user.address,
        type: _user.type,
        token: _user.token,
        watcherId: '');
    _user = p;
    notifyListeners();
  }

  setWatcher() {
    Watcher w = Watcher(
        id: _user.id,
        name: _user.name,
        email: _user.email,
        password: _user.password,
        familyCode: _user.familyCode,
        address: _user.address,
        type: _user.type,
        token: _user.token,
        patientList: []);
    _user = w;
    notifyListeners();
  }

  var theme = MyColor();
  var lang = MyLanguage();
  bool settingDarkmode = false;
  bool settingLanguage = true;

  changeColor(bool isdark) {
    isdark ? theme.setDark() : theme.setLight();
    settingDarkmode = isdark;
    notifyListeners();
  }

  changeLang(bool isEng) {
    isEng ? lang.changeToEng() : lang.changeToVi();
    settingLanguage = isEng;
    notifyListeners();
  }
}
