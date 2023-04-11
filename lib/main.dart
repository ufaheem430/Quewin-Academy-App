import 'package:academy_app/screens/downloaded_course_list.dart';
import 'package:academy_app/screens/edit_password_screen.dart';
import 'package:academy_app/screens/edit_profile_screen.dart';
import 'package:academy_app/screens/sub_category_screen.dart';
import 'package:academy_app/screens/verification_screen.dart';
import 'package:academy_app/screens/webview_screen.dart';
import 'package:academy_app/screens/webview_screen_iframe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'providers/auth.dart';
import 'providers/categories.dart';
import 'providers/courses.dart';
import 'providers/misc_provider.dart';
import 'providers/my_courses.dart';
import 'screens/auth_screen.dart';
import 'screens/course_detail_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/my_course_detail_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/tabs_screen.dart';
import 'screens/temp_view_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Categories(),
        ),
        ChangeNotifierProxyProvider<Auth, Courses>(
          create: (ctx) => Courses([], []),
          update: (ctx, auth, prevoiusCourses) => Courses(
            prevoiusCourses == null ? [] : prevoiusCourses.items,
            prevoiusCourses == null ? [] : prevoiusCourses.topItems,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, MyCourses>(
          create: (ctx) => MyCourses([], []),
          update: (ctx, auth, previousMyCourses) => MyCourses(
            previousMyCourses == null ? [] : previousMyCourses.items,
            previousMyCourses == null ? [] : previousMyCourses.sectionItems,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Languages(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            title: 'Academy App',
            theme: ThemeData(
              fontFamily: 'google_sans',
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
                  .copyWith(secondary: kDarkButtonBg),
            ),
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
            routes: {
              '/home': (ctx) => const TabsScreen(),
              AuthScreen.routeName: (ctx) => const AuthScreen(),
              SignUpScreen.routeName: (ctx) => const SignUpScreen(),
              ForgotPassword.routeName: (ctx) => const ForgotPassword(),
              CoursesScreen.routeName: (ctx) => const CoursesScreen(),
              CourseDetailScreen.routeName: (ctx) => const CourseDetailScreen(),
              MyCourseDetailScreen.routeName: (ctx) =>
                  const MyCourseDetailScreen(),
              TempViewScreen.routeName: (ctx) => const TempViewScreen(),
              WebViewScreen.routeName: (ctx) => const WebViewScreen(),
              WebViewScreenIframe.routeName: (ctx) => WebViewScreenIframe(),
              EditPasswordScreen.routeName: (ctx) => const EditPasswordScreen(),
              EditProfileScreen.routeName: (ctx) => const EditProfileScreen(),
              VerificationScreen.routeName: (ctx) => const VerificationScreen(),
              DownloadedCourseList.routeName: (ctx) =>
                  const DownloadedCourseList(),
              SubCategoryScreen.routeName: (ctx) => const SubCategoryScreen(),
            },
          );
        },
      ),
    );
  }
}

//Remove Course Category
