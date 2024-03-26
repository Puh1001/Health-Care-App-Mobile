import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:heathtrack/constants/utils.dart';
import 'package:heathtrack/providers/userProvider.dart';
import 'package:heathtrack/screens/watcherScreen/watcherControlScreen.dart';
import 'package:heathtrack/screens/watcherScreen/watcherHomeScreen.dart';
import 'package:heathtrack/services/profileService.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class UpdateInfoView extends StatelessWidget {
  var patientId;
  UpdateInfoView({super.key, required this.patientId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Information'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: InputForm(
          patientId: patientId ?? Provider.of<UserProvider>(context).user.id,
        ),
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  var patientId;
  InputForm({super.key, required this.patientId});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();
  final ProfileService profileService = ProfileService();

  String formatDate = '';
  TextEditingController doBController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  List<File> image = [];
  List<String> bloodItems = ['A', 'B', 'AB', 'O'];
  String selectedBlood = 'O';
  List<String> sexItems = ['Male', 'Female', 'Other'];
  String selectedSex = 'Male';
  DateTime? dateTime;

  void addProfile() {
    if (image.isNotEmpty) {
      profileService.addProfile(
          context: context,
          gender: selectedSex,
          image: image,
          dateOfBirth: doBController.text,
          phoneNumber: phoneNumberController.text,
          weight: double.parse(weightController.text),
          height: double.parse(heightController.text),
          userId: widget.patientId,
          bloodtype: selectedBlood);
    }
  }

  void selectImage() async {
    var res = await pickImage();
    setState(() {
      image = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: buildAvatar(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: buildDoB(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: buildTextField90Width(
                  phoneNumberController,
                  'phone number',
                  'Phone number',
                  'Phone number',
                  TextInputType.number),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: buildHeightAndWeight(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: buildBloodAndSex(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: buildButton(),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            firstDate: DateTime(1930),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        dateTime = value!;
        formatDate = DateFormat('dd/MM/yyyy').format(dateTime!);
        doBController.text = formatDate;
      });
    });
  }

  Widget buildTextField90Width(TextEditingController controller, String hint,
      String label, String valid, TextInputType keyboard) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: "Type patient $hint here",
          labelText: label,
        ),
        keyboardType: keyboard,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$valid is required';
          }
          return null;
        },
      ),
    );
  }

  Widget buildAvatar() {
    return CircleAvatar(
      radius: 80,
      child: CircleAvatar(
        radius: 75,
        backgroundColor: Colors.white,
        child: Stack(
          children: [
            SizedBox(
                height: 150,
                width: 150,
                child: ClipOval(
                    child: image.isNotEmpty
                        ? Builder(
                            builder: (BuildContext context) => Image.file(
                              image[0],
                              fit: BoxFit.cover,
                            ),
                          )
                        : Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: () {
                                selectImage();
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 50,
                              ),
                              color: Colors.grey,
                            ),
                          ))),
          ],
        ),
      ),
    );
  }

  Widget buildDoB() {
    return TextFormField(
      controller: doBController,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Date of birth',
          hintText: 'Tap the icon to choose',
          suffixIcon: IconButton(
              onPressed: () {
                _showDatePicker();
              },
              icon: const Icon(Icons.calendar_month_outlined))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Date of birth is required';
        }
        return null;
      },
      readOnly: true,
      enabled: true,
    );
  }

  Widget buildHeightAndWeight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: TextFormField(
                  controller: weightController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Weight',
                      labelText: 'Weight'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  }),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Text('(kg)', style: TextStyle(fontSize: 20)),
            )
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: TextFormField(
                  controller: heightController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Height',
                      labelText: 'Height'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  }),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Text('(cm)', style: TextStyle(fontSize: 20)),
            )
          ],
        )
      ],
    );
  }

  Widget buildBloodAndSex() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelText: 'Blood type',
              ),
              value: selectedBlood,
              items: bloodItems
                  .map((item) =>
                      DropdownMenuItem<String>(value: item, child: Text(item)))
                  .toList(),
              onChanged: (item) => setState(() => selectedBlood = item!)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 100.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelText: 'Gender'),
                value: selectedSex,
                items: sexItems
                    .map((item) => DropdownMenuItem<String>(
                        value: item, child: Text(item)))
                    .toList(),
                onChanged: (item) => setState(() => selectedSex = item!)),
          ),
        )
      ],
    );
  }

  //xây dựng nút hủy cập nhật và nút lưu
  Widget buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.35,
          height: 55,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 20, color: Colors.redAccent),
              )),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.35,
          height: 55,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlueAccent),
              borderRadius: BorderRadius.circular(25),
              color: Colors.lightBlueAccent),
          child: TextButton(
              onPressed: () {
                // String doB = formatDate!;
                String doB = doBController.text;
                String phoneNumber = phoneNumberController.text;
                String height = heightController.text;
                String weight = weightController.text;
                String sex = sexController.text;
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  addProfile();
                }
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WatcherControlScreen()));
              },
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
        )
      ],
    );
  }
}
