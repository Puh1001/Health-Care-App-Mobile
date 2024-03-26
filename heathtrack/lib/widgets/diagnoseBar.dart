import 'package:flutter/material.dart';

class DiagnoseBar extends StatelessWidget {
  DiagnoseBar({super.key, required this.diagnose});
  String diagnose;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 3)),
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      //margin: EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Diagnosis:',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                diagnose,
                style: TextStyle(fontSize: 18),
              ),
            ],
      ),))
    );
  }
}
