import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heathtrack/constants/errorHandling.dart';
import 'package:heathtrack/constants/utils.dart';
import 'package:heathtrack/models/profile.dart';
import 'package:heathtrack/models/watcherProfile.dart';
import 'package:heathtrack/providers/userProvider.dart';
import 'package:heathtrack/services/authService.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProfileService {
  // ADD PROFILE PATIENT
  void addProfile({
    required BuildContext context,
    required String gender,
    required List<File> image,
    required String dateOfBirth,
    required String phoneNumber,
    required double weight,
    required double height,
    required String userId,
    required String bloodtype,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('ddvpwwiaj', 'qjers8b8');
      String imgUrl;
      CloudinaryResponse res = await cloudinary
          .uploadFile(CloudinaryFile.fromFile(image[0].path, folder: userId));
      imgUrl = res.secureUrl;

      Proflie proflie = Proflie(
        dateOfBirth: dateOfBirth,
        gender: gender,
        phoneNumber: phoneNumber,
        image: imgUrl,
        height: height,
        weight: weight,
        userId: userId,
        bloodType: bloodtype,
      );

      http.Response resp = await http.post(Uri.parse('$uri/api/add-profile'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: proflie.toJson());

      httpErrorHandle(
        response: resp,
        context: context,
        onSucess: () {
          showSnackBar(context, 'Patient profile change sucessfully !!');
          Navigator.pop(context);
        },
      );
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  Future<Proflie?> fetchProfileData({
    required BuildContext context,
    required userId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Proflie? profile;
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/get-profile?userId=$userId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () {
            dynamic data = jsonDecode(res.body);
            profile = Proflie(
              gender: data[0]['gender'],
              image: data[0]['image'],
              dateOfBirth: data[0]['dateOfBirth'],
              bloodType: data[0]['bloodType'],
              phoneNumber: data[0]['phoneNumber'],
              weight: double.parse(data[0]['weight'].toString()),
              height: double.parse(data[0]['height'].toString()),
              userId: userId,
            );
          });
    } catch (err) {
      showSnackBar(context, err.toString());
    }
    return profile;
  }

  // ADD WATCHER PROFILE
  void addWatcherProfile({
    required BuildContext context,
    required String gender,
    required List<File> image,
    required String dateOfBirth,
    required String phoneNumber,
    required String userId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('ddvpwwiaj', 'qjers8b8');
      String imgUrl;
      CloudinaryResponse res = await cloudinary
          .uploadFile(CloudinaryFile.fromFile(image[0].path, folder: userId));
      imgUrl = res.secureUrl;

      WatcherProflie proflie = WatcherProflie(
        dateOfBirth: dateOfBirth,
        gender: gender,
        phoneNumber: phoneNumber,
        image: imgUrl,
        userId: userId,
      );

      http.Response resp = await http.post(Uri.parse('$uri/api/add-profile'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          },
          body: proflie.toJson());

      httpErrorHandle(
        response: resp,
        context: context,
        onSucess: () {
          showSnackBar(context, 'Patient profile add sucessfully !!');
          Navigator.pop(context);
        },
      );
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  Future<List<WatcherProflie>> fetchWatcherProfileData({
    required BuildContext context,
    required userId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<WatcherProflie> watcherProfileList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/get-profile?userId=$userId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () {
            List<dynamic> data = jsonDecode(res.body);
            for (var profile in data) {
              watcherProfileList.add(WatcherProflie(
                gender: profile['gender'],
                image: profile['image'],
                dateOfBirth: profile['dateOfBirth'],
                phoneNumber: profile['phoneNumber'],
                userId: userId,
              ));
            }
          });
    } catch (err) {
      showSnackBar(context, err.toString());
    }
    return watcherProfileList;
  }

  //UPDATE GENDER
  void updateProfile({
    required BuildContext context,
    required String gender,
    required String image,
    required String dateOfBirth,
    required String phoneNumber,
    required double weight,
    required double height,
    required String userId,
    required String bloodtype,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      Proflie proflie = Proflie(
        dateOfBirth: dateOfBirth,
        gender: gender,
        phoneNumber: phoneNumber,
        image: image,
        height: height,
        weight: weight,
        userId: userId,
        bloodType: bloodtype,
      );

      http.Response resp =
          await http.patch(Uri.parse('$uri/api/update-profile?userId=$userId'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token,
              },
              body: proflie.toJson());

      httpErrorHandle(
        response: resp,
        context: context,
        onSucess: () {
          showSnackBar(context, 'Patient profile update sucessfully !!');
          Navigator.pop(context);
        },
      );
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  // UPDATE PHONENUMBER
  void updatePhoneNumberProfile({
    required BuildContext context,
    required String phoneNumber,
    required String userId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response resp =
          await http.patch(Uri.parse('$uri/api/update-profile?userId=$userId'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token,
              },
              body: jsonEncode({"phoneNumber": phoneNumber}));

      httpErrorHandle(
        response: resp,
        context: context,
        onSucess: () {
          showSnackBar(context, 'Your phone number update sucessfully !!');
        },
      );
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  // UPDATE BLOOD TYPE
  void updateBloodTypeProfile({
    required BuildContext context,
    required String bloodType,
    required String userId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response resp =
          await http.patch(Uri.parse('$uri/api/update-profile?userId=$userId'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token,
              },
              body: jsonEncode({"bloodType": bloodType}));

      httpErrorHandle(
        response: resp,
        context: context,
        onSucess: () {
          showSnackBar(context, 'Your blood type update sucessfully !!');
        },
      );
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  // UPDATE HEIGHT
  void updateHeightProfile({
    required BuildContext context,
    required double height,
    required String userId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response resp =
          await http.patch(Uri.parse('$uri/api/update-profile?userId=$userId'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token,
              },
              body: jsonEncode({"height": height}));

      httpErrorHandle(
        response: resp,
        context: context,
        onSucess: () {
          showSnackBar(context, 'Your blood type update sucessfully !!');
        },
      );
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  // UPDATE WEIGHT
  void updateWeightProfile({
    required BuildContext context,
    required double weight,
    required String userId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response resp =
          await http.patch(Uri.parse('$uri/api/update-profile?userId=$userId'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token,
              },
              body: jsonEncode({"weight": weight}));

      httpErrorHandle(
        response: resp,
        context: context,
        onSucess: () {
          showSnackBar(context, 'Your blood type update sucessfully !!');
        },
      );
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }
}
