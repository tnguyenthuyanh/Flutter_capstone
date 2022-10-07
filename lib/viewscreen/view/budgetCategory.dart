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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 12.0,
              children: List<GestureDetector>.generate(
                budgetCategory.categories.length + 1,
                (counter) => GestureDetector(
                  onTap: () {
                    if (counter == budgetCategory.categories.length) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            // ignore: prefer_const_constructors
                            return MyDialog();
                          });
                    } else {
                      budgetCategory.updateCategories(counter);
                    }
                  },
                  child: counter == budgetCategory.categories.length
                      ? const Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Icon(Icons.add),
                        )
                      : Chip(
                          deleteIcon: IconButton(
                            onPressed: () {
                              
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          backgroundColor:
                              budgetCategory.selectedCategoryIndex == counter
                                  ? Colors.white
                                  : Colors.blue,
                          label: Text(
                            budgetCategory.categories[counter],
                            style: TextStyle(
                              color: budgetCategory.selectedCategoryIndex ==
                                      counter
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyDialog extends StatelessWidget {
  //create a text editing controller, pass it to right place and validate the text
  //late Controller con;
  late BudgetCategoryViewModel budgetCategory;

  var formKey = GlobalKey<FormState>();
  MyDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    budgetCategory = Provider.of<BudgetCategoryViewModel>(context);
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Stack(
          children: [
            Positioned(
              right: -10,
              top: -15,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ),
            Text('Add a Category'),
          ],
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            validator: (value) => budgetCategory.validateText(value),
            controller: budgetCategory.textFormValidator,
            decoration: const InputDecoration(labelText: "New Category"),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                budgetCategory.addCategory();
                Navigator.pop(context);
              }

              //Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      );
    });
  }

  // if (passController.text.isEmpty) {
  //   showToast('Please provide a password');
  // } else {
  //   showToast("Success!!");
  // }
}
