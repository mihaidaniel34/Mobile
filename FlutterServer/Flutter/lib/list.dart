import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/add_tv_series.dart';
import 'package:mobile/main.dart';
import 'package:mobile/tvseries.dart';

import 'db_adapter.dart';
final GlobalKey<_TVSeriesList> globalKey = GlobalKey<_TVSeriesList>();

class TVSeriesList extends StatefulWidget {
  final String _title;

  const TVSeriesList(this._title, {super.key});

  @override
  State<StatefulWidget> createState() => _TVSeriesList();
}

class _TVSeriesList extends State<TVSeriesList> {
  List<TVSeries> seriesList = [];

  
  @override
  void initState() {
        DbAdapter.getAllTvSeries().then((value){
          print("Retrieving data from the local db");
          setState(() {
            if (value != null){
              seriesList = value;
              repository.setData(value);
            }
          });
        });
  }

  void syncData() {
    print("syncing with the server");
    seriesList.where((element) => element.id == null || element.id == -1).forEach((element) {service.addSeries(element);});
    service.getAllSeries().then((value) {
      setState(() {
        seriesList = value;
        repository.setData(seriesList);
        DbAdapter.deleteAllSeries();
        seriesList.forEach((element) {
          DbAdapter.addTvSeries(element);
        });
      });
    });
  }
  Future<void> handleChange(dynamic jsonData) async {
    print(jsonData);
    if (jsonData["type"] == "ADD") {
      await DbAdapter.addTvSeries(TVSeries.fromMap(jsonData["content"]));
      setState(() {
        seriesList.add(TVSeries.fromMap(jsonData["content"]));
      });
      if(jsonData["appId"] != service.appId){
        repository.addSeries(TVSeries.fromMap(jsonData["content"]));
      }
    } else if (jsonData["type"] == "DELETE") {
      await DbAdapter.deleteTvSeriesId(jsonData["content"]);
      repository.removeSeries(jsonData["content"]);
      setState(() {
        seriesList.removeWhere((element) => element.id == jsonData["content"]);
      });
    } else if (jsonData["type"] == "UPDATE") {
      await DbAdapter.updateTvSeries(TVSeries.fromMap(jsonData["content"]));
      repository.updateSeries(TVSeries.fromMap(jsonData["content"]));
      setState(() {
        repository.updateSeries(TVSeries.fromMap(jsonData["content"]));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.only(left: 3, right: 3, top: 10),
              child: ListTile(
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddTVSeries(seriesList[index])))
                        .then((tvSeries) => {
                              if (tvSeries != null)
                                {
                                  setState(() {
                                  })
                                }
                            });
                  },
                  onLongPress: () {
                    AlertDialog alertDialog = AlertDialog(
                      title: Text("Delete"),
                      content: Text(
                          "Are you sure you want to delete this TVSeries?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel")),
                        TextButton(
                            onPressed: () async {
                              if (stompClient.connected){
                                if (seriesList[index].id != null){
                                  deleteSeries(seriesList[index].id!);
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannot delete while offline!")));
                              }
                              setState(() {
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text("Yes"))
                      ],
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alertDialog;
                        });
                  },
                  title: Text(seriesList[index].title),
                  subtitle: Text(seriesList[index].status),
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple[800],
                    child: Text(seriesList[index].title.substring(0, 1)),
                  ),
                  trailing: Text.rich(TextSpan(children: [
                    TextSpan(text: "${seriesList[index].rating}/10"),
                    const WidgetSpan(child: Icon(Icons.star))
                  ])),
                  tileColor: Colors.black.withAlpha(30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))));
        },
        itemCount: seriesList.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AddTVSeries()))
              .then((_) => {setState(() {
                seriesList = repository.getAllSeries();
          })});
        },
        tooltip: "Add Series",
        child: const Icon(Icons.add),
      ),
    );
  }

  void deleteSeries(int id) {
    if (stompClient.connected) {
      service.deleteSeries(id);
    } else {
      print("No internet connection / server is down");
    }
  }
}
