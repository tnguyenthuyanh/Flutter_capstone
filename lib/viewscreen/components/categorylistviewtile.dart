import 'package:cap_project/model/catergories.dart';
import 'package:flutter/material.dart';

import 'my_listview_tile.dart';

class CategoryListViewTile extends StatelessWidget {
  final Category category;
  // final BudgetListMode currentMode;
  final Color _normalColor = Colors.grey[400]!;
  final Color _selectedForDeleteColor = Colors.red[400]!;

  CategoryListViewTile({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    // bool _stagedForDeletion =
    //     Provider.of<BudgetData>(context).isStagedForDeletion(budget);

    return MyListViewTile(
      middleValue: category.type,
      rightValue: category.isSelected! ? "Current" : "",
      backgroundColor:
          // _stagedForDeletion ? _selectedForDeleteColor : _normalColor,
          _normalColor,
      onTapCallback: () {
        print("Category " + category.type + " selected");

        // if (currentMode == BudgetListMode.delete) {
        //   if (_stagedForDeletion) {
        //     Provider.of<BudgetData>(context, listen: false)
        //         .unstageForDeletion(budget);
        //   } else {
        //     Provider.of<BudgetData>(context, listen: false)
        //         .stageForDeletion(budget);
        //   }
        // } else {
        //   Provider.of<BudgetData>(context, listen: false)
        //       .setSelectedBudget(budget);
        //   Navigator.pushNamed(context, BudgetDetailScreen.routeName);
        // }
      },
    );
  }
}
