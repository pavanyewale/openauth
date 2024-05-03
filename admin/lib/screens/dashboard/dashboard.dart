import 'package:admin/utils/widgets/dashboard/models.dart';
import 'package:admin/utils/widgets/dashboard/service.dart';
import 'package:admin/utils/widgets/empty_list.dart';
import 'package:admin/utils/widgets/errors.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Widget> dashboards = [];
  bool isLoading = false;
  String error = '';

  fetchDashboardDetails() async {
    setState(() {
      isLoading = true;
    });

    DashboardResponse res = await DashboardService.getDashboardData();
    if (res.error.isNotEmpty) {
      setState(() {
        isLoading = false;
        error = res.error;
      });
      return;
    }

    setState(() {
      dashboards = res.widgets;
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchDashboardDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Dashboard", style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(
        height: 20,
      ),
      if (isLoading)
        const Center(
          child: CircularProgressIndicator(),
        ),
      if (error.isNotEmpty) const MyErrorWidget(),
      if (dashboards.isEmpty && !isLoading) const EmptyListWidget(),
      if (error.isEmpty)
        Center(
            child: Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: dashboards,
        ))
    ]);
  }
}
