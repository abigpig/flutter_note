import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:libratone_flutter/Util/translations.dart';

class NewsSubscriptionPage extends StatefulWidget {
  @override
  _NewsSubscriptionState createState() => new _NewsSubscriptionState();
}

class _NewsSubscriptionState extends State<StatefulWidget> {
  static const MethodChannel getMethodChannel =
      MethodChannel('libratone.flutter.io/getNewsSubscribeState');
  static const MethodChannel setMethodChannel =
      MethodChannel('libratone.flutter.io/setNewsSubscribeState');
  static const MethodChannel iosWebViewMethodChannel =
      MethodChannel('libratone.flutter.io/setWebViewUrl');
  static const EventChannel eventChannel =
      EventChannel('libratone.flutter.io/');
  static const String frUrl = "https://www.libratone.com/fr/newsletter/";
  static const String deUrl = "https://www.libratone.com/de/newsletter/";
  static const String defaultUrl = "https://www.libratone.com/uk/newsletter/";

  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  bool newsSubscribed = false;
  String currentUrl = defaultUrl;
  double appBarHeight = 70.0;
  double buttonHeight = 45.0;
  double webViewHeight;
  TapGestureRecognizer tapGestureRecognizer = new TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    _getNewsSubscribeState();
    webViewHeight = 0.0;
  }

  _launchURL() async {
    String url;
    Locale myLocale = Localizations.localeOf(context);
    switch (myLocale.languageCode) {
      case "fr":
        url = frUrl;
        break;
      case "de":
        url = deUrl;
        break;
      default:
        url = defaultUrl;
        break;
    }

    if (Platform.isIOS) {
      try {
        await iosWebViewMethodChannel.invokeMethod(
            'iosWebViewMethodChannel', url);
      } on PlatformException {}
    } else {
      setState(() {
        webViewHeight = MediaQuery.of(context).size.height - appBarHeight;
        currentUrl = url;
      });
    }
  }

  @override
  void dispose() {
    flutterWebViewPlugin.close();
    super.dispose();
  }

  void _onEvent(Object event) {
    setState(() {
      newsSubscribed = event;
    });
  }

  void _onError(Object event) {
    newsSubscribed = event;
  }

  Future<Null> _getNewsSubscribeState() async {
    bool flag;
    try {
      flag = await getMethodChannel.invokeMethod('getNewsSubscribeState');
      setState(() {
        newsSubscribed = flag;
      });
    } on PlatformException {}
  }

  Future<Null> _setNewsSubscribeState(bool isSubscribe) async {
    bool audioGumSuccess;
    try {
      audioGumSuccess = await setMethodChannel.invokeMethod(
          'setNewsSubscribeState', isSubscribe);
      setState(() {
        if (audioGumSuccess) {
          newsSubscribed = isSubscribe;
        } else {
          newsSubscribed = !isSubscribe;
        }
      });
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Widget titleSection = new Container(
      height: appBarHeight,
      width: screenWidth,
      child: new Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(0.0, 1.0),
            child: new Divider(
              height: 0.0,
              color: Colors.black26,
            ),
          ),
          Align(
            alignment: Alignment(-1.0, 0.8),
            child: new InkWell(
              onTap: _onBackKeyPress,
              child: Image.asset(
                'images/btn_back.png',
                height: 50.0,
                width: 50.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.0, 0.5),
            child: Text(Translations.of(context).text('news_subscription'),
                style: TextStyle(
                  fontSize: 18.0,
                  color: Color(0XFF4A4A4A),
                )),
          ),
        ],
      ),
    );

    Widget subscribeSection = new Container(
        height: buttonHeight * 2,
        padding: const EdgeInsets.fromLTRB(34.0, 0.0, 34.0, 0.0),
        child: new Column(
          children: <Widget>[
            new Container(
              height: buttonHeight,
              width: screenWidth,
              child: RaisedButton(
                onPressed: newsSubscribed
                    ? null
                    : () {
                        _setNewsSubscribeState(true);
                      },
                color: Color(0xFF4A4A4A),
                child: Text(
                    Translations.of(context)
                        .text('news_subscription_btn_subscribe'),
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    )),
              ),
            ),
            new Container(
              height: buttonHeight,
              width: screenWidth,
              child: FlatButton(
                onPressed: !newsSubscribed
                    ? null
                    : () {
                        _setNewsSubscribeState(false);
                      },
                child: Text(
                    Translations.of(context)
                        .text('news_subscription_btn_unsubscribe'),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: newsSubscribed ? Colors.black : Colors.black38,
                    )),
              ),
            )
          ],
        ));

    Widget illustrationSection = new Container(
      height: screenHeight - buttonHeight * 2 - appBarHeight,
      padding: const EdgeInsets.fromLTRB(34.0, 28.0, 34.0, 20.0),
      child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
          },
          child: new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: new Column(children: <Widget>[
              new Container(
                child: Text(
                    Translations.of(context).text('news_subscription_des1'),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0XFF4A4A4A),
                    )),
              ),
              new Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: new InkWell(
                      onTap: _launchURL,
                      child: new Text(
                          Translations.of(context)
                              .text('news_subscription_des2'),
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                            fontSize: 16.0,
                            color: Color(0XFF4A4A4A),
                          )))),
            ]),
          )),
    );

    return new WillPopScope(
        child: new Scaffold(
          body: new Stack(
            children: <Widget>[
              new Align(
                  alignment: Alignment(0.0, 1.0),
                  child: new Container(
                    key: new Key("webView"),
                    height: webViewHeight,
                    width: screenWidth,
                    child: new WebviewScaffold(
                      url: currentUrl,
                    ),
                  )),
              new Align(
                  alignment: Alignment(0.0, 0.0), child: illustrationSection),
              new Align(alignment: Alignment(0.0, -1.0), child: titleSection),
              new Align(
                  alignment: Alignment(0.0, 1.0), child: subscribeSection),
            ],
          ),
        ),
        onWillPop: _onBackKeyPress);
  }

  Future<bool> _onBackKeyPress() {
    if (webViewHeight > 0.0) {
      setState(() {
        webViewHeight = 0.0;
      });
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        SystemNavigator.pop();
      }
    }
    return new Future.value(false);
  }
}
