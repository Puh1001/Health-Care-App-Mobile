
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../screens/watcherScreen/deviceScreen.dart';
class DeviceCard extends StatelessWidget {
  const DeviceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>DeviceScreen()));
      },
      child: Container(
        margin: EdgeInsets.only(top:30),
        padding: EdgeInsets.all(20),

        decoration: BoxDecoration(
            boxShadow: [BoxShadow(
                offset: Offset(0,4),
                blurRadius: 10,
                color: Colors.grey.shade300
            )],
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(width: 10,),
            const Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Device\'s name', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    Text('Owner: ABC',style: TextStyle(fontSize: 16),),
                    Row(
                      children: [
                        Icon(Icons.history),
                        Text('Update 30mins ago',style: TextStyle(fontSize: 16),),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
