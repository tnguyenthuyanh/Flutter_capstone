import 'package:cap_project/viewscreen/budgetdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../View_Model/budget_data.dart';
import '../../model/budget.dart';
import '../../model/constant.dart';
import 'my_listview_tile.dart';

class BudgetListViewTile extends StatelessWidget {
  final Budget budget;
  final BudgetListMode currentMode;
  final Color _normalColor = Colors.grey[400]!;
  final Color _selectedForDeleteColor = Colors.red[400]!;

  BudgetListViewTile({required this.budget, required this.currentMode});

  @override
  Widget build(BuildContext context) {
    bool _stagedForDeletion =
        Provider.of<BudgetData>(context).isStagedForDeletion(budget);

    return MyListViewTile(
      middleValue: budget.title,
      rightValue: "Nope",
      backgroundColor:
          _stagedForDeletion ? _selectedForDeleteColor : _normalColor,
      onTapCallback: () {
        if (currentMode == BudgetListMode.delete) {
          if (_stagedForDeletion) {
            Provider.of<BudgetData>(context, listen: false)
                .unstageForDeletion(budget);
          } else {
            Provider.of<BudgetData>(context, listen: false)
                .stageForDeletion(budget);
          }
        } else {
          Provider.of<BudgetData>(context, listen: false)
              .setSelectedBudget(budget);
          Navigator.pushNamed(context, BudgetDetailScreen.routeName);
        }
      },
    );
  }
}
