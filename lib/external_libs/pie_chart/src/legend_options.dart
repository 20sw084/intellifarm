import 'package:flutter/material.dart';
import 'package:intellifarm/external_libs/pie_chart/src/pie_chart.dart';
import 'package:intellifarm/external_libs/pie_chart/src/utils.dart';

class LegendOptions {
  final bool showLegends;
  final bool showLegendsInRow;
  final TextStyle legendTextStyle;
  final BoxShape legendShape;
  final LegendPosition legendPosition;
  final Map<String,String> legendLabels;

  const LegendOptions({
    this.showLegends = true,
    this.showLegendsInRow = false,
    this.legendTextStyle = defaultLegendStyle,
    this.legendShape = BoxShape.circle,
    this.legendPosition = LegendPosition.right,
    this.legendLabels = const {},
  });
}
