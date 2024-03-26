import 'package:flutter/material.dart';

class Metrics extends StatelessWidget {
  final Icon icon;
  final String label;
  final String metric;
  final String unit;
  var problem = 0;
  var alertIcon;
  Color? background;
  Function? ontap;

  Metrics(this.icon, this.label, this.metric, this.unit,{required this.ontap, this.background, this.problem = 0});
  @override

  Widget build(BuildContext context) {
    if(problem==0) alertIcon = Icon(Icons.check_circle_outline,color: Colors.green,);
    else if(problem==1)alertIcon = Icon(Icons.warning,color: Color(0xfff0c531),);
    else if(problem ==2) alertIcon =Icon(Icons.dangerous_outlined,color: Colors.red,);
    else alertIcon = null;
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: (){
          ontap!();
          },
        child: Container(
          padding: EdgeInsets.only(top:20, left: 20, right:20, bottom: 15),
          height: 170,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
              boxShadow: const [BoxShadow(
                color: Color(0xC7CACACA),
                blurRadius: 8,
                offset: Offset(0,3),
              ),]
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [

              Positioned(bottom:0,right:0,child: Text(label,style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.grey,),textAlign: TextAlign.right,)),
              Positioned(bottom:0,left:0,child: icon),
              alertIcon==null?Container():Positioned(top:0,left:0,child: alertIcon),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(unit,style: const TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
                  const SizedBox(width: 10,),
                  Text(metric,style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold,),),
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}

