import 'package:flutter/material.dart';
import 'package:fuar_qr/core/utility/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class ThemeChoice extends StatefulWidget {
  ThemeChoice() : super();
  @override
  ThemeChoiceState createState() => ThemeChoiceState();
}

class ThemeChoiceState extends State<ThemeChoice> {
  late ThemeMode _selectedThemeMode;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _createOptions(ThemeModeNotifier themeModeNotifier) {
    List<Widget> widgets = [];
    widgets.add(
      Builder(builder: (context) {
        return RadioListTile<ThemeMode>(
          value: ThemeMode.system,
          groupValue: _selectedThemeMode,
          title: Text("Sistem"),
          onChanged: (mode) {
            _setSelectedThemeMode(mode!, themeModeNotifier);
          },
          selected: _selectedThemeMode == ThemeMode.system,
          activeColor: primary,
        );
      }),
    );
    widgets.add(
      Builder(builder: (context) {
        return RadioListTile<ThemeMode>(
          value: ThemeMode.light,
          groupValue: _selectedThemeMode,
          title: Text("Açık"),
          onChanged: (mode) {
            _setSelectedThemeMode(mode!, themeModeNotifier);
          },
          selected: _selectedThemeMode == ThemeMode.light,
          activeColor: primary,
        );
      }),
    );
    widgets.add(
      Builder(builder: (context) {
        return RadioListTile<ThemeMode>(
          value: ThemeMode.dark,
          groupValue: _selectedThemeMode,
          title: Text("Siyah"),
          onChanged: (mode) {
            _setSelectedThemeMode(mode!, themeModeNotifier);
          },
          selected: _selectedThemeMode == ThemeMode.dark,
          activeColor: primary,
        );
      }),
    );
    return widgets;
  }

  void _setSelectedThemeMode(
      ThemeMode mode, ThemeModeNotifier themeModeNotifier) async {
    themeModeNotifier.setThemeMode(mode);
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', mode.index);
    setState(() {
      _selectedThemeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // init radios with current themeMode
    final themeModeNotifier = Provider.of<ThemeModeNotifier>(context);
    setState(() {
      _selectedThemeMode = themeModeNotifier.getThemeMode();
    });
    // build the Widget
    return Column(
      children: <Widget>[
        Column(
          children: _createOptions(themeModeNotifier),
        ),
      ],
    );
  }
}
