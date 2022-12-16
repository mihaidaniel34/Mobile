import 'package:intl/intl.dart';

class TVSeries {
  int? _id;
  String _title = "New Series";
  DateTime _releaseDate = new DateTime.now();
  int _noSeasons = 1;
  int _noEpisodes = 8;
  String _status = "To watch";
  int _rating = 10;

  TVSeries.defaultTvSeries(this._id);

  TVSeries(this._id, this._title, this._releaseDate, this._noSeasons, this._noEpisodes, this._status, this._rating);

  int get rating => _rating;

  set rating(int value) {
    _rating = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  int get noEpisodes => _noEpisodes;

  set noEpisodes(int value) {
    _noEpisodes = value;
  }

  int get noSeasons => _noSeasons;

  set noSeasons(int value) {
    _noSeasons = value;
  }

  DateTime get releaseDate => _releaseDate;

  set releaseDate(DateTime value) {
    _releaseDate = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int? get id => _id;

  set id(int? value) {
    _id = value;
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is TVSeries && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;

  Map<String, dynamic> toMap(){
    return {
      'id' : _id,
      'title' : _title,
      'releaseDate': DateFormat('yyyy-MM-dd').format(_releaseDate),
      'noSeasons': _noSeasons,
      'noEpisodes' : _noEpisodes,
      'status' : _status,
      'rating' : _rating,
    };
  }

  factory TVSeries.fromMap(Map<String, dynamic> map) => TVSeries(map['id'],
      map['title'], DateFormat('yyyy-MM-dd').parse(map['releaseDate']),
      map['noSeasons'], map['noEpisodes'],map['status'],map['rating']);


}

