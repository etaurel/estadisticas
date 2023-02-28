import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/rendering.dart';
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
  List statsList = [];
  bool isLoading = false;
  TextEditingController matriculaController = TextEditingController();
  final TextEditingController _controller = TextEditingController();

  void _onMatriculaChanged(String value) {
    matriculaController.text = value;
  }

  List<charts.Series<dynamic, String>> _seriesData;
  String aguilasPct = '';
  String birdiesPct = '';
  String paresPct = '';
  String bogiesPct = '';
  String dbogiesPct = '';
  String tbogiesPct = '';

  String _matricula = '';



  @override
  void initState() {
    super.initState();
    _matricula = widget.matricula;
    _obtenerEstadisticas();
  }

  void _obtenerEstadisticas() async {
    String url = "https://scoring.com.ar/app/api/api3/rc-api-golf/core/rc/Estadisticas_golpes.php?matricula=$_matricula";
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
          measureFn: (data, _) => (data['value'] != null) ? int.parse(data['value'].replaceAll("%", "")) : 0,
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

  final List<Color> backgroundColors = [  Colors.grey[100],
    Colors.grey[300],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              Text(
                  "ESTADISTICAS", style: TextStyle(fontSize: 20), textScaleFactor: 1,),
              Container(
                width: 120,
                padding: EdgeInsets.all(35.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/clubes/logoblanco.png'),
//                                    image: AssetImage('assets/Logo02.png'),
                      fit: BoxFit.contain),
                ),
              ),
            ],
          ),
          ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child:
                  Container(
                    height: 38,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 15),
                      controller: _controller,
                      onChanged: _onMatriculaChanged,
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
                      setState(() {
                        _matricula = _controller.text;
                        _obtenerEstadisticas();
                        searchStats(matriculaController.text);
                      });
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
                        statsList.isNotEmpty && statsList[0]['player_image'] != null
                            ? statsList[0]['player_image']
                            : 'assets/jugadores/1.jpg',
                        scale: 1.0,
                      ),
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
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Container(
                alignment: Alignment.topCenter,
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                    ),
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
                              child: Text(aguilasPct != null && aguilasPct.isNotEmpty ? aguilasPct : '-', style: TextStyle(fontSize: 25), textAlign: TextAlign.right,textScaleFactor: 1),
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
                              child: Text(birdiesPct != null && birdiesPct.isNotEmpty ? birdiesPct : '-', style: TextStyle(fontSize: 25), textAlign: TextAlign.right,textScaleFactor: 1),
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
                              child: Text(paresPct != null && paresPct.isNotEmpty ? paresPct : '-', style: TextStyle(fontSize: 25), textAlign: TextAlign.right,textScaleFactor: 1),
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
                              child: Text(bogiesPct != null && bogiesPct.isNotEmpty ? bogiesPct : '-', style: TextStyle(fontSize: 25), textAlign: TextAlign.right,textScaleFactor: 1),
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
                              child: Text(dbogiesPct != null && dbogiesPct.isNotEmpty ? dbogiesPct : '-', style: TextStyle(fontSize: 25), textAlign: TextAlign.right,textScaleFactor: 1),
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
                              child: Text(tbogiesPct != null && tbogiesPct.isNotEmpty ? tbogiesPct : '-', style: TextStyle(fontSize: 25), textAlign: TextAlign.right,textScaleFactor: 1),
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
                      // height: 225,
                      width: 200,
                      child: Center(
                        child: (_seriesData != null)
                            ? charts.PieChart(
                          _seriesData,
                          animate: true,
                          defaultRenderer: charts.ArcRendererConfig(
                            arcWidth: 35,
                            arcRendererDecorators: [
                            ],
                          ),
                        )
                            : CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 400,
                child: isLoading
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : statsList.isEmpty
                    ? Center(
                  child: Text('Ingrese el Número de Licencia para ver las Estadísticas',
                      style: TextStyle(fontSize: 18,
                      color: Colors.black),
                  textScaleFactor: 1,
                  textAlign: TextAlign.center),
                )
                    : ListView.builder(
                  itemCount: statsList.length,
                  itemBuilder: (context, index) {
                    final stats = statsList[index];
                    return Column(
                      children: [
                        Divider(
                          thickness: 1,
                          color: Colors.grey[400],
                        ),
                        ListTile(
                          tileColor: backgroundColors[index % backgroundColors.length],
                          title: Container(
                            height: 145,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        height: 135,
                                        width: 45,
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/clubes/1.jpg',
                                          image: stats['club_image'],
                                          fit: BoxFit.cover,
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
                                            height: 50,
                                            width: 80,
                                            child: FadeInImage.assetNetwork(
                                              placeholder: 'assets/clubes/1.png',
                                              image: stats['club_logo'],
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.all(5.0),
                                        //   child: Container(
                                        //     height: 50,
                                        //     width: 80,
                                        //     child: Image.network(
                                        //         '${stats['club_logo']}',
                                        //         fit: BoxFit.contain
                                        //     ),
                                        //   ),
                                        // ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              width: 180,
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
                                          color: Colors.cyanAccent,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 43,
                                                child: Text(
                                                  ' ${stats['total_score']} ',
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
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 18,
                                                child: Text('Hcp',
                                                  style: TextStyle(fontSize: 12,
                                                      color: Colors.black),
                                                  textScaleFactor: 1),
                                              ),
                                              Container(
                                                height: 35,
                                                child: Text(
                                                  ' ${stats['hcp_torneo']} ',
                                                  style: TextStyle(fontSize: 30, fontFamily:
                                                  'DIN Condensed', color: Colors.black),
                                                  textScaleFactor: 1,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          color: Color(0xFF1f2f50),
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
                                                  'DIN Condensed', color: Colors.white),
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
                                                    color: Colors.cyan,
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
                                                    color: Colors.blue,
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
                                                    color: Colors.green,
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
                                                    color: Colors.deepOrange,
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
                                                    color: Colors.purple,
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
                                                    color: Colors.pink,
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
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
