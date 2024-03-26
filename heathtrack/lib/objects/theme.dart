import 'dart:ui';

class MyColor{
  var textColor1 = Color(0xff000000);
  var textColor2 = Color(0xff696969);
  var textColor3 = Color(0xffffffff);
  var backgroundColor1 = Color(0xffeeeeee);
  var backgroundColor2 = Color(0xffffffff);
  var backgroundColor3 = Color(0xffffffff);

  setLight(){
    textColor1 = Color(0xff000000);
    textColor2 = Color(0xff696969);
    textColor3 = Color(0xffffffff);
    backgroundColor1 = Color(0xffeeeeee);
    backgroundColor2 = Color(0xffffffff);
    backgroundColor3 = Color(0xffffffff);
  }
  setDark(){
    textColor1 = Color(0xffffffff);
    textColor2 = Color(0xff696969);
    textColor3 = Color(0xff000000);
    backgroundColor1 = Color(0xff000000);
    backgroundColor2 = Color(0xff1c1c1c);
    backgroundColor3 = Color(0xffffffff);
  }
}
class MyLanguage{
  var settingTitle = 'Setting';
  var darkMode = 'Dark mode';
  var language = 'Language (Vie/Eng)';
  var logOut = 'Log out';
  var healthInformationTitle = 'Health information';
  var age = 'Age';
  var phoneNumber = 'Phone number';
  var diagnose = 'Diagnose';
  var good = 'Good';
  var heartRate = 'Heart rate';
  var bloodPressure = 'Blood presure';
  var oxygenSaturation = 'Oxygen Saturation';
  var bodyTemperature = 'Body temperature';
  var glucoseLevel = 'Glucose level';
  var activity = 'Activity';
  var noInformation = 'No information';
  var healthIndicator = 'Health indicators';


  changeToEng(){
    settingTitle = 'Setting';
    darkMode = 'Dark mode';
    language = 'Language (Vie/Eng)';
    logOut = 'Log out';
    healthInformationTitle = 'Health information';
    age = 'Age';
    phoneNumber = 'Phone number';
    diagnose = 'Diagnose';
    good = 'Good';
    heartRate = 'Heart rate';
    bloodPressure = 'Blood presure';
    oxygenSaturation = 'Oxygen Saturation';
    bodyTemperature = 'Body temperature';
    glucoseLevel = 'Glucose level';
    activity = 'Activity';
    noInformation = 'No information';
    healthIndicator = 'Health indicators';
  }
  changeToVi(){
    settingTitle = 'Cài đặt';
    darkMode = 'Chế độ tối';
    language = 'Ngôn ngữ (Việt/Anh)';
    logOut = 'Đăng xuất';
    healthInformationTitle = 'Thông tin sức khỏe';
    age = 'Tuổi';
    phoneNumber = 'SĐT';
    diagnose = 'Chẩn đoán';
    good = 'Tốt';
    heartRate = 'Nhịp tim';
    bloodPressure = 'Huyết áp';
    oxygenSaturation = 'Nồng độ Oxi';
    bodyTemperature = 'Nhiệt độ';
    glucoseLevel = 'Nồng độ đường huyết';
    activity = 'Hoạt động';
    noInformation = 'Không có thông tin';
    healthIndicator = 'Các thông số sức khỏe';
  }
}