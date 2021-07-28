import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:nearby/people/person.dart';

import '../location_methods.dart';

class PeopleView extends StatefulWidget {
  const PeopleView({Key? key}) : super(key: key);

  @override
  _PeopleViewState createState() => _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {
  List<Person> _people = [];

  @override
  void initState() {
    super.initState();
    getPeopleFromCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return getPeopleFromCurrentLocation();
      },
      child: GridView.builder(
        itemCount: _people.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Neumorphic(child: const Icon(Icons.account_circle_rounded, size: 64, color: Color(0xff1b58ca))),
              ),
              Text(_people[index].uid)
            ],
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      ),
    );
  }
  
  getPeopleFromCurrentLocation() async {
    String? geoHash = await LocationMethods.getGeoHash();
    GeoHasher geoHasher = GeoHasher();

    if (geoHash != null) {
      Map<String, String> neighbors = geoHasher.neighbors(geoHash);

      CollectionReference people = FirebaseFirestore.instance.collection('people');

      QuerySnapshot querySnapshot = await people.where('location', whereIn: neighbors.values.toList()).get();

      List<Person> list = querySnapshot.docs
          .map((document) => Person(
                document.id,
                document['location'],
              ))
          .toList();

      list.removeWhere((element) => element.uid == FirebaseAuth.instance.currentUser!.uid);

      setState(() {
        _people = list;
      });

      await people.doc(FirebaseAuth.instance.currentUser!.uid).set({'location': geoHash});
    }
  }
}
