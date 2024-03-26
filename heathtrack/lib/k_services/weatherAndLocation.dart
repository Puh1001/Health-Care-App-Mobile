
import 'dart:convert';
import 'package:heathtrack/objects/hospital.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
class WeatherAndLocationService{
   Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }


   Future<Map<String, dynamic>> getWeatherData() async {
     Position position = await getCurrentLocation();
     final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=b047bdc31b1d4427efa55434079fc069&units=metric'));
     if (response.statusCode == 200) {
       return json.decode(response.body);
     } else {
       throw Exception('Failed to load weather data');
     }
   }
   Future <List<Hospital>> getNearbyHospitals(double lat, double lon) async {

     final response = await http.get(
       Uri.parse('https://nominatim.openstreetmap.org/search.php?format=json&q=b%E1%BB%87nh%20vi%E1%BB%87n&lat=$lat&lon=$lon&zoom=15&addressdetails=1'),
     );

     if (response.statusCode == 200) {
       List<dynamic> data = jsonDecode(response.body);
       List<Hospital> hospitals = [];

       for (var hospitalData in data) {
         hospitals.add(Hospital(
           name: hospitalData['display_name'] ?? '',
           address: hospitalData['address']['hospital'] ?? hospitalData['address']['road'] ?? '',
           lat: double.parse(hospitalData['lat']),
           long: double.parse(hospitalData['lon']),
         ));
       }
       return hospitals;
     } else {
       throw Exception('Failed to load nearby hospitals');
     }
   }


}
