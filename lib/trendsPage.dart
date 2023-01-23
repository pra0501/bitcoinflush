import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'Navbar.dart';
import 'dashboard_helper.dart';
import 'models/Bitcoin.dart';
import 'models/PortfolioBitcoin.dart';

class TrendsPage extends StatefulWidget {
  @override
  _TrendsPageState createState() => _TrendsPageState();

}

class _TrendsPageState extends State<TrendsPage> {
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  List<Bitcoin> bitcoinDataList = [];
  double diffRate = 0;
  List<CartData> currencyData = [];
  String name = "";
  double coin = 0;
  String result = '';
  int graphButton = 1;
  String _type = 'Week';
  String? URL;
  bool isLoading = false;
  final _formKey2 = GlobalKey<FormState>();
  String? currencyNameForImage;
  double totalValuesOfPortfolio = 0.0;
  SharedPreferences? sharedPreferences;

  TextEditingController? coinCountTextEditingController;
  TextEditingController? coinCountEditTextEditingController;
  final dbHelper = DatabaseHelper.instance;
  List<PortfolioBitcoin> items = [];

  @override
  void initState() {
    // fetchRemoteValue();
    callGraphApi();
    coinCountTextEditingController = new TextEditingController();
    coinCountEditTextEditingController = new TextEditingController();
    dbHelper.queryAllRows().then((notes) {
      notes.forEach((note) {
        items.add(PortfolioBitcoin.fromMap(note));
        totalValuesOfPortfolio = totalValuesOfPortfolio + note["total_value"];
      });
      setState(() {});
    });
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

      // await remoteConfig.fetch(expiration: const Duration(seconds: 30));
      // await remoteConfig.activateFetched();
      URL = remoteConfig.getString('immediate_image').trim();

      print(URL);
      setState(() {

      });
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
    callGraphApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image:AssetImage("assets/image/trends.png"),fit: BoxFit.fill
                )
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
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
                      Text("Trends", style: GoogleFonts.openSans(textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),)
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child:  Text('\$ $coin',textAlign: TextAlign.left,
                          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text('$name',textAlign: TextAlign.left,
                                style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w400),
                              )
                            ),
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: <Widget>[
                                    Text(diffRate < 0 ? '-' : "+", style: TextStyle(fontSize: 16, color: diffRate < 0 ? Colors.red : Colors.green)),
                                    Icon(Icons.attach_money, size: 16, color: diffRate < 0 ? Colors.red : Colors.green),
                                    Text('$result', style: TextStyle(fontSize: 16, color: diffRate < 0 ? Colors.red : Colors.green)),
                                  ],
                                ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      ButtonTheme(
                        minWidth: 50.0, height: 40.0,
                        child: ElevatedButton(
                          child: new Text("Week" , style: const TextStyle(fontSize: 15)
                          ),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(graphButton == 1 ? const Color(0xff111622):const Color(0xff2e3546)),
                              backgroundColor: MaterialStateProperty.all<Color>(graphButton == 1 ? const Color(0xff2e3546) : const Color(0xff111622),),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    // side: BorderSide(color: Color(0xfff4f727))
                                  )
                              )
                          ),
                          // textColor: buttonType == 3 ? Color(0xff96a5ff) : Colors.white,
                          // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0),),
                          // color: buttonType == 3 ? Colors.white : Color(0xff96a5ff),
                          onPressed: () {
                            setState(() {
                              graphButton = 1;
                              _type = "Week";
                              callGraphApi();
                            });
                          },
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 50.0, height: 40.0,
                        child: ElevatedButton(
                          child: new Text("Month" , style: const TextStyle(fontSize: 15)
                          ),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(graphButton == 2 ? const Color(0xff111622):const Color(0xff2e3546)),
                              backgroundColor: MaterialStateProperty.all<Color>(graphButton == 2 ? const Color(0xff2e3546) : const Color(0xff111622),),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    // side: BorderSide(color: Color(0xfff4f727))
                                  )
                              )
                          ),
                          // textColor: buttonType == 3 ? Color(0xff96a5ff) : Colors.white,
                          // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0),),
                          // color: buttonType == 3 ? Colors.white : Color(0xff96a5ff),
                          onPressed: () {
                            setState(() {
                              graphButton = 2;
                              _type = "Month";
                              callGraphApi();
                            });
                          },
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 50.0, height: 40.0,
                        child: ElevatedButton(
                          child: new Text("Year" , style: const TextStyle(fontSize: 15)
                          ),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(graphButton == 3 ? const Color(0xff111622):const Color(0xff2e3546)),
                              backgroundColor: MaterialStateProperty.all<Color>(graphButton == 3 ? const Color(0xff2e3546) : const Color(0xff111622),),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    // side: BorderSide(color: Color(0xfff4f727))
                                  )
                              )
                          ),
                          // textColor: buttonType == 3 ? Color(0xff96a5ff) : Colors.white,
                          // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0),),
                          // color: buttonType == 3 ? Colors.white : Color(0xff96a5ff),
                          onPressed: () {
                            setState(() {
                              graphButton = 3;
                              _type = "Year";
                              callGraphApi();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child:Container(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(),
                            child:  Row(children: <Widget>[

                              Container(
                                  width: MediaQuery.of(context).size.width ,
                                  height: MediaQuery.of(context).size.height / 2,
                                  //   height :MediaQuery.of(context).size.height,
                                  //     width: MediaQuery.of(context).size.width,
                                  child: SfCartesianChart(
                                    isTransposed: false,
                                    plotAreaBorderWidth: 0,
                                    enableAxisAnimation: true,
                                    enableSideBySideSeriesPlacement: true,
                                    //  plotAreaBackgroundColor:Colors.blue.shade100 ,
                                    series: <ChartSeries>[
                                      // Renders spline chart
                                      ColumnSeries<CartData, double>(
                                        dataSource: currencyData,
                                        xValueMapper: (CartData data, _) => data.date,
                                        yValueMapper: (CartData data, _) => data.rate,
                                        pointColorMapper:(CartData data, _) => data.color,

                                      ),
                                    ],
                                    primaryXAxis: NumericAxis(

                                      isVisible: true,
                                      borderColor: const Color(0xff3e475a),

                                    ),
                                    primaryYAxis: NumericAxis(
                                        isVisible: true,
                                        borderColor: const Color(0xff3e475a)
                                      // edgeLabelPlacement: EdgeLabelPlacement.shift,
                                    ),
                                  )
                              )
                            ],),
                          ),

                        ],
                      ),
                    ),

                  ),
                  SizedBox(
                    width:300,
                    child: TextButton(
                      onPressed: (){
                        showPortfolioDialog(name,coin);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffff0000)),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ),
                      ),
                      child: const Text("Add Coins",
                        style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
            ),

      ),
    );
  }


  Future<void> callGraphApi() async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await _sprefs;
    var currencyName = prefs.getString("currencyName") ?? 'BTC';
    currencyNameForImage = currencyName;
    var uri = 'http://45.34.15.25:8080/Bitcoin/resources/getBitcoinGraph?type=$_type&name=$currencyName';

    print(uri);
    var response = await get(Uri.parse(uri));
    //  print(response.body);
    final data = json.decode(response.body) as Map;
    //print(data);
    if(data['error'] == false){
      setState(() {
        bitcoinDataList = data['data'].map<Bitcoin>((json) =>
            Bitcoin.fromJson(json)).toList();
        double count = 0;
        var color = const Color(0xffF13434),

        diffRate = double.parse(data['diffRate']);
        if(diffRate < 0)
          result = data['diffRate'].replaceAll("-", "");
        else
          result = data['diffRate'];

        currencyData = [];
        bitcoinDataList.forEach((element) {
          currencyData.add(CartData(count, element.rate!,color));
          name = element.name!;
          String step2 = element.rate!.toStringAsFixed(2);
          double step3 = double.parse(step2);
          coin = step3;
          count = count+1;
          color = count % 2 == 0 ?const Color(0xffF13434) : const Color(0xff00B84A);
        });
        //  print(currencyData.length);
        isLoading = false;
      }
      );
    }
    else {
      //  _ackAlert(context);
    }
  }

  Future<void> showPortfolioDialog(String name, double coin) async {
    showCupertinoModalPopup(
        context: context,
        builder: (ctxt) => Container(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(color: Color(0xff1a202e)
              ),
              child: ListView(
                //mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              InkWell(
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                onTap: (){
                                  Navigator.pop(context);
                                },
                              ),
                              const Spacer(),
                              const Text("Add Coins",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                                textAlign: TextAlign.start,
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            decoration: BoxDecoration(color: Color(0xff2e3546),
                              border: Border.all(color: Color(0xffc30508)
                             ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: FadeInImage(
                                    height: 70,
                                    placeholder: const AssetImage('assets/image/cob.png'),
                                    image: NetworkImage(
                                        "http://45.34.15.25:8080/Bitcoin/resources/icons/${name!.toLowerCase()}.png"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(name,
                                          style: const TextStyle(fontSize: 15, color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment:  MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(diffRate < 0 ? '-' : "+", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color: diffRate < 0 ? Colors.red : Colors.green)),
                                              Icon(Icons.attach_money, size: 20, color: diffRate < 0 ? Colors.red : Colors.green),
                                              Text('$result', textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color: diffRate < 0 ? Colors.red : Colors.green)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text('\$$coin',
                                            style: const TextStyle(fontSize: 25,
                                                fontWeight:FontWeight.bold,color:Colors.white)
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Form(
                              key: _formKey2,
                              child: TextFormField(
                                controller: coinCountTextEditingController,
                                style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color:Colors.white),textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.white,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (val) {
                                  if (coinCountTextEditingController!.text == "" || int.parse(coinCountTextEditingController!.value.text) <= 0) {
                                    return "atleast add 1 coin";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 200,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SizedBox(
                        width:300,
                        child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffff0000)),
                          ),
                          child: const Text("ADD Coins",
                            textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                fontSize: 15),),
                          // color: Colors.blueAccent,
                          onPressed: (){
                            _addSaveCoinsToLocalStorage(name,coin);
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  _addSaveCoinsToLocalStorage(String name,double rate) async {
    if (_formKey2.currentState!.validate()) {
      if (items.length > 0) {
        PortfolioBitcoin? bitcoinLocal =
        items.firstWhereOrNull(
                (element) => element.name == name);

        if (bitcoinLocal != null) {
          Map<String, dynamic> row = {
            DatabaseHelper.columnName: name,
            DatabaseHelper.columnRateDuringAdding: rate,
            DatabaseHelper.columnCoinsQuantity:
            double.parse(coinCountTextEditingController!.value.text) +
                bitcoinLocal.numberOfCoins,
            DatabaseHelper.columnTotalValue:
            double.parse(coinCountTextEditingController!.value.text) *
                (rate!) +
                bitcoinLocal.totalValue,
          };
          final id = await dbHelper.update(row);
          print('inserted row id: $id');
        } else {
          Map<String, dynamic> row = {
            DatabaseHelper.columnName: name,
            DatabaseHelper.columnRateDuringAdding: rate,
            DatabaseHelper.columnCoinsQuantity:
            double.parse(coinCountTextEditingController!.value.text),
            DatabaseHelper.columnTotalValue:
            double.parse(coinCountTextEditingController!.value.text) *
                (rate!),
          };
          final id = await dbHelper.insert(row);
          print('inserted row id: $id');
        }
      } else {
        Map<String, dynamic> row = {
          DatabaseHelper.columnName: name,
          DatabaseHelper.columnRateDuringAdding: rate,
          DatabaseHelper.columnCoinsQuantity:
          double.parse(coinCountTextEditingController!.text),
          DatabaseHelper.columnTotalValue:
          double.parse(coinCountTextEditingController!.value.text) *
              (rate!),
        };
        final id = await dbHelper.insert(row);
        print('inserted row id: $id');
      }

      sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        sharedPreferences!.setString("currencyName", name!);
        sharedPreferences!.setString("title", "Portfolio");
        sharedPreferences!.commit();
      });
      Navigator.pushNamedAndRemoveUntil(context, '/portPage', (r) => false);
    } else {}
  }
}


class CartData {
  final double date;
  final double rate;
  final Color color;

  CartData(this.date, this.rate,this.color);
}