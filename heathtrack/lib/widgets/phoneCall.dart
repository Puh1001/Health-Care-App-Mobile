import 'package:flutter/material.dart';
class PhoneCall extends StatelessWidget {
  IconData icon;
  String title;
  String number;
  final Function ontap;
  PhoneCall({super.key, required this.title, required this.number, this.icon = Icons.question_mark_rounded,required this.ontap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        ontap();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [BoxShadow(
            offset: const Offset(0,4),
            blurRadius: 10,
            color: Colors.black.withOpacity(0.1)
          )]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon,size: 60,color: Colors.red,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 20)),
                Text(number,style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.red
                ),)
              ],
            )
          ],
        ),
      ),
    );
  }
}
