import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Navbar.dart';
import 'localization/app_localization.dart';
import 'models/Bitcoin.dart';
import 'top_coin.dart';

class TopLoser extends StatefulWidget {
  const TopLoser({Key? key}) : super(key: key);
  @override
  _TopLoser createState() => _TopLoser();
}

class _TopLoser extends State<TopLoser> with SingleTickerProviderStateMixin{

  bool isLoading = false;
  late List<Bitcoin> topLooserAndGainerList = [];
  SharedPreferences? sharedPreferences;
  String? coin;
  String? URL;

  @override
  void initState() {

    fetchRemoteValue();
    super.initState();
  }


  fetchRemoteValue() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();

      URL = remoteConfig.getString('bitFuture_image_url').trim();

      setState(() {

      });
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }

    callGainerLooserBitcoinApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xff111622)
        ),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Expanded(
              child: DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
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
                          const Spacer(),
                          Text(AppLocalizations.of(context).translate('top_coin'), style: GoogleFonts.openSans(textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),)
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(AppLocalizations.of(context).translate('top_lose'),textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TopGainer()),
                                );
                              }, // Image tapped
                              child: Container(
                                decoration: BoxDecoration(color: Color(0xff2e3546),borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(AppLocalizations.of(context).translate('gain'),textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: Container(
                          child: topLooser(),
                        ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topLooser(){
    var list = topLooserAndGainerList.where((element) => double.parse(element.diffRate!)< 0).toList();
    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int i) {
          return InkWell(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Container(
                      height: 80,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 70,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: FadeInImage(
                                      placeholder: const AssetImage('assets/image/cob.png'),
                                      image: NetworkImage("$URL/Bitcoin/resources/icons/${list[i].name!.toLowerCase()}.png"),
                                      // image: NetworkImage("http://45.34.15.25:8080/Bitcoin/resources/icons/${gainerLooserCoinList[i].name.toLowerCase()}.png"),
                                    ),
                                  )
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                                    child: Text(
                                      '${list[i].name}',
                                      style: GoogleFonts.poppins(
                                          textStyle:  const TextStyle(fontWeight: FontWeight.normal,fontSize: 24,color: Colors.black)
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              callCurrencyDetails(list[i].name);
                            },
                            child: Container(
                              width:MediaQuery.of(context).size.width/4,
                              height: 40,
                              child: charts.LineChart(
                                _createSampleData(list[i].historyRate, double.parse(list[i].diffRate!)),
                                layoutConfig: charts.LayoutConfig(
                                    leftMarginSpec: charts.MarginSpec.fixedPixel(5),
                                    topMarginSpec: charts.MarginSpec.fixedPixel(10),
                                    rightMarginSpec: charts.MarginSpec.fixedPixel(5),
                                    bottomMarginSpec: charts.MarginSpec.fixedPixel(10)),
                                defaultRenderer: charts.LineRendererConfig(includeArea: true, stacked: true,),
                                animate: true,
                                domainAxis: const charts.NumericAxisSpec(showAxisLine: false, renderSpec: charts.NoneRenderSpec()),
                                primaryMeasureAxis: const charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '\$${double.parse(list[i].rate!.toStringAsFixed(2))}',
                                        style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 15,color: Colors.white,   fontWeight: FontWeight.normal,)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      double.parse(list[
                                      i]
                                          .diffRate!) <
                                          0
                                          ? Container(
                                        // color: Colors.red,
                                        child: const Icon(
                                          Icons
                                              .arrow_downward,
                                          color: Colors.red,
                                          size: 15,
                                        ),
                                      )
                                          : Container(
                                        // color: Colors.green,
                                        child: const Icon(
                                          Icons.arrow_upward_sharp,
                                          color: Colors.green,
                                          size: 15,
                                        ),
                                      ),
                                      const SizedBox(
                                          width:2
                                      ),
                                      Text(
                                          list[i]
                                              .perRate!,
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              color: double.parse(
                                                  list[
                                                  i]
                                                      .diffRate!) <
                                                  0
                                                  ? Colors.red
                                                  : Colors.green)
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(color: Colors.white,thickness: 1,endIndent: 20,indent: 20,),
              ],
            ),
            onTap: () {
              callCurrencyDetails(topLooserAndGainerList[i].name);
            },
          );
        });
  }

  List<charts.Series<LinearSales, int>> _createSampleData(
      historyRate, diffRate) {
    List<LinearSales> listData = [];
    for (int i = 0; i < historyRate.length; i++) {
      double rate = historyRate[i]['rate'];
      listData.add(LinearSales(i, rate));
    }

    return [
      charts.Series<LinearSales, int>(
        id: 'Tablet',
        // colorFn specifies that the line will be red.
        colorFn: (_, __) => diffRate < 0
            ? charts.MaterialPalette.red.shadeDefault
            : charts.MaterialPalette.green.shadeDefault,
        // areaColorFn specifies that the area skirt will be light red.
        // areaColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.count,
        measureFn: (LinearSales sales, _) => sales.rate,
        data: listData,
      ),
    ];
  }

  Future<void> callCurrencyDetails(name) async {
    _saveProfileData(name);
  }

  _saveProfileData(String name) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.setString("currencyName", name);
      sharedPreferences!.setString("title", AppLocalizations.of(context).translate('trends'));
      sharedPreferences!.commit();
    });

    Navigator.pushNamedAndRemoveUntil(context, '/trendPage', (r) => false);
  }

  Future<void> callGainerLooserBitcoinApi() async {

    var uri =
        '$URL/Bitcoin/resources/getBitcoinListLoser?size=0';

    //  print(uri);
    var response = await get(Uri.parse(uri));
    //   print(response.body);
    final data = json.decode(response.body) as Map;
    //  print(data);
    if (mounted) {
      if (data['error'] == false) {
        setState(() {
          topLooserAndGainerList.addAll(data['data']
              .map<Bitcoin>((json) => Bitcoin.fromJson(json))
              .toList());
          isLoading = false;
          // _size = _size + data['data'].length;
        }
        );
      }

      else {
        //  _ackAlert(context);
        setState(() {});
      }
    }
  }

}

class LinearSales {
  final int count;
  final double rate;

  LinearSales(this.count, this.rate);
}
