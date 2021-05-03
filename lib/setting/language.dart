import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wefinex/languages/language.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLang = LocalizationService.langs.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('hello'.tr),
            SizedBox(height: 20),
            DropdownButton(
              icon: Icon(Icons.arrow_drop_down),
              value: _selectedLang,
              items: LocalizationService.langs.map((String lang) {
                return DropdownMenuItem(value: lang, child: Text(lang));
              }).toList(),
              onChanged: (String value) {
                // updates dropdown selected value
                setState(() => _selectedLang = value);
                // gets language and changes the locale
                LocalizationService().changeLocale(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
