import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile/add_tv_series.dart';
import 'package:mobile/tvseries.dart';

import 'db_adapter.dart';

class TVSeriesList extends StatefulWidget {
  final String _title;

  const TVSeriesList(this._title, {super.key});

  @override
  State<StatefulWidget> createState() => _TVSeriesList();
}

class _TVSeriesList extends State<TVSeriesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: FutureBuilder(
          future: DbAdapter.getAllTvSeries(),
          builder: (context, AsyncSnapshot<List<TVSeries>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                        padding:
                            const EdgeInsets.only(left: 3, right: 3, top: 10),
                        child: ListTile(
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => AddTVSeries(
                                              snapshot.data![index])))
                                  .then((tvSeries) => {
                                        if (tvSeries != null)
                                          {
                                            setState(() {
                                              snapshot.data![snapshot.data!
                                                  .indexWhere((series) =>
                                                      series.id ==
                                                      tvSeries.id)] = tvSeries;
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
                                        DbAdapter.  deleteTvSeries(
                                            snapshot.data![index]);
                                        setState(() {});
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
                            title: Text(snapshot.data![index].title),
                            subtitle: Text(snapshot.data![index].status),
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple[800],
                              child: Text(
                                  snapshot.data![index].title.substring(0, 1)),
                            ),
                            trailing: Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: "${snapshot.data![index].rating}/10"),
                              const WidgetSpan(child: Icon(Icons.star))
                            ])),
                            tileColor: Colors.black.withAlpha(30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))));
                  },
                  itemCount: snapshot.data!.length,
                );
              }
              return const Center(
                child: Text('No TVSeries yet'),
              );
            }
            return const Center(
              child: Text('No TVSeries yet'),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AddTVSeries()))
              .then((_) => {
          setState(() => {})
          });
        },
        tooltip: "Add Series",
        child: const Icon(Icons.add),
      ),
    );
  }
}
