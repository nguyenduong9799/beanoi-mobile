import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';

import 'index.dart';

enum DateFilter { DAY, WEEK, MONTH, ALL }

class TransactionViewModel extends BaseModel {
  List<TransactionDTO> transactionList;
  TransactionDAO _transactionDAO;
  dynamic error;
  ScrollController scrollController;
  DateFilter selectedFilter = DateFilter.ALL;

  TransactionViewModel() {
    _transactionDAO = TransactionDAO();
    scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        int total_page =
            (_transactionDAO.metaDataDTO.total / DEFAULT_SIZE).ceil();
        if (total_page > _transactionDAO.metaDataDTO.page) {
          await getMoreTransactions();
        }
      }
    });
  }

  Future<void> changeStatus(DateFilter filter) async {
    selectedFilter = filter;
    await getTransactions();
  }

  Future<void> getTransactions() async {
    try {
      setState(ViewStatus.Loading);
      List<DateTime> dateFilters = processDateFilter();
      if (dateFilters.isNotEmpty) {
        transactionList = await _transactionDAO.getTransactions(
            fromDate: dateFilters[0], toDate: dateFilters[1]);
      } else {
        transactionList = await _transactionDAO.getTransactions();
      }

      if (transactionList == null || transactionList.isEmpty) {
        setState(ViewStatus.Empty);
      } else
        setState(ViewStatus.Completed);
    } catch (e, s) {
      print(e.toString() + s.toString());
      bool result = await showErrorDialog();
      if (result) {
        await getTransactions();
      } else
        setState(ViewStatus.Error);
    } finally {}
  }

  Future<void> getMoreTransactions() async {
    try {
      setState(ViewStatus.LoadMore);

      final data = await _transactionDAO.getTransactions(
          page: _transactionDAO.metaDataDTO.page + 1);

      transactionList += data;
      await Future.delayed(Duration(milliseconds: 1000));
      setState(ViewStatus.Completed);
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await getMoreTransactions();
      } else
        setState(ViewStatus.Error);
    }
  }

  List<DateTime> processDateFilter() {
    DateTime now = DateTime.now();
    int day = now.day;
    int month = now.month;
    int year = now.year;
    switch (selectedFilter) {
      case DateFilter.DAY:
        return [
          DateTime(year, month, day, 0, 0),
          DateTime(year, month, day, 23, 59)
        ];
      case DateFilter.WEEK:
        DateTime firstDayOfweek = now.subtract(Duration(days: now.weekday - 1));
        DateTime lastDayOfweek =
            now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
        return [firstDayOfweek, lastDayOfweek];
      case DateFilter.MONTH:
        int lastDay = DateTime(year, month + 1, 0).day;
        return [
          DateTime(year, month, 1, 0, 0),
          DateTime(year, month + 1, lastDay, 23, 59)
        ];
      default:
        return [];
    }
  }
}
