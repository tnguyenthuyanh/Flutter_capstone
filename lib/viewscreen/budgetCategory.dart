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

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState

    // ignore: unnecessary_new
    new Future.delayed(Duration.zero, () {
      budgetCategory =
          Provider.of<BudgetCategoryViewModel>(context, listen: false);
      budgetCategory.getCategories();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    budgetCategory = Provider.of<BudgetCategoryViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Budget Categories'),
      ),
      body: Column(
        children: [
          const Text("Select a Category"),
          budgetCategory.isCategoriesLoading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 12.0,
                    children: List<GestureDetector>.generate(
                      budgetCategory.categoriess.length + 1,
                      (counter) => GestureDetector(
                        onTap: () {
                          if (counter == budgetCategory.categoriess.length) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  // ignore: prefer_const_constructors
                                  return MyDialog(isFromSubCategory: true);
                                });
                          } else {
                            budgetCategory.updateSubCategories(counter);
                          }
                        },
                        child: counter == budgetCategory.categoriess.length
                            ? const Padding(
                                padding: EdgeInsets.only(top: 12.0),
                                child: Icon(Icons.add),
                              )
                            : Chip(
                                deleteIcon: Icon(Icons.clear,
                                    color: budgetCategory
                                            .categoriess[counter].isSelected
                                        ? Colors.black
                                        : Colors.white),
                                onDeleted: budgetCategory
                                            .categoriess[counter].type
                                            .toLowerCase() ==
                                        "global"
                                    ? null
                                    : () {
                                        budgetCategory.deleteCategory(counter);
                                      },
                                backgroundColor: budgetCategory
                                        .categoriess[counter].isSelected
                                    ? Colors.white
                                    : Colors.blue,
                                label: Text(
                                  budgetCategory.categoriess[counter].label,
                                  style: TextStyle(
                                    color: budgetCategory
                                            .categoriess[counter].isSelected
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
          const Text("Select a Sub Category"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 12.0,
              children: List<GestureDetector>.generate(
                budgetCategory.subcategories[
                            budgetCategory.getSelectedCategory()] ==
                        null
                    ? 1
                    : budgetCategory
                            .subcategories[budgetCategory.getSelectedCategory()]
                            .length +
                        1,
                (counter) => GestureDetector(
                  onTap: () {
                    if (budgetCategory.isLastSubcategory(counter)) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            // ignore: prefer_const_constructors
                            return MyDialog(isFromSubCategory: true);
                          });
                    } else {
                      budgetCategory.updateSubCategories(counter);
                    }
                  },
                  child: budgetCategory.isLastSubcategory(counter)
                      ? const Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Icon(Icons.add),
                        )
                      : Chip(
                          deleteIcon: Icon(Icons.clear,
                              color: budgetCategory.selectedSubCategoryIndex ==
                                      counter
                                  ? Colors.black
                                  : Colors.white),
                          onDeleted: () {
                            budgetCategory.deleteSubCategory(counter);
                          },
                          backgroundColor:
                              budgetCategory.selectedSubCategoryIndex == counter
                                  ? Colors.white
                                  : Colors.blue,
                          label: Text(
                            budgetCategory.subcategories[budgetCategory
                                    .getSelectedCategory()][counter]
                                .toString(),
                            style: TextStyle(
                              color: budgetCategory.selectedSubCategoryIndex ==
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: formKey,
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) => budgetCategory.validateBudget(value),
                controller: budgetCategory.budgetController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                  labelText: "Budget",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {}
              },
              child: const Text("Submit"))
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MyDialog extends StatelessWidget {
  //create a text editing controller, pass it to right place and validate the text
  //late Controller con;
  late BudgetCategoryViewModel budgetCategory;

  var formKey = GlobalKey<FormState>();
  MyDialog({Key? key, this.isFromSubCategory = false}) : super(key: key);
  final bool isFromSubCategory;
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
            const Text('Add a Category'),
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
          budgetCategory.isCategoriesAdding
              ? const CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )
              : ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      // if(isFromSubCategory){
                      //   // budgetCategory.addSubCategory();
                      //   budgetCategory.addCategory();
                      //
                      // }
                      // else{
                      //   budgetCategory.addCategory();
                      // }
                      await budgetCategory.addCategory();
                      budgetCategory.getCategories();
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
