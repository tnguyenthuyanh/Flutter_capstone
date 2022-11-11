import 'package:cap_project/model/debt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/custom_icons_icons.dart';

class RedDebtCard extends StatelessWidget {
  final Debt debt;

  RedDebtCard({required this.debt});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            debt.category == 'Mortgage'
                ? const Icon(
                    Icons.house,
                    color: Color.fromARGB(255, 212, 7, 7),
                  )
                : debt.category == 'Car loan'
                    ? const Icon(
                        CustomIcons.cab,
                        color: Color.fromARGB(255, 212, 7, 7),
                      )
                    : debt.category == 'Credit Card'
                        ? const Icon(
                            CustomIcons.money_check,
                            color: Color.fromARGB(255, 212, 7, 7),
                          )
                        : const Icon(
                            Icons.medical_services,
                            color: Color.fromARGB(255, 212, 7, 7),
                          ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(debt.title,
                    style: Theme.of(context).textTheme.headline6!.merge(
                          const TextStyle(
                            color: Color.fromARGB(255, 212, 7, 7),
                          ),
                        )),
                Text(
                  debt.category,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 212, 7, 7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrangeDebtCard extends StatelessWidget {
  final Debt debt;

  OrangeDebtCard({required this.debt});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            debt.category == 'Mortgage'
                ? const Icon(
                    Icons.house,
                    color: Color.fromARGB(255, 255, 166, 0),
                  )
                : debt.category == 'Car loan'
                    ? const Icon(
                        CustomIcons.cab,
                        color: Color.fromARGB(255, 255, 166, 0),
                      )
                    : debt.category == 'Credit Card'
                        ? const Icon(
                            CustomIcons.money_check,
                            color: Color.fromARGB(255, 255, 166, 0),
                          )
                        : const Icon(
                            Icons.medical_services,
                            color: Color.fromARGB(255, 255, 166, 0),
                          ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(debt.title,
                    style: Theme.of(context).textTheme.headline6!.merge(
                          const TextStyle(
                              color: Color.fromARGB(255, 255, 166, 0)),
                        )),
                Text(
                  debt.category,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 166, 0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class YellowDebtCard extends StatelessWidget {
  final Debt debt;

  YellowDebtCard({required this.debt});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            debt.category == 'Mortgage'
                ? const Icon(
                    Icons.house,
                    color: Color.fromARGB(255, 251, 255, 0),
                  )
                : debt.category == 'Car loan'
                    ? const Icon(
                        CustomIcons.cab,
                        color: Color.fromARGB(255, 251, 255, 0),
                      )
                    : debt.category == 'Credit Card'
                        ? const Icon(
                            CustomIcons.money_check,
                            color: Color.fromARGB(255, 251, 255, 0),
                          )
                        : const Icon(
                            Icons.medical_services,
                            color: Color.fromARGB(255, 251, 255, 0),
                          ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(debt.title,
                    style: Theme.of(context).textTheme.headline6!.merge(
                          const TextStyle(
                            color: Color.fromARGB(255, 251, 255, 0),
                          ),
                        )),
                Text(
                  debt.category,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 251, 255, 0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LimeGreenDebtCard extends StatelessWidget {
  final Debt debt;

  LimeGreenDebtCard({required this.debt});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            debt.category == 'Mortgage'
                ? const Icon(
                    Icons.house,
                    color: Color.fromARGB(255, 123, 255, 0),
                  )
                : debt.category == 'Car loan'
                    ? const Icon(
                        CustomIcons.cab,
                        color: Color.fromARGB(255, 123, 255, 0),
                      )
                    : debt.category == 'Credit Card'
                        ? const Icon(
                            CustomIcons.money_check,
                            color: Color.fromARGB(255, 123, 255, 0),
                          )
                        : const Icon(
                            Icons.medical_services,
                            color: Color.fromARGB(255, 123, 255, 0),
                          ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(debt.title,
                    style: Theme.of(context).textTheme.headline6!.merge(
                          const TextStyle(
                            color: Color.fromARGB(255, 123, 255, 0),
                          ),
                        )),
                Text(
                  debt.category,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 123, 255, 0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GreenDebtCard extends StatelessWidget {
  final Debt debt;

  GreenDebtCard({required this.debt});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            debt.category == 'Mortgage'
                ? const Icon(
                    Icons.house,
                    color: Color.fromARGB(255, 6, 150, 6),
                  )
                : debt.category == 'Car loan'
                    ? const Icon(
                        CustomIcons.cab,
                        color: Color.fromARGB(255, 6, 150, 6),
                      )
                    : debt.category == 'Credit Card'
                        ? const Icon(
                            CustomIcons.money_check,
                            color: Color.fromARGB(255, 6, 150, 6),
                          )
                        : const Icon(
                            Icons.medical_services,
                            color: Color.fromARGB(255, 6, 150, 6),
                          ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(debt.title,
                    style: Theme.of(context).textTheme.headline6!.merge(
                          const TextStyle(
                            color: Color.fromARGB(255, 6, 150, 6),
                          ),
                        )),
                Text(
                  debt.category,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 6, 150, 6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
