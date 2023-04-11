import 'package:academy_app/providers/courses.dart';
import 'package:academy_app/widgets/app_bar_two.dart';
import 'package:academy_app/widgets/course_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class CoursesScreen extends StatefulWidget {
  static const routeName = '/courses';
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      final routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      final pageDataType = routeArgs['type'] as CoursesPageData;
      if (pageDataType == CoursesPageData.Category) {
        final categoryId = routeArgs['category_id'] as int;
        Provider.of<Courses>(context)
            .fetchCoursesByCategory(categoryId)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } else if (pageDataType == CoursesPageData.Search) {
        final searchQuery = routeArgs['seacrh_query'] as String;

        Provider.of<Courses>(context)
            .fetchCoursesBySearchQuery(searchQuery)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } else if (pageDataType == CoursesPageData.All) {
        Provider.of<Courses>(context)
            .filterCourses('all', 'all', 'all', 'all', 'all')
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseData = Provider.of<Courses>(context, listen: false).items;
    final courseCount = courseData.length;
    return Scaffold(
      appBar: CustomAppBarTwo(),
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Showing $courseCount Courses',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return Center(
                          child: CourseListItem(
                            id: courseData[index].id!.toInt(),
                            title: courseData[index].title.toString(),
                            thumbnail: courseData[index].thumbnail.toString(),
                            rating: courseData[index].rating!.toInt(),
                            price: courseData[index].price.toString(),
                            instructor: courseData[index].instructor.toString(),
                            noOfRating:
                                courseData[index].totalNumberRating!.toInt(),
                          ),
                        );
                      },
                      itemCount: courseData.length,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
