import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;

class StatsPage extends StatefulWidget {
  final String matricula;
  StatsPage({this.matricula});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<charts.Series<dynamic, String>> _seriesData;
  String aguilasPct = '';
  String birdiesPct = '';
  String paresPct = '';
  String bogiesPct = '';
  String dbogiesPct = '';
  String tbogiesPct = '';

  @override
  void initState() {
    super.initState();
    _obtenerEstadisticas();
  }

  void _obtenerEstadisticas() async {
    String url = "https://scoring.com.ar/app/api/api3/rc-api-golf/core/rc/Estadisticas_golpes.php?matricula=${widget.matricula}";
    var respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      var datos = json.decode(respuesta.body);

      // Define una lista de colores
      final List<charts.Color> colorList = [
        charts.MaterialPalette.cyan.shadeDefault,
        charts.MaterialPalette.blue.shadeDefault,
        charts.MaterialPalette.green.shadeDefault,
        charts.MaterialPalette.deepOrange.shadeDefault,
        charts.MaterialPalette.purple.shadeDefault,
        charts.MaterialPalette.pink.shadeDefault,
      ];

      _seriesData = [
        charts.Series(
          id: "Resultados",
          domainFn: (data, _) => data['name'],
          measureFn: (data, _) => int.parse(data['value'].replaceAll("%", "")),
          data: [
            {"name": "Aguilas", "value": datos['aguilas_pct']},
            {"name": "Birdies", "value": datos['birdies_pct']},
            {"name": "Pares", "value": datos['pares_pct']},
            {"name": "Bogeys", "value": datos['bogeys_pct']},
            {"name": "Doble Bogeys", "value": datos['doble_bogeys_pct']},
            {"name": "Triple Bogeys", "value": datos['triple_bogeys_pct']},
          ],
          // Asigna un color a cada valor de la lista de datos
          colorFn: (_, index) => colorList[index],
          labelAccessorFn: (data, _) => "${data['name']}: ${data['value']}",
        ),
      ];

      aguilasPct = datos['aguilas_pct'];
      birdiesPct = datos['birdies_pct'];
      paresPct = datos['pares_pct'];
      bogiesPct = datos['bogeys_pct'];
      dbogiesPct = datos['doble_bogeys_pct'];
      tbogiesPct = datos['triple_bogeys_pct'];

      setState(() {});
    }
  }

  List statsList = [];
  bool isLoading = false;
  TextEditingController matriculaController = TextEditingController();

  Future<void> searchStats(String matricula) async {

    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://scoring.com.ar/app/api/api3/rc-api-golf/core/rc/Estadisticas.php?matricula=$matricula'));

    if (response.statusCode == 200) {
      setState(() {
        statsList = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        statsList = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estadísticas de golf'),
        backgroundColor: Color(0xFF1f2f50),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child:
                Container(
                  height: 38,
                  child: TextField(
                    style: TextStyle(fontSize: 20),
                    controller: matriculaController,
                    decoration: InputDecoration(
                      labelText: 'Licencia',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    searchStats(matriculaController.text);
                  },
                  child: Text('Buscar'),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF1f2f50), width: 5),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      statsList.isNotEmpty ? statsList[0]['player_image'] : '',
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Container(
                  height: 80,
                  child: Column(
                    children: [
                      Container(
                        width: 278,
                        height: 35,
                        child: Text(
                          statsList.isNotEmpty ? statsList[0]['player_name'] : '',
                          style: TextStyle(fontSize: 38, color: Colors.black, fontWeight: FontWeight.bold,
                            fontFamily: 'DIN Condensed',),
                          textScaleFactor: 1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 110,
                        height: 5.0,
                      child: Container(
                        color: Color(0xFF1f2f50),
                      ),
                      ),
                      Container(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                color: Color(0xFF00deff),
                                height: 15,
                                width: 15,
                              ),
                              Container(
                                height: 15,
                                child: Text(' Aguila o + ', style: TextStyle(fontSize: 12), textScaleFactor: 1),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                color: Color(0xFF4e7dff),
                                height: 15,
                                width: 15,
                              ),
                              Container(
                                height: 15,
                                child: Text(' Birdie ', style: TextStyle(fontSize: 12), textScaleFactor: 1),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                color: Color(0xFF2c9700),
                                height: 15,
                                width: 15,
                              ),
                              Container(
                                height: 15,
                                child: Text(' Par ', style: TextStyle(fontSize: 12), textScaleFactor: 1),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                color: Color(0xFFf65b00),
                                height: 15,
                                width: 15,
                              ),
                              Container(
                                height: 15,
                                child: Text(' Bogey ', style: TextStyle(fontSize: 12), textScaleFactor: 1),
                              ),
                            ],
                          ),

                        ],
                      ),
                      Container(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                color: Color(0xFF9b0066),
                                height: 15,
                                width: 15,
                              ),
                              Container(
                                height: 15,
                                child: Text(' Doble Bogey ', style: TextStyle(fontSize: 12), textScaleFactor: 1),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                color: Color(0xFF890000),
                                height: 15,
                                width: 15,
                              ),
                              Container(
                                height: 15,
                                child: Text(' Triple Bogey o +', style: TextStyle(fontSize: 12), textScaleFactor: 1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.topCenter,
              height: 230,
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            color: Colors.cyan,
                            height: 25,
                            width: 20,
                          ),
                          Container(
                            height: 20,
                            width: 5,
                          ),
                          Container(
                            child: Text(aguilasPct, style: TextStyle(fontSize: 25), textAlign: TextAlign.right,textScaleFactor: 1),
                          ),
                          Container(
                            height: 20,
                            child: Text('% Aguila -', style: TextStyle(fontSize: 15), textScaleFactor: 1),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            color: Colors.blue,
                            height: 25,
                            width: 20,
                          ),
                          Container(
                            height: 25,
                            width: 5,
                          ),
                          Container(
                            child: Text(birdiesPct, style: TextStyle(fontSize: 25), textAlign: TextAlign.right,textScaleFactor: 1),
                          ),Container(
                            height: 20,
                            child: Text('% Birdie', style: TextStyle(fontSize: 15), textScaleFactor: 1),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            color: Colors.green,
                            height: 25,
                            width: 20,
                          ),
                          Container(
                            height: 25,
                            width: 5,
                          ),
                          Container(
                            child: Text(paresPct, style: TextStyle(fontSize: 25), textAlign: TextAlign.right,textScaleFactor: 1),
                          ),Container(
                            height: 20,
                            child: Text('% Par', style: TextStyle(fontSize: 15), textScaleFactor: 1),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            color: Colors.deepOrange,
                            height: 25,
                            width: 20,
                          ),
                          Container(
                            height: 25,
                            width: 5,
                          ),
                          Container(
                            child: Text(bogiesPct, style: TextStyle(fontSize: 25), textAlign: TextAlign.right,textScaleFactor: 1),
                          ),Container(
                            height: 20,
                            child: Text('% Bogey', style: TextStyle(fontSize: 15), textScaleFactor: 1),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            color: Colors.purple,
                            height: 25,
                            width: 20,
                          ),
                          Container(
                            height: 25,
                            width: 5,
                          ),
                          Container(
                            child: Text(dbogiesPct, style: TextStyle(fontSize: 25), textAlign: TextAlign.right,textScaleFactor: 1),
                          ),Container(
                            height: 20,
                            child: Text('% D.Bogey', style: TextStyle(fontSize: 15), textScaleFactor: 1),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            color: Colors.pink,
                            height: 25,
                            width: 20,
                          ),
                          Container(
                            height: 25,
                            width: 5,
                          ),
                          Container(
                            child: Text(tbogiesPct, style: TextStyle(fontSize: 25), textAlign: TextAlign.right,textScaleFactor: 1),
                          ),Container(
                            height: 20,
                            child: Text('% T.Bogey +', style: TextStyle(fontSize: 15), textScaleFactor: 1),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  Container(
                    height: 130,
                    width: 130,
                    child: Center(
                      child: (_seriesData != null)
                          ? charts.PieChart(
                        _seriesData,
                        animate: true,
                        defaultRenderer: charts.ArcRendererConfig(
                          arcWidth: 35,
                          arcRendererDecorators: [
                            // charts.ArcLabelDecorator(
                            //   labelPosition: charts.ArcLabelPosition.auto,
                            //   leaderLineStyleSpec: charts.ArcLabelLeaderLineStyleSpec(
                            //     length: 0,
                            //     color: charts.Color.black,
                            //     thickness: 1,
                            //   ),
                            // )
                          ],
                        ),
                      )
                          : CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : statsList.isEmpty
                  ? Center(
                child: Text('No se encontraron estadísticas.'),
              )
                  : ListView.builder(
                itemCount: statsList.length,
                itemBuilder: (context, index) {
                  final stats = statsList[index];
                  return ListTile(
                    title: Container(
                      height: 150,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 130,
                                    width: 45,
                                    child: Image.network(
                                      '${stats['club_image']}',
                                        fit: BoxFit.cover
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        height: 40,
                                        width: 60,
                                        child: Image.network(
                                            '${stats['club_logo']}',
                                            fit: BoxFit.contain
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: 200,
                                          child: Text(stats['club_name'],
                                            style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
                                            textScaleFactor: 1,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Text('${stats['start_date']}',
                                          style: TextStyle(fontSize: 15, color: Colors.red),
                                          textScaleFactor: 1,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end, // añadido
                                  children: [
                                    Container(
                                      color: Colors.amberAccent,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 43,
                                            child: Text(
                                              ' ${stats['total_score_neto']} ',
                                              style: TextStyle(fontSize: 40, fontFamily:
                                              'DIN Condensed', color: Colors.black),
                                              textScaleFactor: 1,
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 5,
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: 55,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start, // añadido
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                color: Color(0xFF00deff),
                                                height: 15,
                                                width: 15,
                                              ),
                                              Text(
                                                ' ${stats['aguilas_pct']}',
                                                style: TextStyle(fontSize: 15, color: Colors.black),
                                                textScaleFactor: 1,
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                color: Color(0xFF4e7dff),
                                                height: 15,
                                                width: 15,
                                              ),
                                              Text(
                                                ' ${stats['birdies_pct']}',
                                                style: TextStyle(fontSize: 15, color: Colors.black),
                                                textScaleFactor: 1,
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                color: Color(0xFF2c9700),
                                                height: 15,
                                                width: 15,
                                              ),
                                              Text(
                                                ' ${stats['pares_pct']}',
                                                style: TextStyle(fontSize: 15, color: Colors.black),
                                                textScaleFactor: 1,
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 5,
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: 55,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start, // añadido
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                color: Color(0xFFf65b00),
                                                height: 15,
                                                width: 15,
                                              ),
                                              Text(
                                                ' ${stats['bogeys_pct']}',
                                                style: TextStyle(fontSize: 15, color: Colors.black),
                                                textScaleFactor: 1,
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                color: Color(0xFF9b0066),
                                                height: 15,
                                                width: 15,
                                              ),
                                              Text(
                                                ' ${stats['doble_bogeys_pct']}',
                                                style: TextStyle(fontSize: 15, color: Colors.black),
                                                textScaleFactor: 1,
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                color: Color(0xFF890000),
                                                height: 15,
                                                width: 15,
                                              ),
                                              Text(
                                                ' ${stats['triple_bogeys_pct']}',
                                                style: TextStyle(fontSize: 15, color: Colors.black),
                                                textScaleFactor: 1,
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
