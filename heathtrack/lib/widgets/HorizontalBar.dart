import 'package:flutter/material.dart';

class HorizontalBar extends StatelessWidget {
  final String label;
  final Icon icon;
  final Function ontap;
  HorizontalBar(this.icon,this.label, {required this.ontap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){ ontap();},
        child: Container(
          height: 60,
          margin: const EdgeInsets.only(top:15, left: 15, right:15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(
                color: Color(0xC7CACACA),
                blurRadius: 5,
                offset: Offset(0,3),
            ),]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              icon,
              Text(label),
              const Align(alignment: Alignment.centerRight,child: Icon(Icons.arrow_right_outlined),)
            ],
          ),
        )
    );
  }
}
