import 'dart:convert';
import 'package:academy_app/constants.dart';
import 'package:academy_app/screens/categories_screen.dart';
import 'package:academy_app/screens/lock/lock.dart';
import 'package:academy_app/screens/sub_category_screen.dart';
import 'package:academy_app/widgets/app_bar.dart';
import 'package:academy_app/widgets/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'my_courses_screen.dart';
import 'my_wishlist_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/home';
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Widget> _pages = [
    const HomeScreen(),
    const LoginScreen(),
    const LoginScreen(),
    const LoginScreen(),
  ];

  var _isInit = true;

  int _selectedPageIndex = 0;

  @override
  void initState() {
    // lockSystem(context);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      bool _isAuth;
      dynamic userData;
      dynamic response;
      dynamic token;
      // var token = await SharedPreferenceHelper().getAuthToken();
      // setState(() {});
      // if (token != null && token.isNotEmpty) {
      //   _isAuth = true;
      // } else {
      //   _isAuth = false;
      // }

      // _isAuth = Provider.of<Auth>(context, listen: false).isAuth;

      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userData = (prefs.getString('userData') ?? '');
      });
      if (userData != null && userData.isNotEmpty) {
        response = json.decode(userData);
        token = response['token'];
      }
      if (token != null && token.isNotEmpty) {
        _isAuth = true;
      } else {
        _isAuth = false;
      }

      if (_isAuth) {
        _pages = [
          const HomeScreen(),
          const MyCoursesScreen(),
          const MyWishlistScreen(),
          CategoriesScreen(),
          const AccountScreen(),
        ];
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _showFilterModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return const FilterWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: CustomAppBar(),
      body: _pages[_selectedPageIndex],
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _showFilterModal(context),
      //   child: const Icon(Icons.filter_list),
      //   backgroundColor: kDarkButtonBg,
      // ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'categories',
          ),
          BottomNavigationBarItem(
            backgroundColor: kBackgroundColor,
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: 'Profiles', //TODO TAb suresh
          ),
        ],
        backgroundColor: Colors.white,
        unselectedItemColor: kSecondaryColor,
        selectedItemColor: kSelectItemColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
