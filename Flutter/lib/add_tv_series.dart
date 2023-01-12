// import 'dart:ffi';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/db_adapter.dart';
import 'package:mobile/tvseries.dart';
import 'package:mobile/text_box.dart';

class AddTVSeries extends StatefulWidget {
  TVSeries? _tvSeries;

  AddTVSeries([this._tvSeries]);

  @override
  State<StatefulWidget> createState() => _AddTVSeries();
}

class _AddTVSeries extends State<AddTVSeries> {
  late int? id;
  late double rating;
  late TextEditingController titleController;
  late TextEditingController releaseDateController;
  late TextEditingController noSeasonsController;
  late TextEditingController noEpisodesController;
  late TextEditingController statusController;
  late bool updating;

  @override
  void initState() {
    updating = (widget._tvSeries?.id != null);
    id = widget._tvSeries?.id;
    titleController = widget._tvSeries == null
        ? TextEditingController()
        : TextEditingController(text: widget._tvSeries?.title);
    releaseDateController = widget._tvSeries == null
        ? TextEditingController()
        : TextEditingController(
            text:
                DateFormat('yyyy-MM-dd').format(widget._tvSeries!.releaseDate));
    noSeasonsController = widget._tvSeries == null
        ? TextEditingController()
        : TextEditingController(text: widget._tvSeries?.noSeasons.toString());
    noEpisodesController = widget._tvSeries == null
        ? TextEditingController()
        : TextEditingController(text: widget._tvSeries?.noEpisodes.toString());
    statusController = widget._tvSeries == null
        ? TextEditingController()
        : TextEditingController(text: widget._tvSeries?.status);
    rating =
        (widget._tvSeries == null ? 1 : widget._tvSeries?.rating.toDouble())!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TVSeries details"),
      ),
      body: ListView(
        children: [
          TextBox(titleController, "Title"),
          Container(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: releaseDateController,
              decoration: const InputDecoration(
                suffix: Icon(Icons.calendar_today),
                labelText: "Enter Date",
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2100));
                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    releaseDateController.text = formattedDate;
                  });
                } else {}
              },
            ),
          ),
          NumberTextBox(noSeasonsController, "Number of seasons"),
          NumberTextBox(noEpisodesController, "Number of episodes"),
          Padding(
              padding: const EdgeInsets.all(15),
              child: DropdownSearch(
                onChanged: (status) => statusController.text = status!,
                items: const ["To watch", "Watching", "Finished"],
                selectedItem: statusController.text,
                dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration:
                        InputDecoration(labelText: "Status")),
                popupProps: const PopupProps.menu(
                  fit: FlexFit.loose,
                ),
              )),
          // TextBox(statusController, "Status"),
          Slider(
              value: rating,
              max: 10,
              divisions: 10,
              label: rating.round().toString(),
              onChanged: (double value) {
                setState(() {
                  rating = value;
                });
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String title = titleController.text;
          DateTime releaseDate =
              DateFormat('yyyy-MM-dd').parse(releaseDateController.text);
          int noSeasons = int.parse(noSeasonsController.text);
          int noEpisodes = int.parse(noEpisodesController.text);
          String status = statusController.text;

          TVSeries newSeries = TVSeries(id, title, releaseDate, noSeasons,
              noEpisodes, status, rating.round());
          if (updating) {
            await DbAdapter.updateTvSeries(newSeries);
          } else {
            await DbAdapter.addTvSeries(newSeries);
          }
          Navigator.pop(context, newSeries);
        },
        label: const Text("Save TVSeries"),
        icon: Icon(Icons.save),
      ),
    );
  }
}
