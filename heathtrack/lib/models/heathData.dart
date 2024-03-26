import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class HeathData {
  final int heartRate;
  final int spb;
  final int dbp;
  final double oxygen;
  final double temperature;
  final int glucose;
  final int step;
  final String timestamp;
  String? id;
  final String userId;
  HeathData({
    required this.heartRate,
    required this.spb,
    required this.dbp,
    required this.oxygen,
    required this.temperature,
    required this.glucose,
    required this.step,
    required this.timestamp,
    this.id,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'heartRate': heartRate,
      'spb': spb,
      'dbp': dbp,
      'oxygen': oxygen,
      'temperature': temperature,
      'glucose': glucose,
      'step': step,
      'timestamp': timestamp,
      'id': id,
      'userId': userId,
    };
  }

  factory HeathData.fromMap(Map<String, dynamic> map) {
    int heartRate = map['heartRate'] as int;
    // print(heartRate);
    int spb = map['spb'] as int;
    int dbp = map['dbp'] as int;
    String id = map['userId'] as String;
    String time = map['timestamp'] as String;
    double oxy = map['oxygen'] as double;
    // print(heartRate);

    HeathData heathData = HeathData(
      heartRate: heartRate,
      spb: spb,
      dbp: dbp,
      oxygen: 1,
      temperature: 1,
      glucose: 1,
      step: 11,
      timestamp: 'ddd',
      id: 'sdsd',
      userId: 'id',
      // oxygen: map['oxygen'] as double,
      // temperature: map['temperature'] as double,
      // glucose: map['glucose'] as int,
      // step: map['step'] as int,
      // timestamp: map['timestamp'] as String,
      // //id: map['id'] != null ? map['id'] as String : null,
      // userId: map['userId'] as String ,
    );
    // ignore: avoid_print
    print('step ${heathData.heartRate}');
    return heathData;
  }

  String toJson() => json.encode(toMap());

  factory HeathData.fromJson(String source) {
    // ignore: avoid_print
    print('jjjjjjjjjjjjjjjjj   ${HeathData.fromMap(json.decode(source))}');
    return HeathData.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
