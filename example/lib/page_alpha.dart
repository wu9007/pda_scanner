import 'package:flutter/material.dart';
import 'package:pda_scanner/pda_listener.dart';

import 'page_beta.dart';

class PageAlpha extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PageAlphaState();
}

class PageAlphaState extends State<PageAlpha> with PdaListener {
  var _code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PageAlpha'),
      ),
      body: Column(
        children: <Widget>[
          Text('Scanning result: $_code\n'),
          RaisedButton(
            child: Text('Got to Beta'),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => PageBeta())),
          ),
        ],
      ),
    );
  }

  @override
  void onEvent(Object event) {
    setState(() {
      _code = event;
      print("ChannelPage: $event");
    });
  }

  @override
  void onError(Object error) {
    // TODO: implement onError
  }
}
