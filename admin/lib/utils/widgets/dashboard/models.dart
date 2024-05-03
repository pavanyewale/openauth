import 'package:admin/utils/widgets/dashboard/widgets/count.dart';
import 'package:flutter/material.dart';

class DashboardResponse {
  final List<Widget> widgets;
  final String error;

  DashboardResponse({this.widgets = const [], this.error = ''});

  factory DashboardResponse.fromSuccessJson(Map<String, dynamic> json) {
    return DashboardResponse(
      widgets: json['data']['dashboards'].map<Widget>((widget) {
        switch (widget['type']) {
          case 'count':
            return CountWidget.fromJson(widget);
        }
        return const SizedBox();
      }).toList(),
    );
  }

  factory DashboardResponse.fromErrorJson(Map<String, dynamic> json) {
    return DashboardResponse(error: json['error']);
  }
}
