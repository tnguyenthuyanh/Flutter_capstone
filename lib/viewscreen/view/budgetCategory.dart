import 'package:cap_project/View_Model/budgetCategory_ViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class AddCategory extends StatefulWidget {
  static const routeName = '/AddCategory';

  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  late BudgetCategoryViewModel budgetCategory;
  @override
  Widget build(BuildContext context) {
    budgetCategory = Provider.of<BudgetCategoryViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Budget Categories'),
      ),
      body: Column(
        children: [
          Text("Select a Category"),
          Column(
            
            children: List<Chip>.generate(
              budgetCategory.categories.length,
              (counter) => Chip(
                //for (int i = 0; i < budgetCategory.categories.length; i++)
                label: Text(budgetCategory.categories[counter])    
              ),
            ),
          ),
        ],
      ),
    );
  }
}
