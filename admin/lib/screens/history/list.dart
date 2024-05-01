import 'package:admin/apis/history.dart';
import 'package:admin/models/history/filters.dart';
import 'package:admin/models/history/history.dart';
import 'package:admin/screens/history/filters.dart';
import 'package:admin/screens/history/history_tile.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/utils/widgets/errors.dart';
import 'package:admin/utils/widgets/next_prev.dart';
import 'package:flutter/material.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final List<History> history = [];
  int limit = 10;
  int skip = 0;
  bool isLoading = false;
  String error = '';
  HistoryFilters filters = HistoryFilters();

  void fetchHistory() async {
    setState(() {
      isLoading = true;
    });

    final res = await HistoryService.getHistory(filters, limit, skip);
    if (res.error.isNotEmpty) {
      MyToast.error(res.error);
      setState(() {
        error = res.error;
        isLoading = false;
      });
      return;
    }
    setState(() {
      history.clear();
      history.addAll(res.history);
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //add history filters
        HistoryFiltersWidget(onFetchClicked: (filters) {
          this.filters = filters;
          fetchHistory();
        }),
        const Divider(),
        // add loading indicator
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (error.isNotEmpty) const MyErrorWidget(),
        if (error.isEmpty)
          ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return HistoryTile(history: history[index]);
              },
              itemCount: history.length),
        // next and prev buttons
        NextAndPrevPaginationButtons(
            onNextClicked: () {
              setState(() {
                skip += limit;
              });
              fetchHistory();
            },
            onPrevClicked: () {
              setState(() {
                skip -= limit;
              });
              fetchHistory();
            },
            isNext: history.length == limit,
            isPrev: skip > 0)
      ],
    );
  }
}
