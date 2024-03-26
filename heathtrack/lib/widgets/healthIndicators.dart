import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heathtrack/k_services/diagnoseEngine.dart';
import 'package:heathtrack/models/heathData.dart';
import 'package:heathtrack/providers/userProvider.dart';
import 'package:provider/provider.dart';
import '../screens/patientScreens/bloodPressureScreen.dart';
import '../screens/patientScreens/glucoseLevelScreen.dart';
import '../screens/patientScreens/heartRateScreen.dart';
import '../screens/patientScreens/oxygenScreen.dart';
import '../screens/patientScreens/temperatureScreen.dart';
import 'Metrics.dart';

class HealthIndicators extends StatelessWidget {
  HealthIndicators({super.key, required this.heathData, this.patientId});
  HeathData heathData;
  var patientId;
  var heartRateStatus = 0;
  var bloodPressureStatus = 0;
  var glucoseLevelStatus = 0;
  var oxygenStatus = 0;
  var temperatureStatus = 0;

  @override
  Widget build(BuildContext context) {
    heartRateStatus = DiagnosisEngine.diagnoseHeartRate(heathData.heartRate) ;
     bloodPressureStatus = DiagnosisEngine.diagnoseBloodPressure(heathData.spb, heathData.dbp);
     glucoseLevelStatus = DiagnosisEngine.diagnoseBloodSugar(double.parse(heathData.glucose.toString()));
     oxygenStatus = DiagnosisEngine.diagnoseOxygenLevel(heathData.oxygen);
     temperatureStatus = DiagnosisEngine.diagnoseTemperature(heathData.temperature);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Provider.of<UserProvider>(context).lang.healthIndicator,
          style: const TextStyle(
              fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 18),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Metrics(
              const Icon(
                FontAwesomeIcons.heartPulse,
                color: Colors.white,
                size: 35,
              ),
              Provider.of<UserProvider>(context).lang.heartRate,
              "${heathData.heartRate}",
              'bpm',
              problem: heartRateStatus,
              background: const Color(0xffD4F4DC),
              ontap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HeartRateScreen(
                            patientId: patientId ??
                                Provider.of<UserProvider>(context).user.id)));
              },
            ),
            const SizedBox(
              width: 15,
            ),
            Metrics(
              const Icon(
                FontAwesomeIcons.droplet,
                color: Colors.white,
                size: 40,
              ),
              "Blood\nPressure",
              "${heathData.spb}/${heathData.dbp}",
              'mmHg',
              problem: bloodPressureStatus,
              background: Color(0xffF7CECD),
              ontap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BloodPressureScreen(
                            patientId: patientId ??
                                Provider.of<UserProvider>(context).user.id)));
              },
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Metrics(
              const Icon(
                FontAwesomeIcons.o,
                color: Colors.white,
                size: 40,
              ),
              "Oxygen\nSaturation",
              "${heathData.oxygen}",
              '%',
              problem: oxygenStatus,
              background: Color(0xffD4E3F4),
              ontap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OxygenScreen(
                            patientId: patientId ??
                                Provider.of<UserProvider>(context).user.id)));
              },
            ),
            const SizedBox(
              width: 15,
            ),
            Metrics(
              const Icon(
                FontAwesomeIcons.temperatureFull,
                color: Colors.white,
                size: 40,
              ) as Icon,
              "Body\nTemperature",
              "${heathData.temperature}",
              '°C',
              problem: temperatureStatus,
              background: Color(0xffF4EDD4),
              ontap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TemperatureScreen(
                            patientId: patientId ??
                                Provider.of<UserProvider>(context).user.id)));
              },
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Metrics(
              const Icon(
                FontAwesomeIcons.g,
                color: Colors.white,
                size: 45,
              ),
              "Glucose\nlevel",
              "${heathData.glucose}",
              'mg/DL',
              problem: glucoseLevelStatus,
              background: Color(0xffDAD4F4),
              ontap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GlucoseLevelScreen(
                            patientId: patientId ??
                                Provider.of<UserProvider>(context).user.id)));
              },
            ),
            const SizedBox(
              width: 15,
            ),
            Metrics(
              const Icon(
                FontAwesomeIcons.personRunning,
                color: Colors.white,
                size: 50,
              ),
              Provider.of<UserProvider>(context).lang.activity,
              "${heathData.step}", //------------------------------------------need to fix-------------------------------------------------------------
              'steps',
              problem: -1,
              background: const Color(0xffD2D8DE),
              ontap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
