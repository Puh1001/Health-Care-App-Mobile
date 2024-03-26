import 'package:flutter/material.dart';
import '../../k_services/diagnoseEngine.dart';
class CheckGlucoseLevel extends StatefulWidget {
  const CheckGlucoseLevel({super.key});

  @override
  State<CheckGlucoseLevel> createState() => _CheckGlucoseLevel();
}

class _CheckGlucoseLevel extends State<CheckGlucoseLevel> {
  var valueController = TextEditingController();
  String result = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check glucose level'),
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
                label: Text('Glucose level'),
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: (){

                setState(() {
                  result = DiagnosisEngine.diagnoseBloodGlucoseLevelIssue(double.parse(valueController.text));
                });
              },
              style: ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 50,vertical: 10)),
                backgroundColor: MaterialStatePropertyAll(Colors.purpleAccent),
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
