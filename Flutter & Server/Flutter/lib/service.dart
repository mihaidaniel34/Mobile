import 'package:dio/dio.dart';
import 'package:mobile/tvseries.dart';

class Service{
  static const String _baseUrl = "http://10.0.2.2:8080";
  final Dio _dio = Dio();
  final String appId = DateTime.now().microsecondsSinceEpoch.toString();


  Future<List<TVSeries>> getAllSeries() async {
    final response = await _dio.get('$_baseUrl/series');
    final json = response.data;
    var list = (json as List).map((s) => TVSeries.fromMap(s)).toList();
    return list;
  }

  addSeries(TVSeries tvSeries) async {
    final response = await _dio.post('$_baseUrl/series/$appId', data: tvSeries.toMap());
  }

  deleteSeries(int id) async {
    await _dio.delete('$_baseUrl/series/$id&$appId');
  }
  updateSeries(TVSeries tvSeries) async{
    await _dio.put('$_baseUrl/series/$appId', data:tvSeries.toMap());
  }
}