import 'dart:convert';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leetcodestats/Modal/leetcode_stats_modal.dart';

// ignore: must_be_immutable
class UserData extends StatefulWidget {
  String username;
  UserData({required this.username});
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  LeetcodeStats stats = LeetcodeStats();
  Future<void> getData(LeetcodeStats stats, String username) async {
    //return void will not make change in snapshpt so returning something is important
    http.Response response;

    response = await http
        .get(Uri.parse("https://leetcode-stats-api.herokuapp.com/" + username));

    var data = jsonDecode(response.body.toString());
    print(data["totalSolved"]);

    stats.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stats")),
      body: FutureBuilder(
        //used for future functions
        future: getData(stats, widget.username),
        builder: (context, snapshot) {
          if (stats.status != "success" && stats.status != "error") {
            return Center(child: Text("loading...."));
          } else if (stats.status == "error") {
            return Center(
                child: Text(
              stats.message.toString() + "...try again",
              style: TextStyle(fontWeight: FontWeight.bold),
            ));
          } else {
            return Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 300,
                    width: 300,
                    child: PieChart(
                      colorList: [
                        Colors.green,
                        Colors.yellow,
                        Colors.red,
                      ],
                      chartType: ChartType.ring,
                      dataMap: {
                        "Easy": double.parse(stats.easySolved.toString()),
                        "Medium": double.parse(stats.mediumSolved.toString()),
                        "Hard": double.parse(stats.hardSolved.toString()),
                      },
                      chartValuesOptions:
                          ChartValuesOptions(showChartValuesInPercentage: true),
                    )),
              ),
              Container(
                height: 210,
                width: 400,
                child: Card(
                  borderOnForeground: true,
                  child: ListView(scrollDirection: Axis.vertical, children: [
                    _cardField("Total Solved", stats.totalSolved.toString()),
                    _cardField("Easy", stats.easySolved.toString()),
                    _cardField("Medium", stats.mediumSolved.toString()),
                    _cardField("Hard", stats.hardSolved.toString()),
                    _cardField(
                        "Acceptance Rate", stats.acceptanceRate.toString()),
                    _cardField("Ranking", stats.ranking.toString()),
                  ]),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ]);
          }
        },
      ),
    );
  }

  Widget _cardField(String title, String val) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(" " + title),
            Text(val + " "),
          ],
        ),
        Divider()
      ],
    );
  }
}
