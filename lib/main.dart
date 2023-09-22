import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset&timezone=auto&past_days=3'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final Map<String, dynamic> data = json.decode(response.body);

      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  double tempAvaerage(double a, double b) {
    return (a + b) / 2;
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather Report'),
        ),
        body: Center(
          child: FutureBuilder<Map<String, dynamic>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final data = snapshot.data;
                final Map<String, dynamic> dailyUnits = data?["daily_units"];
                final Map<String, dynamic> daily = data?["daily"];
                final List<String> timeList = List<String>.from(daily["time"]);
                final List<num> weatherCodeList =
                List<num>.from(daily["weathercode"]);
                final List<num> maxTempList =
                List<num>.from(daily["temperature_2m_max"]);
                final List<num> minTempList =
                List<num>.from(daily["temperature_2m_min"]);
                final List<String> sunriseList = List<String>.from(daily["sunrise"]);
                final List<String> sunsetList = List<String>.from(daily["sunset"]);

                final String timeFormat = dailyUnits["time"];
                final String weatherCodeFormat = dailyUnits["weathercode"];
                final String maxTempFormat = dailyUnits["temperature_2m_max"];
                final String minTempFormat = dailyUnits["temperature_2m_min"];
                final String sunriseFormat = dailyUnits["sunrise"];
                final String sunsetFormat = dailyUnits["sunset"];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Weather Icon
                          Icon(
                            Icons.wb_sunny,
                            // Replace with the appropriate icon based on weather condition
                            size: 100,
                            color: Colors.orange,
                          ),
                          //Date
                          Text(
                            'Current date: \n $timeFormat(22-09-2023) \n Min Temp : $minTempFormat \n Max temp : $maxTempFormat \n ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Current Temperature is 28
                          Text(
                            'Temperature',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' 28.0 C',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          // Weather Description
                          Text(
                            'Location : ${data?['timezone']}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('Day 1: \n'+timeList[0]+' '),Text('Day 2: \n'+timeList[1]+' '),Text('Day 3: \n'+timeList[2]+' '),],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('Min Temp : \n'+minTempList[0].toString()),Text('Min Temp : \n'+minTempList[1].toString()),Text('Min Temp : \n'+minTempList[2].toString()),],
                          ), Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('Max Temp : \n'+maxTempList[0].toString()),Text('Max Temp : \n'+maxTempList[1].toString()),Text('Max Temp : \n'+maxTempList[2].toString()),],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
