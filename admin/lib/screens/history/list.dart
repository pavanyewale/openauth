import 'package:admin/apis/history.dart';
import 'package:admin/models/history/filters.dart';
import 'package:admin/models/history/history.dart';
import 'package:admin/screens/history/filters.dart';
import 'package:admin/screens/history/history_tile.dart';
import 'package:admin/utils/toast.dart';
import 'package:admin/utils/widgets/empty_list.dart';
import 'package:admin/utils/widgets/errors.dart';
import 'package:admin/utils/widgets/load_more.dart';
import 'package:admin/utils/widgets/loader_tile.dart';
import 'package:flutter/material.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final List<History> history = [];
  int limit = 10;
  int offset = 0;
  bool isLoading = false;
  String error = '';
  HistoryFilters filters = HistoryFilters();
  bool newFilters = false;
  bool loadMore = true;
  void fetchHistory() async {
    setState(() {
      isLoading = true;
    });

    final res = await HistoryService.getHistory(filters, limit, offset);
    if (res.error.isNotEmpty) {
      MyToast.error(res.error);
      setState(() {
        error = res.error;
        isLoading = false;
      });
      return;
    }
    if (newFilters) {
      history.clear();
      newFilters = false;
    }
    setState(() {
      loadMore = res.history.length == limit;
      history.addAll(res.history);
      error = '';
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
          offset = 0;
          newFilters = true;
          fetchHistory();
        }),
        const Divider(),
        if (error.isNotEmpty) const MyErrorWidget(),
        ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Divider(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return HistoryTile(history: history[index]);
            },
            itemCount: history.length),
        if (history.isEmpty && !isLoading && error.isEmpty)
          const EmptyListWidget(),
        if (isLoading) const LoaderTile(),
        // next and prev buttons
        if (loadMore)
          LoadMoreTile(onTap: () {
            offset += limit;
            fetchHistory();
          }),
      ],
    );
  }
}
