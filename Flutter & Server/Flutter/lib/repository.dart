import 'package:mobile/tvseries.dart';

class Repository {
  List<TVSeries> elements = [];

  List<TVSeries> getAllSeries() {
    return elements;
  }

  void addSeries(TVSeries tvSeries) {
    elements.add(tvSeries);
  }

  void removeSeries(int id) {
    elements.removeWhere((element) => element.id == id);
  }

  void updateSeries(TVSeries tvSeries) {
    elements[elements.indexWhere((element) => element.id == tvSeries.id)] =
        tvSeries;
  }

  void setData(List<TVSeries> tvSeries){
    elements = tvSeries;
  }
}
