import 'package:flutter/material.dart';

import '../../k_services/diagnoseEngine.dart';
class CheckBloodPressure extends StatefulWidget {
  const CheckBloodPressure({super.key});

  @override
  State<CheckBloodPressure> createState() => _CheckBloodPressure();
}

class _CheckBloodPressure extends State<CheckBloodPressure> {
  var ageController = TextEditingController();
  var sysController = TextEditingController();
  var diaController = TextEditingController();
  String result = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Blood pressure'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text('Age'),
              ),
            ),
            TextField(
              controller: sysController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text('Systolic Range'),
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: diaController,
              decoration: const InputDecoration(
                label: Text('Diastolic Range'),
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
                onPressed: (){

                  setState(() {
                    result = DiagnosisEngine.diagnoseBloodPressureIssue(int.parse(sysController.text),int.parse(diaController.text));
                  });
                },
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 50,vertical: 10)),
                backgroundColor: MaterialStatePropertyAll(Colors.red),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
              ),
                child: const Text('Check',style: TextStyle(fontSize: 20),),
            ),
            const SizedBox(width: 20,),
            const SizedBox(height: 30,),
            result.isEmpty?const Text(''):
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffededed)
                  ),
                  child: Column(
                    children: [
                      const Text('Result', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      Text(result,style: const TextStyle(fontSize: 20,overflow: TextOverflow.clip),)
                    ],
                  ),
                )
          ],
        ),
      ),
    );
  }
}
