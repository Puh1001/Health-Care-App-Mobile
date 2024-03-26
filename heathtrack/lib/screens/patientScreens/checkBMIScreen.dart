import 'package:flutter/material.dart';

import '../../k_services/diagnoseEngine.dart';
class CheckBMIScreen extends StatefulWidget {
  const CheckBMIScreen({super.key});

  @override
  State<CheckBMIScreen> createState() => _CheckBMIScreen();
}

class _CheckBMIScreen extends State<CheckBMIScreen> {
  var hController = TextEditingController();
  var wController = TextEditingController();
  String result = '';
  double? bmi;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check BMI'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50,),
            TextField(
              controller: hController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text('Height'),
              ),
            ),
            TextField(
              controller: wController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text('Weight'),
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: (){
                bmi = DiagnosisEngine.calculateBMI(double.parse(wController.text), double.parse(hController.text));
                setState(() {

                  result = DiagnosisEngine.diagnoseBMI(bmi!);
                });
              },
              style: ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 50,vertical: 10)),
                backgroundColor: MaterialStatePropertyAll(Colors.blueGrey),
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
                  color: Color(0xffededed)
              ),
              child: Column(
                children: [
                  const Text('Result', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  Text('$bmi',style: TextStyle(fontSize: 20),),
                  Text(result,style: TextStyle(fontSize: 20,overflow: TextOverflow.clip),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
