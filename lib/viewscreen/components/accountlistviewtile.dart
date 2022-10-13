import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../View_Model/account_data.dart';
import '../../model/account.dart';
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
            Provider.of<AccountData>(context, listen: false)
                .unstageForDeletion(object);
          } else {
            Provider.of<AccountData>(context, listen: false)
                .stageForDeletion(object);
          }
        } else {
          // Provider.of<AccountData>(context, listen: false)
          //     .setSelected(object);
          // Navigator.pushNamed(context, AccountDetailScreen.routeName);
        }
      },
    );
  }
}
