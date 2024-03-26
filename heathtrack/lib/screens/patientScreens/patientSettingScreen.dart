import 'package:flutter/material.dart';
import 'package:heathtrack/providers/userProvider.dart';
import 'package:heathtrack/screens/Login/login_view.dart';
import 'package:heathtrack/services/accountServices.dart';
import 'package:provider/provider.dart';

class PatientSettingScreen extends StatelessWidget {
  const PatientSettingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (BuildContext context, watcher, child) {
        return Scaffold(
          backgroundColor: watcher.theme.backgroundColor1,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: watcher.theme.backgroundColor2,
            foregroundColor: watcher.theme.textColor1,
            title: Text(watcher.lang.settingTitle),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: watcher.theme.backgroundColor2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        watcher.lang.darkMode,
                        style: TextStyle(
                            fontSize: 17, color: watcher.theme.textColor1),
                      ),
                      Switch(
                          value: watcher.settingDarkmode,
                          onChanged: (isDark) {
                            watcher.changeColor(isDark);
                          })
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: watcher.theme.backgroundColor2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        watcher.lang.language,
                        style: TextStyle(
                            fontSize: 17, color: watcher.theme.textColor1),
                      ),
                      Switch(
                          value: watcher.settingLanguage,
                          onChanged: (isEng) {
                            watcher.changeLang(isEng);
                          })
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('You want to sign out ?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    AccountServices().logOut(context);
                                  },
                                  child: Text('OK')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'))
                            ],
                          );
                        });
                  },
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: watcher.theme.backgroundColor2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          watcher.lang.logOut,
                          style: TextStyle(
                              fontSize: 17, color: watcher.theme.textColor1),
                        ),
                        const Icon(
                          Icons.power_settings_new_outlined,
                          color: Colors.red,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
