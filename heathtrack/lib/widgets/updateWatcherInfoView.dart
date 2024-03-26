import 'package:flutter/material.dart';
import 'package:heathtrack/constants/utils.dart';
import 'package:heathtrack/providers/userProvider.dart';
import 'package:heathtrack/services/profileService.dart';
import 'package:provider/provider.dart';
import '../constants/utils.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class UpdateWatcherInfoView extends StatelessWidget {
  var patientId;
  UpdateWatcherInfoView({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update watcher information'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: WatcherInputForm(
            patientId: Provider.of<UserProvider>(context).user.id),
      ),
    );
  }
}

class WatcherInputForm extends StatefulWidget {
  var patientId;
  WatcherInputForm({super.key, required this.patientId});

  @override
  State<WatcherInputForm> createState() => _WatcherInputFormState();
}

class _WatcherInputFormState extends State<WatcherInputForm> {
  final _formKey = GlobalKey<FormState>();
  String formatDate = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController doBController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  List<File> image = [];
  List<String> sexItems = ['Male', 'Female', 'Other'];
  String selectedSex = 'Male';
  DateTime? dateTime;
  final ProfileService profileService = ProfileService();

  void addProfile() {
    if (image != null) {
      profileService.addWatcherProfile(
        context: context,
        gender: selectedSex,
        image: image,
        dateOfBirth: doBController.text,
        phoneNumber: phoneNumberController.text,
        userId: widget.patientId,
      );
    }
  }

  //select image function
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
              child: buildTextField90Width(
                  nameController, 'name', 'Name', 'Name', TextInputType.text),
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
              child: buildTextField90Width(emailController, 'email', 'Email',
                  'Email', TextInputType.text),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: buildGenderField(),
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

  Widget buildGenderField() {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                labelText: 'Gender'),
            value: selectedSex,
            items: sexItems
                .map((item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)))
                .toList(),
            onChanged: (item) => setState(() => selectedSex = item!)),
      ),
    );
  }

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
                String name = nameController.text;
                String gender = genderController.text;
                String email = emailController.text;
                String doB = doBController.text;
                String phoneNumber = phoneNumberController.text;
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
                addProfile();
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
