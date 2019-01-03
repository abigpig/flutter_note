import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:libratone_flutter/LibratoneApplication.dart';
import 'package:libratone_flutter/Util/translations.dart';
import 'package:libratone_flutter/Widget/news_subsrciption.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SpecificLocalizationDelegate _localeOverrideDelegate;

  @override
  void initState() {
    super.initState();
    _localeOverrideDelegate = new SpecificLocalizationDelegate(null);
    appManager.onLocaleChanged = onLocaleChange;
  }

  onLocaleChange(Locale locale) {
    setState(() {
      _localeOverrideDelegate = new SpecificLocalizationDelegate(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData(
          primaryColor: Colors.white,
        ),
        localizationsDelegates: [
          _localeOverrideDelegate,
          const TranslationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: appManager.supportedLocales(),
        routes: <String, WidgetBuilder>{
          'NewsSubscriptionRoute': (BuildContext context) =>
              new NewsSubscriptionPage(),
        },
        home: new NewsSubscriptionPage());
  }
}
