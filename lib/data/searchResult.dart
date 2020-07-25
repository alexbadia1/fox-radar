class SearchResult {
  String _myTitle;
  String _myHost;
  String _myLocation;
  String _myCategory;

  SearchResult(
      {String newHost,
        String newTitle,
        String newLocation,
        String newCategory,}) {

    _myHost = newHost;
    _myTitle = newTitle;
    _myLocation = newLocation;
    _myCategory = newCategory;
  } //full constructor

  SearchResult.nullConstructor() {
    _myHost = '';
    _myTitle = '';
    _myLocation = '';
  } ////null constructor

  String get getHost => _myHost;
  String get getLocation => _myLocation;
  String get getTitle => _myTitle;
  String get myCategory => _myCategory;

  void setLocation(String value) {
    _myLocation = value;
  }

  void setTitle(String value) {
    _myTitle = value;
  }

  void setHost(String value) {
    _myHost = value;
  }

  void setCategory(String newCategory) {
    _myCategory = newCategory;
  }

  @override
  String toString() {
    return "Title: $_myTitle\n"
        "Host: $_myHost\n"
        "Location: $_myLocation\n"
        "Category: $_myCategory\n";
  }

} //class