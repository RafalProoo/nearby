import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:nearby/people/people_view.dart';
import 'package:nearby/posts/posts_view.dart';

import 'access/account_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 0,
          unselectedFontSize: 0,
          backgroundColor: const Color(0xFFedebec),
          selectedItemColor: const Color(0xff1b58ca),
          unselectedItemColor: const Color(0xff1b58ca).withOpacity(.50),
          items: [
            BottomNavigationBarItem(
              label: 'Posts',
              icon: const Icon(Icons.map),
              activeIcon: Neumorphic(
                  child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.map),
              )),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people),
              label: 'People',
              activeIcon: Neumorphic(
                  child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.people),
              )),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: 'Account',
              activeIcon: Neumorphic(
                  child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.person),
              )),
            ),
          ],
          onTap: (index) => setState(() => _currentIndex = index),
          currentIndex: _currentIndex,
        ),
        body: _currentIndex == 0
            ? const PostsView()
            : _currentIndex == 1
                ? const PeopleView()
                : _currentIndex == 2
                    ? const AccountView()
                    : null
        );
  }
}
