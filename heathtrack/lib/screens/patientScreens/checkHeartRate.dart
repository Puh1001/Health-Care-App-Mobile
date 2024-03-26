import 'package:flutter/material.dart';
import '../../k_services/diagnoseEngine.dart';
class CheckHeartRate extends StatefulWidget {
  const CheckHeartRate({super.key});

  @override
  State<CheckHeartRate> createState() => _CheckHeartRate();
}

class _CheckHeartRate extends State<CheckHeartRate> {
  var valueController = TextEditingController();
  String result = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check heart rate'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 50,),
            TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text('Enter heart rate (bpm)'),
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: (){

                setState(() {
                  result = DiagnosisEngine.diagnoseHeartRateIssue(int.parse(valueController.text));
                });
              },
              style: ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 50,vertical: 10)),
                backgroundColor: MaterialStatePropertyAll(Colors.green),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
              ),
              child: const Text('Check',style: TextStyle(fontSize: 20),),
            ),

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
