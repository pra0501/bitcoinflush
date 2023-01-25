import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Navbar.dart';
import 'models/LanguageData.dart';
import 'localization/AppLanguage.dart';
import 'localization/app_localization.dart';


class NativeReLocation extends StatefulWidget {
  @override
  _NativeReLocation createState() => _NativeReLocation();
}

class _NativeReLocation extends State<NativeReLocation> {
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  SharedPreferences? sharedPreferences;
  final PageStorageBucket bucket = PageStorageBucket();
  String? languageCodeSaved;

  List<LanguageData> languages = [
    LanguageData(languageCode: "en", languageName: "English"),
    LanguageData(languageCode: "it", languageName: "Italian"),
    LanguageData(languageCode: "de", languageName: "German"),
    LanguageData(languageCode: "sv", languageName: "Swedish"),
    LanguageData(languageCode: "fr", languageName: "French"),
    LanguageData(languageCode: "nb", languageName: "Norwegian"),
    LanguageData(languageCode: "es", languageName: "Spanish"),
    LanguageData(languageCode: "nl", languageName: "Dutch"),
    LanguageData(languageCode: "fi", languageName: "Finnish"),
    LanguageData(languageCode: "ru", languageName: "Russian"),
    LanguageData(languageCode: "pt", languageName: "Portuguese"),
    LanguageData(languageCode: "ar", languageName: "Arabic"),
  ];

  @override
  void initState() {
    getSharedPrefData();

    super.initState();
  }

  Future<void> getSharedPrefData() async {
    final SharedPreferences prefs = await _sprefs;
    setState(() {
      languageCodeSaved = prefs.getString('language_code') ?? "en";
      _saveProfileData();
    });
  }

  _saveProfileData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.commit();
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      backgroundColor: const Color(0xff111622),
      appBar: AppBar(
        leading:Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: const Color(0xff111622)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NavBar()),
                    );
                  }, // Image tapped
                  child: const Icon(Icons.menu_rounded,color: Colors.grey,)
              ),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xff111622),
        centerTitle: true,
        title: Text(AppLocalizations.of(context).translate('select')),

      ),
      body: Container(
          width: double.maxFinite,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              itemBuilder: (BuildContext context, int i) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      InkWell(
                          onTap: () async {
                            appLanguage.changeLanguage(Locale(languages[i].languageCode!));
                            await getSharedPrefData();
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left:25.0,right: 25.0,top:15,bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(languages[i].languageName!,style: const TextStyle(color: Colors.white, fontSize: 22),),
                                languageCodeSaved ==
                                    languages[i].languageCode
                                    ? const Icon(
                                  Icons
                                      .radio_button_checked,
                                  color: Color(0xffff0000),
                                )
                                    : const Icon(
                                  Icons
                                      .radio_button_unchecked,
                                  color: Color(0xffff0000),
                                ),
                              ],
                            ),
                          )),
                      // Divider()
                    ],
                  ),
                );
              }
          )
      ),
    );
  }
}