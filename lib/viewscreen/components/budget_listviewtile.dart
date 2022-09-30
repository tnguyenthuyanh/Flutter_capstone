

import 'package:cap_project/viewscreen/budgetdetail_screen.dart';
import 'package:flutter/material.dart';

import '../../model/budget.dart';
import '../../model/constant.dart';
import 'my_listview_tile.dart';

class BudgetListViewTile extends StatelessWidget {
  final Budget budget;
  final BudgetListMode currentMode;
  // final Color _normalColor = Color.grey[400];
  // final Color _selectedForDeleteColor = Colors.red[900];

  BudgetListViewTile({required this.budget, required this.currentMode});

  @override
  Widget build(BuildContext context) {
    // TODO: Reimplement
    // bool _stagedForDeletion =
    //     Provider.of<BudgetData>(context).isStagedForDeletion(budget);
    return MyListViewTile(
        // leftValue: budget.getMonthName(),
        middleValue: budget.title,
        rightValue: "Nope",
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        onTapCallback: () {
          Navigator.pushNamed(context, BudgetDetailScreen.routeName);
        }
            // _stagedForDeletion ? _selectedForDeleteColor : _normalColor,
        // onTapCallback: () {
        //   if (currentMode == Mode.Delete) {
        //     if (_stagedForDeletion) {
        //       Provider.of<BudgetData>(context).unstageForDeletion(budget);
        //     } else {
        //       Provider.of<BudgetData>(context).stageForDeletion(budget);
        //     }
        //   } else {
        //     Provider.of<BudgetData>(context).setSelectedBudget(budget);
        //     Navigator.pushNamed(context, BudgetDetailScreen.routeName);
        //   }
        // }
    );
  }
}