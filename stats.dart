import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
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
            SizedBox(height: 16.0),
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
                      // child: Text(stats['club_name'],
                      //   style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                      //   textScaleFactor: 1,
                      //   textAlign: TextAlign.start,
                      // ),
                    ),
                    // subtitle: Container(
                    //   child: Text('${stats['start_date']}',
                    //     style: TextStyle(fontSize: 13, color: Colors.red),
                    //     textScaleFactor: 1,
                    //     textAlign: TextAlign.start,
                    //   ),
                    // ),
                    // trailing: Container(
                    //   height: 90,
                    //   // width: 165,
                    //   child: Column(
                    //     children: [
                    //       Text(stats['club_name'],
                    //         style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                    //         textScaleFactor: 1,
                    //         textAlign: TextAlign.start,
                    //       ),
                    //       Text('${stats['start_date']}',
                    //         style: TextStyle(fontSize: 13, color: Colors.red),
                    //         textScaleFactor: 1,
                    //         textAlign: TextAlign.start,
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         crossAxisAlignment: CrossAxisAlignment.end, // añadido
                    //         children: [
                    //           Container(
                    //             color: Colors.amberAccent,
                    //             child: Column(
                    //               children: [
                    //                 Container(
                    //                   height: 10,
                    //                 ),
                    //                 Container(
                    //                   height: 35,
                    //                   child: Text(
                    //                     ' ${stats['total_score_neto']} ',
                    //                     style: TextStyle(fontSize: 40, fontFamily:
                    //                     'DIN Condensed', color: Colors.black),
                    //                     textScaleFactor: 1,
                    //                     textAlign: TextAlign.start,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           Container(
                    //             width: 5,
                    //           ),
                    //           Container(
                    //             alignment: Alignment.centerLeft,
                    //             width: 55,
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.start,
                    //               crossAxisAlignment: CrossAxisAlignment.start, // añadido
                    //               children: [
                    //                 Row(
                    //                   children: [
                    //                     Container(
                    //                       color: Color(0xFF00deff),
                    //                       height: 15,
                    //                       width: 15,
                    //                     ),
                    //                     Text(
                    //                       ' ${stats['aguilas_pct']}',
                    //                       style: TextStyle(fontSize: 15, color: Colors.black),
                    //                       textScaleFactor: 1,
                    //                       textAlign: TextAlign.start,
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 Row(
                    //                   children: [
                    //                     Container(
                    //                       color: Color(0xFF4e7dff),
                    //                       height: 15,
                    //                       width: 15,
                    //                     ),
                    //                     Text(
                    //                       ' ${stats['birdies_pct']}',
                    //                       style: TextStyle(fontSize: 15, color: Colors.black),
                    //                       textScaleFactor: 1,
                    //                       textAlign: TextAlign.start,
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 Row(
                    //                   children: [
                    //                     Container(
                    //                       color: Color(0xFF2c9700),
                    //                       height: 15,
                    //                       width: 15,
                    //                     ),
                    //                     Text(
                    //                       ' ${stats['pares_pct']}',
                    //                       style: TextStyle(fontSize: 15, color: Colors.black),
                    //                       textScaleFactor: 1,
                    //                       textAlign: TextAlign.start,
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           Container(
                    //             width: 5,
                    //           ),
                    //           Container(
                    //             alignment: Alignment.centerLeft,
                    //             width: 55,
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.start,
                    //               crossAxisAlignment: CrossAxisAlignment.start, // añadido
                    //               children: [
                    //                 Row(
                    //                   children: [
                    //                     Container(
                    //                       color: Color(0xFFf65b00),
                    //                       height: 15,
                    //                       width: 15,
                    //                     ),
                    //                     Text(
                    //                       ' ${stats['bogeys_pct']}',
                    //                       style: TextStyle(fontSize: 15, color: Colors.black),
                    //                       textScaleFactor: 1,
                    //                       textAlign: TextAlign.start,
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 Row(
                    //                   children: [
                    //                     Container(
                    //                       color: Color(0xFF9b0066),
                    //                       height: 15,
                    //                       width: 15,
                    //                     ),
                    //                     Text(
                    //                       ' ${stats['doble_bogeys_pct']}',
                    //                       style: TextStyle(fontSize: 15, color: Colors.black),
                    //                       textScaleFactor: 1,
                    //                       textAlign: TextAlign.start,
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 Row(
                    //                   children: [
                    //                     Container(
                    //                       color: Color(0xFF890000),
                    //                       height: 15,
                    //                       width: 15,
                    //                     ),
                    //                     Text(
                    //                       ' ${stats['triple_bogeys_pct']}',
                    //                       style: TextStyle(fontSize: 15, color: Colors.black),
                    //                       textScaleFactor: 1,
                    //                       textAlign: TextAlign.start,
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //
                    //     ],
                    //   ),
                    // ),
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
