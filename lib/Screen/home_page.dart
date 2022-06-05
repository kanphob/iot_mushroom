import 'package:flutter/material.dart';
import 'package:iot_mushroom/provider/home_page_provider.dart';
import 'package:iot_mushroom/provider/home_page_statistic_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:iot_mushroom/Constant/globals.dart';
import 'package:iot_mushroom/Utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math' as math;

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomePageProvider>(builder: (ctx, data, child) {
      return SafeArea(
          child: Scaffold(
              body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.account_box),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        data.sUserEmail,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  TextButton.icon(
                      onPressed: () {
                        data.signOut();
                      },
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.blue.shade700,
                      ),
                      label: Text(
                        "ออกจากระบบ",
                        style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600),
                      ))
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.listWidget.length,
                  itemBuilder: (context, index) {
                    return data.listWidget[index];
                  },
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: buildStatisticWidget(),
            ),
          ],
        ),
      )));
    });
  }

  Widget buildStatisticWidget() {
    return Consumer<HomePageStatisticProvider>(builder: (context, data, child) {
      return data.bDownloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : data.waitResult > 0
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: SingleChildScrollView(
                      child: !data.bBarChart
                          ? buildPieChart(context, data)
                          : buildBarChart(context, data)),
                )
              : Container();
    });
  }

  Widget buildPieChart(BuildContext context, HomePageStatisticProvider data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      const Text(
                        "ภาพรวม",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.green.shade100.withOpacity(0.4),
                            border: Border.all(
                                color: Colors.green.shade300.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: data.dropYear,
                            onChanged: (String? newValue) async {
                              await data.onChangeDropdown(newValue!);
                            },
                            items: data.listYear
                                .map<DropdownMenuItem<String>>((String value) {
                              int dValue = int.parse(value);
                              return DropdownMenuItem<String>(
                                value: value,
                                child: SizedBox(
                                  width: 75, // for example
                                  child: Text(
                                    (dValue).toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: data.bBarChart
                                ? Colors.white
                                : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(5)),
                        width: MediaQuery.of(context).size.width / 2,
                        child: IconButton(
                            icon: Icon(
                              Icons.pie_chart,
                              color: data.bBarChart
                                  ? Colors.grey.shade400
                                  : Colors.white,
                              size: 35,
                            ),
                            onPressed: () async {
                              await data.onChangeChartType(isBarChart: false);
                            }),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: data.bBarChart
                                ? Colors.green.shade100
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: IconButton(
                            icon: Icon(
                              Icons.insert_chart,
                              color: data.bBarChart
                                  ? Colors.white
                                  : Colors.grey.shade400,
                              size: 35,
                            ),
                            onPressed: () async {
                              await data.onChangeChartType(isBarChart: true);
                            }),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: PieChart(
            dataMap: data.dataMap,
            legendOptions: LegendOptions(
                legendTextStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey[900],
                    fontWeight: FontWeight.w500),
                showLegends: true,
                showLegendsInRow: false,
                legendPosition: LegendPosition.right),
            chartValuesOptions: const ChartValuesOptions(
              showChartValuesInPercentage: true,
              showChartValueBackground: false,
              showChartValues: true,
              decimalPlaces: 0,
              showChartValuesOutside: true,
              chartValueBackgroundColor: Colors.blueGrey,
            ),
            animationDuration: const Duration(milliseconds: 1200),
            chartLegendSpacing: 32.0,
            chartRadius: MediaQuery.of(context).size.width / 2.0,
            colorList: data.defaultColorList,
            initialAngleInDegree: math.pi * 0.5,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text(
              "ยอดคงเหลือ : ",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            Text(
              "${Utils.numberFormatter(data.dSumAll)} ฿",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ],
        )
      ],
    );
  }

  Widget buildBarChart(BuildContext context, HomePageStatisticProvider data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      const Text(
                        "ภาพรวม",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.green.shade100.withOpacity(0.4),
                            border: Border.all(
                                color: Colors.green.shade300.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: data.dropYear,
                            onChanged: (String? newValue) async {
                              await data.onChangeDropdown(newValue!);
                            },
                            items: data.listYear
                                .map<DropdownMenuItem<String>>((String value) {
                              int dValue = int.parse(value);
                              return DropdownMenuItem<String>(
                                value: value,
                                child: SizedBox(
                                  width: 75, // for example
                                  child: Text(
                                    (dValue).toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: data.bBarChart
                                ? Colors.white
                                : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(5)),
                        child: IconButton(
                            icon: Icon(
                              Icons.pie_chart,
                              color: data.bBarChart
                                  ? Colors.grey.shade400
                                  : Colors.white,
                              size: 35,
                            ),
                            onPressed: () async {
                              await data.onChangeChartType(isBarChart: false);
                            }),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: data.bBarChart
                                ? Colors.green.shade100
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: IconButton(
                            icon: Icon(
                              Icons.insert_chart,
                              color: data.bBarChart
                                  ? Colors.white
                                  : Colors.grey.shade400,
                              size: 35,
                            ),
                            onPressed: () async {
                              await data.onChangeChartType(isBarChart: true);
                            }),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SimpleBarChart(data.createSampleData()),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text(
              "ยอดคงเหลือ : ",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            Text(
              "${Utils.numberFormatter(data.dSumAll)} ฿",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ],
        )
      ],
    );
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  const SimpleBarChart(this.seriesList, {Key? key, this.animate = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: charts.BarChart(
        seriesList,
        animate: animate,
      ),
    );
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String sIncomeExpense;
  final int iAmount;

  OrdinalSales(this.sIncomeExpense, this.iAmount);
}
