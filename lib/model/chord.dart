library chord;

class Chord {
  String _root;
  String _quality;
  String _diagramFilename;

  String _symbol;

  Chord(this._root, this._quality, this._diagramFilename) {
    // construct the chord symbol
    _symbol = "$_root$_quality";
  }

  Chord.fromMap(Map<String, String> map) : this(map["root"], map["quality"], map["diagramFilename"]);

  String get root => _root;
  String get quality => _quality;
  String get diagramFilename => _diagramFilename;

  @override String toString() => _symbol;

  Map<String, String> toMap() {
    return {
      "root": _root,
      "quality": _quality,
      "diagramFilename": _diagramFilename
    };
  }
}