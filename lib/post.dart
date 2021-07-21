import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  int _uid;
  String _text;
  Timestamp _timestamp;
  String? _image;
  String _location;

  Post(this._uid, this._text, this._timestamp, this._image, this._location);


  int get uid => _uid;

  set uid(int value) {
    _uid = value;
  }

  @override
  String toString() {
    return 'Post{_uid: $_uid, _text: $_text, _timestamp: $_timestamp, _image: $_image, _location: $_location}';
  }

  String get text => _text;

  set text(String value) {
    _text = value;
  }

  Timestamp get timestamp => _timestamp;

  set timestamp(Timestamp value) {
    _timestamp = value;
  }

  String? get image => _image;

  set image(String? value) {
    _image = value;
  }

  String get location => _location;

  set location(String value) {
    _location = value;
  }
}
