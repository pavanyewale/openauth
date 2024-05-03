import 'package:admin/screens/dashboard/dashboard.dart';

class DashboardService {
  Future<> getDashboardData() async {
    final response = await http.get(_url);
    if (response.statusCode == 200) {
      return DashboardModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load dashboard data');
    }
  }
}
