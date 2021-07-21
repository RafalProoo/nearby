import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:nearby/posts/create_post_screen.dart';
import 'package:nearby/home_screen.dart';
import 'package:nearby/access/sign_in_screen.dart';
import 'package:nearby/access/sign_up_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return NeumorphicApp(
          title: 'Nearby',
          theme: const NeumorphicThemeData(baseColor: Color(0xFFedebec), variantColor: Color(0xff1b58ca), accentColor: Color(0xff1b58ca), boxShape: NeumorphicBoxShape.stadium()),
          home: getScreen(snapshot),
          routes: {'/signIn': (context) => SignInScreen(), '/signUp': (context) => SignUpScreen(), '/home': (context) => const HomeScreen(), '/createPost': (context) => const CreatePostScreen()},
        );
      },
    );
  }

  getScreen(AsyncSnapshot snapshot) {
    if (snapshot.hasError) {
      return const Text('Something went wrong');
    } else if (snapshot.connectionState == ConnectionState.done) {
      if (FirebaseAuth.instance.currentUser == null) {
        return SignInScreen();
      } else {
        return const HomeScreen();
      }
    } else {
      return const Text('Loading');
    }
  }
}
