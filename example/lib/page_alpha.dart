import 'package:flutter/material.dart';
import 'package:pda_scanner/pda_listener.dart';

import 'page_beta.dart';

class PageAlpha extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PageAlphaState();
}

class PageAlphaState extends PdaListenerState<PageAlpha> {
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
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PageBeta())),
          ),
        ],
      ),
    );
  }

  @override
  void onEvent(Object event) {
    if (!ModalRoute.of(context).isCurrent) return;
    setState(() {
      _code = event;
      print("ChannelPage: $event");
    });
  }
}
