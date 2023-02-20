import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class Estadisticas extends StatefulWidget {
  final String matricula;
  Estadisticas({this.matricula});

  @override
  _EstadisticasState createState() => _EstadisticasState();
}

class _EstadisticasState extends State<Estadisticas> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Estadísticas")),
      body:
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
              height: 230,
              width: 230,
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
    );
  }
}
