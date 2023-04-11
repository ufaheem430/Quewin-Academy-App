import 'dart:convert';
import 'package:academy_app/constants.dart';
import 'package:academy_app/models/category.dart';
import 'package:academy_app/models/sub_category.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    _getStateList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic DropDownList REST API'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(bottom: 100, top: 100),
            child: Text(
              'KDTechs',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
            ),
          ),
          //======================================================== State

          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _myState,
                        icon:  const Card(
                          elevation: 0.1,
                          color: kBackgroundColor,
                          child:
                          Icon(Icons.keyboard_arrow_down_outlined),
                        ),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Select State'),
                        onChanged: (newValue) {
                          setState(() {
                            _myState = newValue;
                            _getCitiesList();
                            print(_myState);
                          });
                        },
                        items: loadedCategories.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item.title.toString()),
                            value: item.id.toString(),
                          );
                        }).toList()
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),

          //======================================================== City

          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _myCity,
                        icon:  const Card(
                          elevation: 0.1,
                          color: kBackgroundColor,
                          child:
                          Icon(Icons.keyboard_arrow_down_outlined),
                        ),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: Text('Select City'),
                        onChanged: (newValue) {
                          setState(() {
                            _myCity = newValue;
                            print(_myCity);
                          });
                        },
                        items: loadedSubCategories.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item.title.toString()),
                            value: item.id.toString(),
                          );
                        }).toList()
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //=============================================================================== Api Calling here

//CALLING STATE API HERE
// Get State information by API
//   List? statesList;
  final List<Category> loadedCategories = [];
  String? _myState;

  String stateInfoUrl = BASE_URL + '/api/categories';
  Future<void> _getStateList() async {
    await http.get(Uri.parse(stateInfoUrl)).then((response) {
      var data = json.decode(response.body) as List;

      for (var catData in data) {
        loadedCategories.add(Category(
          id: int.parse(catData['id']),
          title: catData['name'],
          thumbnail: catData['thumbnail'],
          numberOfCourses: catData['number_of_courses'],
          numberOfSubCategories: catData['number_of_sub_categories'],
        ));

        // print(catData['name']);
      }

    });
  }

  // Get State information by API
  List? citiesList;
  String? _myCity;
  final List<SubCategory> loadedSubCategories = [];

  Future<void> _getCitiesList() async {
    String cityInfoUrl = BASE_URL + '/api/sub_categories/$_myState';
    await http.get(Uri.parse(cityInfoUrl)).then((response) {
      var data = json.decode(response.body) as List;

      for (var catData in data) {
        loadedSubCategories.add(SubCategory(
          id: int.parse(catData['id']),
          title: catData['name'],
          parent: int.parse(catData['parent']),
          numberOfCourses: catData['number_of_courses'],
        ));

        // print(catData['name']);
      }
    });
  }
}