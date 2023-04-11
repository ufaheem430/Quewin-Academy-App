import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/common_functions.dart';
import '../providers/categories.dart';
import '../providers/courses.dart';
import '../widgets/course_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;
  var topCourses = [];
  // var userData;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Courses>(context).fetchTopCourses().then((_) {
        setState(() {
          _isLoading = false;
          topCourses = Provider.of<Courses>(context, listen: false).topItems;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> refreshList() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Courses>(context, listen: false).fetchTopCourses();

      setState(() {
        _isLoading = false;
        topCourses = Provider.of<Courses>(context, listen: false).topItems;
      });
    } catch (error) {
      const errorMsg = 'Could not refresh!';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }

    return;
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseData = Provider.of<Courses>(context, listen: false).items;
    final courseCount = courseData.length;
    return RefreshIndicator(
      onRefresh: refreshList,
      child: SingleChildScrollView(
        child: FutureBuilder(
          future:
              Provider.of<Categories>(context, listen: false).fetchCategories(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * .5,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              if (dataSnapshot.error != null) {
                //error
                return _connectionStatus == ConnectivityResult.none
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .15),
                            Image.asset(
                              "assets/images/no_connection.png",
                              height: MediaQuery.of(context).size.height * .35,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text('There is no Internet connection'),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                              child:
                                  Text('Please check your Internet connection'),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: Text('Error Occured'),
                        // child: Text(dataSnapshot.error.toString()),
                      );
              } else {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'All Course',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(vertical: 0.0),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            height: MediaQuery.of(context).size.height * .8,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemBuilder: (ctx, index) {
                                return CourseGrid(
                                  id: courseData[index].id,
                                  title: courseData[index].title,
                                  thumbnail: courseData[index].thumbnail,
                                  rating: courseData[index].rating,
                                  price: courseData[index].price,
                                );
                              },
                              itemCount: courseCount,
                            ),
                          ),
                    //ToDO : If you want then Course Category Code is given below
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }
}

//Course Category Code
// IconButton(
//     onPressed: () async {
//       // Navigator.push(
//       //     context, MaterialPageRoute(builder: (_) => TimeLocker()));
//       await lockSystem(context);
//     },
//     icon: Icon(Icons.access_alarm_rounded)),
// Container(
//   width: double.infinity,
//   padding: const EdgeInsets.symmetric(
//       vertical: 10, horizontal: 20),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: <Widget>[
//       const Text(
//         'Course Categories',
//         style: TextStyle(
//             fontWeight: FontWeight.w600, fontSize: 18),
//       ),
//       MaterialButton(
//         onPressed: () {
//           Navigator.of(context).pushNamed(
//             CoursesScreen.routeName,
//             arguments: {
//               'category_id': null,
//               'seacrh_query': null,
//               'type': CoursesPageData.All,
//             },
//           );
//         },
//         child: Row(
//           children: const [
//             Text('All courses'),
//             Icon(
//               Icons.arrow_forward_ios_rounded,
//               color: iLongArrowRightColor,
//               size: 18,
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(0),
//       )
//     ],
//   ),
// ),
// Consumer<Categories>(
//   builder: (context, myCourseData, child) => Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20),
//     child: ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (ctx, index) {
//         return CategoryListItem(
//           id: myCourseData.items[index].id,
//           title: myCourseData.items[index].title,
//           thumbnail: myCourseData.items[index].thumbnail,
//           numberOfSubCategories: myCourseData
//               .items[index].numberOfSubCategories,
//         );
//       },
//       itemCount: myCourseData.items.length,
//     ),
//   ),
// ),
