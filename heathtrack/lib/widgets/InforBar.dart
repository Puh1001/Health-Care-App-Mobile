import 'package:flutter/material.dart';
import 'package:heathtrack/providers/userProvider.dart';
import 'package:provider/provider.dart';

import '../objects/patient.dart';

class InforBar extends StatelessWidget {
  final List<Infor> list;
  final String groupName;
  const InforBar(this.groupName, this.list, {super.key});
  @override
  Widget build(BuildContext context) {
    Row line = Row(children: [
      Expanded(
          child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        height: 1,
        color: Colors.grey[300],
      ))
    ]);
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.0, bottom: 5),
            child: Text(
              groupName,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 8,
                      color: Colors.grey.withOpacity(0.3))
                ]),
            child: Column(
                children: list.map((e) {
              if (e == list[list.length - 1]) {
                return e;
              }
              return Column(
                children: [e, line],
              );
            }).toList()),
          )
        ],
      ),
    );
  }
}

class Infor extends StatelessWidget {
  final String property;
  String value;
  Function onTouch;
  bool canEdit = true;
  Infor(this.property, this.value,
      {super.key, this.canEdit = true, required this.onTouch});
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (BuildContext, patient, child) {
        return GestureDetector(
          onTap: () {
            onTouch();
            print(canEdit);
            // showDialog(context: context,
            //     builder: (BuildContext){
            //       TextEditingController contentController = TextEditingController();
            //       contentController.text = value;
            //       return AlertDialog(
            //         title: Text("Edit $property"),
            //         content: TextField(
            //           controller: contentController,
            //         ),
            //         actions: [
            //           TextButton(
            //               onPressed: (){
            //                 onTouch(contentController.text);
            //                 Navigator.of(context).pop();
            //               },
            //               child: Text("OK")),
            //           TextButton(
            //               onPressed: (){Navigator.of(context).pop();},
            //               child: Text("Cancel")),
            //         ],
            //       );
            //     });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            //decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3)))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    property,
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  canEdit
                      ? SizedBox(
                          child: Row(
                            children: [
                              Text(value,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 18)),
                              const Icon(
                                Icons.navigate_next,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        )
                      : Text(value,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 18)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
