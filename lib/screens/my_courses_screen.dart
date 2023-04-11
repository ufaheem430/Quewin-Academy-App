import 'dart:async';
import 'package:academy_app/providers/my_courses.dart';
import 'package:academy_app/widgets/my_course_grid.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({Key? key}) : super(key: key);

  @override
  _MyCoursesScreenState createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
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
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Text(
                  'My Courses',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: Provider.of<MyCourses>(context, listen: false).fetchMyCourses(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  //error
                  return _connectionStatus == ConnectivityResult.none
                      ? Center(
                          child: Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * .15),
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
                                child: Text('Please check your Internet connection'),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          // child: Text('Error Occured'),
                          child: Text(dataSnapshot.error.toString()),
                        );
                } else {
                  return Consumer<MyCourses>(
                    builder: (context, myCourseData, child) =>
                        StaggeredGridView.countBuilder(
                      padding: const EdgeInsets.all(10.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      itemCount: myCourseData.items.length,
                      itemBuilder: (ctx, index) {
                        return MyCourseGrid(myCourse: myCourseData.items[index]);
                        // return Text(myCourseData.items[index].title);
                      },
                      staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
