import 'package:flutter/material.dart';
import '../models/lesson.dart';

class LessonListItem extends StatelessWidget {
  final Lesson? lesson;

  const LessonListItem({Key? key, @required this.lesson}) : super(key: key);

  IconData getLessonIcon(String lessonType) {
    // print(lessonType);
    if (lessonType == 'video') {
      return Icons.play_arrow;
    } else if (lessonType == 'quiz') {
      return Icons.help_outline;
    } else {
      return Icons.attach_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  getLessonIcon(lesson!.lessonType.toString()),
                  size: 14,
                  color: Colors.black45,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                    lesson!.title.toString(),
                    style:
                    const TextStyle(fontSize: 14, color: Colors.black45)),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
