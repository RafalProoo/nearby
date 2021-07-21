import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:nearby/post.dart';

import 'location_methods.dart';

class PostsView extends StatefulWidget {
  const PostsView({Key? key}) : super(key: key);

  @override
  _PostsViewState createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  List<Post> _posts = [];

  @override
  initState() {
    super.initState();
    getPostsFromCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return getPostsFromCurrentLocation();
      },
      child: ListView.builder(
          itemCount: 1 + _posts.length,
          itemBuilder: (buildContext, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Neumorphic(
                  padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                  style: const NeumorphicStyle(depth: -8.0),
                  child: TextField(
                      readOnly: true,
                      decoration: const InputDecoration(hintText: "What's up?", border: InputBorder.none),
                      onTap: () {
                        Navigator.pushNamed(context, '/createPost');
                      }),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Neumorphic(
                    style: NeumorphicStyle(boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20))),
                    child: Column(
                      children: [
                        if (_posts[index - 1].image != null)
                          Image.network(
                            _posts[index - 1].image!,
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Text(
                                _posts[index - 1].uid.toString(),
                                style: const TextStyle(color: Color(0xff1b58ca)),
                              ),
                              Text(
                                " " + _posts[index - 1].text,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              );
            }
          }),
    );
  }

  getPostsFromCurrentLocation() async {
    String? geoHash = await LocationMethods.getGeoHash();
    GeoHasher geoHasher = GeoHasher();

    if (geoHash != null) {
      Map<String, String> neighbors = geoHasher.neighbors(geoHash);
      CollectionReference posts = FirebaseFirestore.instance.collection('posts');
      QuerySnapshot querySnapshot = await posts.where('location', whereIn: neighbors.values.toList()).get();
      List<Post> list = querySnapshot.docs
          .map(((document) => Post(
                document['uid'],
                document['text'],
                document['timestamp'],
                document['image'],
                document['location'],
              )))
          .toList();

      setState(() {
        _posts = list;
      });
    }
  }
}
