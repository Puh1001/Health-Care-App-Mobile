// avatar,name, dob, pn, w,h, bt, gender,pw

import 'dart:collection';
import 'dart:ffi';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:heathtrack/constants/utils.dart';
import 'package:heathtrack/providers/userProvider.dart';
import 'package:heathtrack/services/profileService.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'updateInfoView.dart';
import 'package:provider/provider.dart';

class UpdatePatientInfoView extends StatelessWidget {
  var patientId;
  var patientName;
  var patientPassword;
  UpdatePatientInfoView(
      {super.key,
      this.patientId,
      required this.patientName,
      required this.patientPassword});
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
          patientName: patientName,
          patientPassWord: patientPassword,
        ),
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  var patientId;
  var patientName;
  var patientPassWord;
  InputForm(
      {super.key,
      required this.patientId,
      required this.patientName,
      required this.patientPassWord});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();
  final ProfileService profileService = ProfileService();
  var profileData;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    fetchProfileData();
  }

  fetchProfileData() async {
    try {
      profileData = await profileService.fetchProfileData(
          context: context, userId: widget.patientId);
      if (mounted) {
        setState(() {});
      }
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  String formatDate = '';
  TextEditingController doBController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  List<String> bloodItems = ['A', 'B', 'AB', 'O'];
  String selectedBlood = '';
  List<String> sexItems = ['Male', 'Female', 'Other'];
  String selectedSex = '';
  DateTime? dateTime;
  bool _passwordVisible = true;
  List<File> image = [];

  void updateProfile() async {
    final cloudinary = CloudinaryPublic('ddvpwwiaj', 'qjers8b8');
    String imgUrl;
    CloudinaryResponse res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image[0].path, folder: "FileToURL"));
    imgUrl = res.secureUrl;
    profileService.updateProfile(
        context: context,
        gender: selectedSex.isEmpty ? profileData.gender : selectedSex,
        image: image.isEmpty ? profileData.image : imgUrl,
        dateOfBirth: doBController.text.isEmpty
            ? profileData.dateOfBirth
            : doBController,
        phoneNumber: phoneNumberController.text.isEmpty
            ? profileData.phoneNumber
            : phoneNumberController.text,
        weight: weightController.text.isEmpty
            ? profileData.weight
            : double.parse(weightController.text),
        height: heightController.text.isEmpty
            ? profileData.height
            : double.parse(heightController.text),
        userId: widget.patientId,
        bloodtype:
            selectedBlood.isEmpty ? profileData.bloodType : selectedBlood);
  }

  void selectImage() async {
    var res = await pickImage();
    setState(() {
      image = res;
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return profileData == null
        ? Center(child: errorView())
        : Container(
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
                    child: buildTextField90Width(nameController,
                        '${widget.patientName}', 'Name', TextInputType.number),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: buildDoB(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: buildTextField90Width(
                        phoneNumberController,
                        '${profileData.phoneNumber}',
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

  Widget errorView() {
    return Container(
      padding: EdgeInsets.only(bottom: 200),
      height: MediaQuery.of(context).size.height * 1,
      // decoration: BoxDecoration(
      //   color: Colors.black
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.crisis_alert,
            color: Colors.red,
            size: 70,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'This patient does not has any information !',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // padding:EdgeInsets.only(right: 8.0),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Go back',
                        style: TextStyle(fontSize: 15, color: Colors.redAccent),
                      )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlueAccent),
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.lightBlueAccent),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateInfoView(
                                    patientId: widget.patientId,
                                  )),
                        );
                      },
                      child: const Text(
                        'Add information now',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildTextField90Width(TextEditingController controller, String hint,
      String label, TextInputType keyboard) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        enabled: true,
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: "$hint",
          labelText: label,
        ),
        keyboardType: keyboard,
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
                child: image.isEmpty
                    ? Image.network(
                        profileData.image,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        image[0],
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () async {
                  selectImage();
                },
                icon: const Icon(
                  Icons.camera_alt,
                  size: 25,
                ),
                color: Colors.blueAccent,
              ),
            ),
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
          hintText: '${profileData.dateOfBirth}',
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
              ),
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
              value: profileData.bloodType,
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
                value: profileData.gender,
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
                updateProfile();
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
