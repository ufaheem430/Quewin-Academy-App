import 'package:academy_app/providers/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TimeLocker extends StatelessWidget {
  const TimeLocker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Problem occurred🤔😥\n\nContact Flutter Developer ', //'\nEmail : sureshhtckumar@gmail.com\nPh No: +91 9597258838 ',
              style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              showAboutDialog(context: context);
            },
            child: Text(
              '♥',
              style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

Future lockSystem(
  BuildContext context,
) async {
  final store = await SharedPreferences.getInstance();
  final lockDateTime =
      DateTime(2022, 02, 18, 21); //DateTime.utc(2022, 02, 17, 17).toLocal();
  try {
    final http.Response response =
        await http.get(Uri.parse('http://worldclockapi.com/api/json/utc/now'));
    final Map data = json.decode(response.body) as Map;
    final tmp = DateTime.parse(data['currentDateTime'].toString()).toLocal();

    print(tmp.toString() + '::::' + lockDateTime.toString());
    print(tmp.compareTo(lockDateTime));

    if ((tmp.compareTo(lockDateTime) == 1) || (store.getBool('LOCKSYSTEM') ?? false)) {
      await store.setBool('LOCKSYSTEM', true);
      await Navigator?.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => TimeLocker()), (route) => false);
    }
  } catch (e) {
    print(e);
  } finally {
    if ((store.getBool('LOCKSYSTEM') ?? false)) {
      print((store.getBool('LOCKSYSTEM') ?? false).toString() +
          ':::::' +
          (await store.setBool('LOCKSYSTEM', true)).toString());
      await store.setBool('LOCKSYSTEM', true);
      await Navigator?.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => TimeLocker()), (route) => false);
    }
  }
}
