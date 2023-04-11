import 'package:academy_app/models/common_functions.dart';
import 'package:academy_app/providers/shared_pref_helper.dart';
import 'package:academy_app/widgets/util.dart';
import 'package:academy_app/widgets/vimeo_player_widget.dart';
import 'package:academy_app/widgets/youtube_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../providers/courses.dart';
import '../widgets/app_bar_two.dart';
import 'temp_view_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  static const routeName = '/course-details';
  const CourseDetailScreen({Key? key}) : super(key: key);

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  var _isInit = true;
  bool _isAuth = false;
  var _isLoading = false;
  String? _authToken;
  var loadedCourseDetail;
  var courseId;
  var _url;
  int? selected;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url, forceSafariVC: false)
      : throw 'Could not launch $_url';

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      var token = await SharedPreferenceHelper().getAuthToken();
      setState(() {
        _isLoading = true;
        // _authToken = Provider.of<Auth>(context, listen: false).token;
        if (token != null && token.isNotEmpty) {
          _isAuth = true;
        } else {
          _isAuth = false;
        }
      });

      courseId = ModalRoute.of(context)!.settings.arguments as int;

      Provider.of<Courses>(context, listen: false)
          .fetchCourseDetailById(courseId)
          .then((_) {
        loadedCourseDetail =
            Provider.of<Courses>(context, listen: false).getCourseDetail;
        final activeCourse =
            Provider.of<Courses>(context, listen: false).findById(courseId);
        setState(() {
          _isLoading = false;
          _url = activeCourse.courseOverviewUrl;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _showYoutubeModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return YoutubePlayerWidget(
          videoUrl: _url.toString(),
          newKey: UniqueKey(),
        );
      },
    );
  }

  void _showVimeoModal(BuildContext ctx, vimeoVideoId) {
    // print(loadedCourse.vimeoVideoId);
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return VimeoPlayerWidget(
          videoId: vimeoVideoId,
          newKey: UniqueKey(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseId = ModalRoute.of(context)!.settings.arguments as int;
    final loadedCourse = Provider.of<Courses>(
      context,
      listen: false,
    ).findById(courseId);
    return Scaffold(
      appBar: CustomAppBarTwo(),
      backgroundColor: kBackgroundColor,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<Courses>(
              builder: (context, courses, child) {
                final loadedCourseDetail = courses.getCourseDetail;
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Stack(
                          fit: StackFit.loose,
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height / 3.3,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.6),
                                          BlendMode.dstATop),
                                      image: NetworkImage(
                                        loadedCourse.thumbnail.toString(),
                                      ),
                                    )),
                              ),
                            ),
                            ClipOval(
                              child: InkWell(
                                onTap: () {
                                  if (loadedCourse.courseOverviewProvider ==
                                      'vimeo') {
                                    String vimeoVideoId = loadedCourse
                                        .courseOverviewUrl!
                                        .split('/')
                                        .last;
                                    _showVimeoModal(context, vimeoVideoId);
                                  } else if (loadedCourse
                                          .courseOverviewProvider ==
                                      'html5') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TempViewScreen(
                                              videoUrl: loadedCourse
                                                  .courseOverviewUrl)),
                                    );
                                  } else {
                                    if (loadedCourse
                                        .courseOverviewProvider!.isEmpty) {
                                      CommonFunctions.showSuccessToast(
                                          'Video url not provided');
                                    } else {
                                      _showYoutubeModal(context);
                                    }
                                  }
                                },
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [kDefaultShadow],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.asset(
                                      'assets/images/play.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -15,
                              right: 20,
                              child: SizedBox(
                                height: 45,
                                width: 45,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      if (_isAuth) {
                                        var msg =
                                            loadedCourseDetail.isWishlisted;
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              buildPopupDialogWishList(
                                                  context,
                                                  loadedCourseDetail
                                                      .isWishlisted,
                                                  loadedCourse.id,
                                                  msg),
                                        );
                                      } else {
                                        CommonFunctions.showSuccessToast(
                                            'Please login first');
                                      }
                                    },
                                    tooltip: 'Wishlist',
                                    child: Icon(
                                      loadedCourseDetail.isWishlisted!
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    backgroundColor: kRedColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text: loadedCourse.title,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 1,
                              child: Text(''),
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       vertical: 10, horizontal: 15),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: <Widget>[
                      //       Padding(
                      //         padding: const EdgeInsets.only(
                      //           right: 10,
                      //         ),
                      //         child: StarDisplayWidget(
                      //           value: loadedCourse.rating!.toInt(),
                      //           filledStar: const Icon(
                      //             Icons.star,
                      //             color: kStarColor,
                      //             size: 18,
                      //           ),
                      //           unfilledStar: const Icon(
                      //             Icons.star_border,
                      //             color: kStarColor,
                      //             size: 18,
                      //           ),
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding: const EdgeInsets.only(right: 10),
                      //         child: Text(
                      //           '( ${loadedCourse.rating}.0 )',
                      //           style: const TextStyle(
                      //             fontSize: 11,
                      //             color: kTextColor,
                      //           ),
                      //         ),
                      //       ),
                      //       CustomText(
                      //         text: '${loadedCourse.totalNumberRating}+ Rating',
                      //         fontSize: 11,
                      //         colors: kTextColor,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                            right: 15, left: 15, top: 0, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Container(),
                              // child: CustomText(
                              //   //TODO free suresh
                              //   text: loadedCourse.price.toString(),
                              //   fontSize: 24,
                              //   fontWeight: FontWeight.w400,
                              //   colors: kTextColor,
                              // ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.share,
                                color: kSecondaryColor,
                              ),
                              tooltip: 'Share',
                              onPressed: () {
                                Share.share(
                                    loadedCourse.shareableLink.toString());
                              },
                            ),
                            MaterialButton(
                              onPressed: () async {
                                _authToken = await SharedPreferenceHelper()
                                    .getAuthToken();
                                if (!loadedCourseDetail.isPurchased!) {
                                  if (_authToken != null) {
                                    if (loadedCourse.isFreeCourse == '1') {
                                      // final _url = BASE_URL + '/api/enroll_free_course?course_id=$courseId&auth_token=$_authToken';
                                      Provider.of<Courses>(context,
                                              listen: false)
                                          .getEnrolled(courseId)
                                          .then((_) =>
                                              CommonFunctions.showSuccessToast(
                                                  'Enrolled Successfully'));
                                    } else {
                                      final _url = BASE_URL +
                                          '/api/web_redirect_to_buy_course/$_authToken/$courseId/academybycreativeitem';
                                      _launchURL(_url);
                                    }
                                  } else {
                                    CommonFunctions.showSuccessToast(
                                        'Please login first');
                                  }
                                }
                              },
                              child: Text(
                                loadedCourseDetail.isPurchased!
                                    ? 'Purchased'
                                    : loadedCourse.isFreeCourse == '1'
                                        ? 'Get Enroll'
                                        : 'Buy Now',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16),
                              ),
                              color: loadedCourseDetail.isPurchased!
                                  ? kGreenPurchaseColor
                                  : kRedColor,
                              textColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              splashColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                // side: BorderSide(color: kBlueColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SingleChildScrollView(
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 10),
                      //         child: Card(
                      //           elevation: 0,
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           child: Column(
                      //             children: [
                      //               SizedBox(
                      //                 width: double.infinity,
                      //                 child: TabBar(
                      //                   controller: _tabController,
                      //                   indicatorSize: TabBarIndicatorSize.tab,
                      //                   indicator: BoxDecoration(
                      //                       borderRadius:
                      //                           BorderRadius.circular(10),
                      //                       color: kRedColor),
                      //                   unselectedLabelColor: kTextColor,
                      //                   padding: const EdgeInsets.all(10),
                      //                   labelColor: Colors.white,
                      //                   tabs: const <Widget>[
                      //                     /*Tab(
                      //                       child: Text(
                      //                         "Includes",
                      //                         style: TextStyle(
                      //                           fontWeight: FontWeight.bold,
                      //                           fontSize: 11,
                      //                         ),
                      //                       ),
                      //                     ),*/
                      //                     // Tab(
                      //                     //   child: Align(
                      //                     //     alignment: Alignment.center,
                      //                     //     child: Text(
                      //                     //       "Outcomes",
                      //                     //       style: TextStyle(
                      //                     //         fontWeight: FontWeight.bold,
                      //                     //         fontSize: 11,
                      //                     //       ),
                      //                     //     ),
                      //                     //   ),
                      //                     // ),
                      //                     // Tab(
                      //                     //   child: Align(
                      //                     //     alignment: Alignment.center,
                      //                     //     child: Text(
                      //                     //       "Requirements",
                      //                     //       style: TextStyle(
                      //                     //         fontWeight: FontWeight.bold,
                      //                     //         fontSize: 10,
                      //                     //       ),
                      //                     //     ),
                      //                     //   ),
                      //                     // ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               // Container(
                      //               //   width: double.infinity,
                      //               //   height: 300,
                      //               //   padding: const EdgeInsets.only(
                      //               //       right: 10,
                      //               //       left: 10,
                      //               //       top: 0,
                      //               //       bottom: 10),
                      //               //   child: TabBarView(
                      //               //     controller: _tabController,
                      //               //     children: [
                      //               //       /*TabViewDetails(
                      //               //         titleText: 'What is Included',
                      //               //         listText: loadedCourseDetail.courseIncludes,
                      //               //       ),*/
                      //               //       TabViewDetails(
                      //               //         titleText: 'What you will learn',
                      //               //         listText: loadedCourseDetail
                      //               //             .courseOutcomes,
                      //               //       ),
                      //               //       TabViewDetails(
                      //               //         titleText: 'Course Requirements',
                      //               //         listText: loadedCourseDetail
                      //               //             .courseRequirements,
                      //               //       ),
                      //               //     ],
                      //               //   ),
                      //               // ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //       const Padding(
                      //         padding: EdgeInsets.symmetric(
                      //             vertical: 10, horizontal: 20),
                      //         child: CustomText(
                      //           text: 'Course Curriculum',
                      //           fontSize: 20,
                      //           fontWeight: FontWeight.w400,
                      //           colors: kDarkGreyColor,
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 15.0),
                      //         child: ListView.builder(
                      //           key: Key(
                      //               'builder ${selected.toString()}'), //attention
                      //           shrinkWrap: true,
                      //           physics: const NeverScrollableScrollPhysics(),
                      //           itemCount: loadedCourseDetail.mSection!.length,
                      //           itemBuilder: (ctx, index) {
                      //             final section =
                      //                 loadedCourseDetail.mSection![index];
                      //             return Card(
                      //               elevation: 0.3,
                      //               child: ExpansionTile(
                      //                 key: Key(index.toString()), //attention
                      //                 initiallyExpanded: index == selected,
                      //                 onExpansionChanged: ((newState) {
                      //                   if (newState) {
                      //                     setState(() {
                      //                       selected = index;
                      //                     });
                      //                   } else {
                      //                     setState(() {
                      //                       selected = -1;
                      //                     });
                      //                   }
                      //                 }), //attention
                      //                 title: Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     Align(
                      //                       alignment: Alignment.centerLeft,
                      //                       child: Padding(
                      //                         padding:
                      //                             const EdgeInsets.symmetric(
                      //                           vertical: 5.0,
                      //                         ),
                      //                         child: CustomText(
                      //                           text: HtmlUnescape().convert(
                      //                               section.title.toString()),
                      //                           colors: kDarkGreyColor,
                      //                           fontSize: 16,
                      //                           fontWeight: FontWeight.w400,
                      //                         ),
                      //                       ),
                      //                     ),
                      //                     Padding(
                      //                       padding: const EdgeInsets.symmetric(
                      //                           vertical: 5.0),
                      //                       child: Row(
                      //                         children: [
                      //                           Expanded(
                      //                             flex: 1,
                      //                             child: Container(
                      //                               decoration: BoxDecoration(
                      //                                 color: kTimeBackColor,
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(
                      //                                         3),
                      //                               ),
                      //                               padding: const EdgeInsets
                      //                                   .symmetric(
                      //                                 vertical: 5.0,
                      //                               ),
                      //                               child: Align(
                      //                                 alignment:
                      //                                     Alignment.center,
                      //                                 child: CustomText(
                      //                                   text: section
                      //                                       .totalDuration,
                      //                                   fontSize: 10,
                      //                                   colors: kTimeColor,
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           const SizedBox(
                      //                             width: 10.0,
                      //                           ),
                      //                           Expanded(
                      //                             flex: 1,
                      //                             child: Container(
                      //                               decoration: BoxDecoration(
                      //                                 color: kLessonBackColor,
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(
                      //                                         3),
                      //                               ),
                      //                               padding: const EdgeInsets
                      //                                   .symmetric(
                      //                                 vertical: 5.0,
                      //                               ),
                      //                               child: Align(
                      //                                 alignment:
                      //                                     Alignment.center,
                      //                                 child: Container(
                      //                                   decoration:
                      //                                       BoxDecoration(
                      //                                     color:
                      //                                         kLessonBackColor,
                      //                                     borderRadius:
                      //                                         BorderRadius
                      //                                             .circular(3),
                      //                                   ),
                      //                                   child: CustomText(
                      //                                     text:
                      //                                         '${section.mLesson!.length} Lessons',
                      //                                     fontSize: 10,
                      //                                     colors:
                      //                                         kDarkGreyColor,
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           const Expanded(
                      //                               flex: 2, child: Text("")),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 children: [
                      //                   ListView.builder(
                      //                     shrinkWrap: true,
                      //                     physics:
                      //                         const NeverScrollableScrollPhysics(),
                      //                     itemBuilder: (ctx, index) {
                      //                       return LessonListItem(
                      //                         lesson: section.mLesson![index],
                      //                       );
                      //                     },
                      //                     itemCount: section.mLesson!.length,
                      //                   ),
                      //                 ],
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //         // child: ExpansionPanelList.radio(
                      //         //   elevation: 0,
                      //         //   expandedHeaderPadding: EdgeInsets.all(0),
                      //         //   // animationDuration: Duration(milliseconds: 800),
                      //         //   dividerColor: kBackgroundColor,
                      //         //   children: loadedCourseDetail.mSection!.map<ExpansionPanelRadio>((section) {
                      //         //     // var index = loadedCourseDetail.mSection!.indexOf(section);
                      //         //     return ExpansionPanelRadio(
                      //         //       value: section.id!,
                      //         //       canTapOnHeader: true,
                      //         //       headerBuilder: (BuildContext context, bool isExpanded) {
                      //         //         return Padding(
                      //         //           padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                      //         //           child: Column(
                      //         //             crossAxisAlignment: CrossAxisAlignment.start,
                      //         //             children: [
                      //         //               Align(
                      //         //                 alignment: Alignment.centerLeft,
                      //         //                 child: Padding(
                      //         //                   padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                      //         //                   child: CustomText(
                      //         //                     text: HtmlUnescape().convert(
                      //         //                         section.title.toString()),
                      //         //                     colors: kDarkGreyColor,
                      //         //                     fontSize: 16,
                      //         //                     fontWeight: FontWeight.w400,
                      //         //                   ),
                      //         //                 ),
                      //         //               ),
                      //         //               Padding(
                      //         //                 padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                      //         //                 child: Row(
                      //         //                   children: [
                      //         //                     Expanded(
                      //         //                       flex: 1,
                      //         //                       child: Container(
                      //         //                         decoration: BoxDecoration(
                      //         //                           color: kTimeBackColor,
                      //         //                           borderRadius:
                      //         //                           BorderRadius.circular(3),
                      //         //                         ),
                      //         //                         padding: const EdgeInsets.all(5.0),
                      //         //                         child: Align(
                      //         //                           alignment: Alignment.center,
                      //         //                           child: CustomText(
                      //         //                             text: section.totalDuration,
                      //         //                             fontSize: 10,
                      //         //                             colors: kTimeColor,
                      //         //                           ),
                      //         //                         ),
                      //         //                       ),
                      //         //                     ),
                      //         //                     SizedBox(width: 10.0,),
                      //         //                     Expanded(
                      //         //                       flex: 1,
                      //         //                       child: Container(
                      //         //                         decoration: BoxDecoration(
                      //         //                           color: kLessonBackColor,
                      //         //                           borderRadius:
                      //         //                           BorderRadius.circular(3),
                      //         //                         ),
                      //         //                         padding: const EdgeInsets.all(5.0),
                      //         //                         child: Align(
                      //         //                           alignment: Alignment.center,
                      //         //                           child: Container(
                      //         //                             decoration: BoxDecoration(
                      //         //                               color: kLessonBackColor,
                      //         //                               borderRadius:
                      //         //                               BorderRadius.circular(3),
                      //         //                             ),
                      //         //                             child: CustomText(
                      //         //                               text:
                      //         //                               '${section.mLesson!.length} Lessons',
                      //         //                               fontSize: 10,
                      //         //                               colors: kDarkGreyColor,
                      //         //                             ),
                      //         //                           ),
                      //         //                         ),
                      //         //                       ),
                      //         //                     ),
                      //         //                     Expanded(flex: 2, child: Text("")),
                      //         //                   ],
                      //         //                 ),
                      //         //               ),
                      //         //
                      //         //             ],
                      //         //           ),
                      //         //         );
                      //         //       },
                      //         //       body: ListView.builder(
                      //         //         shrinkWrap: true,
                      //         //         physics: const NeverScrollableScrollPhysics(),
                      //         //         itemBuilder: (ctx, index) {
                      //         //           return LessonListItem(
                      //         //             lesson: section.mLesson![index],
                      //         //           );
                      //         //         },
                      //         //         itemCount: section.mLesson!.length,
                      //         //       ),
                      //         //     );
                      //         //   }).toList(),
                      //         // ),
                      //       ),
                      //       SizedBox(
                      //         height: 10,
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
