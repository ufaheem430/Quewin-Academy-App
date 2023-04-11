import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../constants.dart';
import '../widgets/star_display_widget.dart';
import '../screens/my_course_detail_screen.dart';
import '../models/my_course.dart';
import '../widgets/custom_text.dart';

class MyCourseGrid extends StatelessWidget {
  final MyCourse? myCourse;

  const MyCourseGrid({
    Key? key,
    @required this.myCourse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(MyCourseDetailScreen.routeName, arguments: myCourse!.id);
      },
      child: SizedBox(
        width: double.infinity,
        // height: 400,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0.1,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/loading_animated.gif',
                      image: myCourse!.thumbnail.toString(),
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 5, right: 8, left: 8, top: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 42,
                      child: CustomText(
                        text: myCourse!.title!.length < 38
                            ? myCourse!.title
                            : myCourse!.title!.substring(0, 37),
                        fontSize: 14,
                        colors: kTextLightColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: StarDisplayWidget(
                              value: myCourse!.rating!.toInt(),
                              filledStar: const Icon(
                                Icons.star,
                                color: kStarColor,
                                size: 15,
                              ),
                              unfilledStar: const Icon(
                                Icons.star_border,
                                color: kStarColor,
                                size: 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: Text(
                              '( ${myCourse!.totalNumberRating}.0 )',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: LinearPercentIndicator(
                        lineHeight: 8.0,
                        percent: myCourse!.courseCompletion! / 100,
                        progressColor: kRedColor,
                        backgroundColor: kBackgroundColor,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomText(
                              text: '${myCourse!.courseCompletion}% Completed',
                              fontSize: 12,
                              colors: Colors.black54,
                            ),
                          ),
                          CustomText(
                            text:
                                '${myCourse!.totalNumberOfCompletedLessons}/${myCourse!.totalNumberOfLessons}',
                            fontSize: 12,
                            colors: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
