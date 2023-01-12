import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/list.dart';
import 'package:mobile/repository.dart';
import 'package:mobile/service.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';



Repository repository = Repository();
void onConnect(StompFrame frame){
  print("connected");
  globalKey.currentState?.syncData();
  stompClient.subscribe(
    destination: '/changes/listen',
    callback: (frame) async{
      var jsonData = jsonDecode(frame.body!);
      await globalKey.currentState?.handleChange(jsonData);
    },
  );
}

final service = Service();

final stompClient = StompClient(
  config: StompConfig.SockJS(
    url: 'http://10.0.2.2:8080/socket',
    onConnect: onConnect,
    beforeConnect: () async {
      print('waiting to connect...');
      await Future.delayed(const Duration(milliseconds: 200));
      print('connecting...');
    },
    onWebSocketError: (dynamic error) => print(error.toString()),
    stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
    webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
  ),
);

void main() {
  runApp(const MyApp());
  stompClient.activate();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        colorScheme:  ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: TVSeriesList("", key: globalKey),
    );
  }
}