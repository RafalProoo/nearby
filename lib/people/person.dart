class Person {
  String _uid;
  String _location;

  Person(this._uid, this._location);

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get location => _location;

  set location(String value) {
    _location = value;
  }
}