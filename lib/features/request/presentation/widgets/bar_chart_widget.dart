import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:modbus_app/resources/size_config/size_config.dart';

class BarChartWidget extends StatelessWidget {
  final List<double> values = [];

  BarChartWidget({super.key, required List<int> values, required double gain}) {
    // set values to double
    for (int i = 0; i < values.length; i++) {
      this.values.add(values[i].toDouble() * gain);
    }
  }

  double _getMaxValue() {
    if (values.isEmpty) {
      return 0;
    }

    double max = values[0];
    for (double value in values) {
      if (value > max) {
        max = value;
      }
    }

    // approximate to nearest 5
    max = (max / 5).ceil() * 5;
    return max.toDouble();
  }

  double _getMinValue() {
    if (values.isEmpty) {
      return 0;
    }

    double min = values[0];
    for (double value in values) {
      if (value < min) {
        min = value;
      }
    }

    // approximate to nearest 5
    min = (min / 5).floor() * 5;
    return min.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return SizedBox(
        height: getHeight(40),
        child: Center(
          child: Text(
            'No data',
            style: TextStyle(
              fontSize: getHeight(15),
              color: Colors.grey[800],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(right: getWidth(15)),
      child: SizedBox(
        height: getHeight(520),
        width: double.infinity,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _getMaxValue(),
            minY: _getMinValue(),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Colors.black, width: 1),
                bottom: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: getWidth(30),
                ),
              ),
            ),
            barGroups: List.generate(
              values.length,
              (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: values[i].toDouble(),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
