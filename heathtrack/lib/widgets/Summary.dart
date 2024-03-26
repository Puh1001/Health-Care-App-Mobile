import 'package:heathtrack/k_services/weatherAndLocation.dart';
import 'package:flutter/material.dart';

class SummaryWG extends StatefulWidget {
  final String diagnose;
  final String advice;
  const SummaryWG({
    super.key,
    required this.diagnose,
    required this.advice,
  });

  @override
  State<SummaryWG> createState() => _SummaryWGState();
}

class _SummaryWGState extends State<SummaryWG> {
  var _temp;
  var _des;
  String weatherImage = 'images/cloudy.png';
  WeatherAndLocationService myService = WeatherAndLocationService();

  @override
  void initState() {
    super.initState();
    getData(); // Gọi hàm getData trong initState để lấy dữ liệu khi widget được khởi tạo
  }

  Future<void> getData() async {
    try {
      var decodeData = await myService.getWeatherData();
      setState(() {
        _temp = decodeData['main']['temp'];
        _des = decodeData['weather'][0]['description'];
        weatherImage = getImageForWeatherCondition();
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching weather data: $e');
    }
  }

  String getImageForWeatherCondition() {
    if (_des.contains('clear')) {
      return 'images/sun.png';
    } else if (_des.contains('storm')) {
      return 'images/storm.png';
    } else if (_des.contains('rain')) {
      return 'images/raining.png';
    } else if (_des.contains('overcast')) {
      return 'images/gloomy.png';
    } else if (_des.contains('snow')) {
      return 'images/snow.png';
    } else {
      return 'images/cloudy.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          SingleChildScrollView(
            child: Container(
              // height: 200,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFDFEBEB),
                  //border: Border.all(color: Colors.white.withOpacity(0.5),width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (_temp == null)
                            ? const Text('loading...')
                            : Text(
                                '${_temp.toInt()}°C',
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset(weatherImage),
                        ),
                        Text(
                          _des == null ? '-----' : '$_des',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: 2,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.diagnose,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xff5eca79),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.advice,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
