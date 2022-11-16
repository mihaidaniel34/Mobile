import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/add_tv_series.dart';
import 'package:mobile/tvseries.dart';

class TVSeriesList extends StatefulWidget {
  final String _title;

  TVSeriesList(this._title);

  @override
  State<StatefulWidget> createState() => _TVSeriesList();
}

class _TVSeriesList extends State<TVSeriesList> {
  List<TVSeries> tvSeriesList = [
    TVSeries(1, "House of the Dragon", DateTime.now(), 1, 8, "Watching", 8),
    TVSeries(2, "Breaking Bad", DateTime.now(), 1, 8, "Finished", 10),
    TVSeries(3, "Rick and Morty", DateTime.now(), 1, 8, "Finished", 9),
    TVSeries.defaultTvSeries(4),
    TVSeries.defaultTvSeries(5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: ListView.builder(
          itemCount: tvSeriesList.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(left: 3, right: 3, top: 10),
                child: ListTile(
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      AddTVSeries(tvSeriesList[index])))
                          .then((tvSeries) => {
                                if (tvSeries != null)
                                  {
                                    setState(() {
                                      tvSeriesList[tvSeriesList.indexWhere(
                                              (series) =>
                                                  series.id == tvSeries.id)] =
                                          tvSeries;
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
                              onPressed: () {
                                setState(() {
                                  tvSeriesList.removeAt(index);
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
                    title: Text(tvSeriesList[index].title),
                    subtitle: Text(tvSeriesList[index].status),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple[800],
                      child: Text(tvSeriesList[index].title.substring(0, 1)),
                    ),
                    trailing: Text.rich(TextSpan(children: [
                      TextSpan(text: "${tvSeriesList[index].rating}/10"),
                      const WidgetSpan(child: Icon(Icons.star))
                    ])),
                    tileColor: Colors.black.withAlpha(30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AddTVSeries()))
              .then((tvSeries) => {
                    if (tvSeries != null)
                      {
                        setState(() {
                          tvSeries.id = tvSeriesList
                                  .reduce((curr, next) =>
                                      curr.id > next.id ? curr : next)
                                  .id +
                              1;
                          tvSeriesList.add(tvSeries);
                        })
                      }
                  });
        },
        tooltip: "Add Series",
        child: const Icon(Icons.add),
      ),
    );
  }
}
