import 'package:cap_project/viewscreen/budgetdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../View_Model/account_data.dart';
import '../../View_Model/budget_data.dart';
import '../../model/account.dart';
import '../../model/budget.dart';
import '../../model/constant.dart';
import 'my_listview_tile.dart';

class AccountListViewTile extends StatelessWidget {
  final Account object;
  final ListMode currentMode;
  final Color _normalColor = Colors.grey[400]!;
  final Color _selectedForDeleteColor = Colors.red[400]!;

  AccountListViewTile({required this.object, required this.currentMode});

  @override
  Widget build(BuildContext context) {
    bool _stagedForDeletion =
        Provider.of<AccountData>(context).isStagedForDeletion(object);

    return MyListViewTile(
      middleValue: object.title,
      rightValue: object.isCurrent! ? "Current" : "",
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
