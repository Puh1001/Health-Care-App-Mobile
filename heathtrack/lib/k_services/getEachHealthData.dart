import 'dart:ffi';

import 'package:heathtrack/models/heathData.dart';

class GetEachHealthData{

  List <Data> getListHeartRate(List<HeathData> listHeathData){
    List <Data> listHeartRate = [];
    for (var i in listHeathData){
      listHeartRate.add(Data(value: double.parse(i.heartRate.toString()), time: formatDate(i.timestamp)));
    }
     return listHeartRate;
  }
  List <Data> getListOxygen(List<HeathData> listHeathData){
    List <Data> listOxygen = [];
    for (var i in listHeathData){
      listOxygen.add(Data(value: double.parse(i.oxygen.toString()), time: formatDate(i.timestamp)));
    }
    return listOxygen;
  }
  List <Data> getListTemperature(List<HeathData> listHeathData){
    List <Data> listTemp = [];
    for (var i in listHeathData){
      listTemp.add(Data(value: double.parse(i.temperature.toString()), time: formatDate(i.timestamp)));
    }
    return listTemp;
  }
  List <Data> getListGlucose(List<HeathData> listHeathData){
    List <Data> listGlucose = [];
    for (var i in listHeathData){
      listGlucose.add(Data(value: double.parse(i.glucose.toString()), time: formatDate(i.timestamp)));
    }
    return listGlucose;
  }
  List<Data2> getListBloodPressure(List<HeathData> listHeathData){
    List <Data2> listBloodPressure = [];
    for (var i in listHeathData){
      listBloodPressure.add(Data2(val1: double.parse(i.spb.toString()),val2: double.parse(i.dbp.toString()), time: formatDate(i.timestamp)));
    }
    return listBloodPressure;
  }

  double formatDate(String timeString){
    double hour = double.parse(timeString.substring(11,13));
    double minute = double.parse(timeString.substring(14,16));
    double second = double.parse(timeString.substring(17,19));
    return hour + minute/60 + second/3600;
  }
}
class Data {
  double value;
  double time;
  Data({required this.value, required this.time});
}
class Data2 {
  double val1;
  double val2;
  double time;
  Data2({required this.val1,required this.val2, required this.time});
}
