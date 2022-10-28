/*
Template credit: https://www.fluttertemplates.dev/widgets/must_haves/content_feed
 */
import 'package:flutter/material.dart';

import '../model/terms.dart';

class MoreInfoScreen extends StatefulWidget {
  static const routeName = '/MoreInfoScreen';

  const MoreInfoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MoreInfoState();
  }
}

class _MoreInfoState extends State<MoreInfoScreen> {
  @override
  void initState() {
    //use this as constructor for state
    super.initState();
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView.builder(
            itemCount: termList.length,
            itemBuilder: (BuildContext context, int index) {
              final _item = termList[index];
              return Container(
                height: 136,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(8.0)),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _item.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(_item.def,
                            style: Theme.of(context).textTheme.caption),
                        const SizedBox(height: 8),
                      ],
                    )),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(_item.img),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Terms {
  String? docId;
  late String title;
  late String def;
  late String img;

  Terms({
    this.docId,
    this.title = '',
    this.def = '',
    this.img = '',
  });
}

final List<Terms> termList = [
  Terms(
      title: 'FICO',
      def:
          'FICO Score is a three digit number used to measure your ability to pay back loans or debts',
      img: 'https://bankruptcylawnetwork.com/wp-content/uploads/FICO.jpg'),
  Terms(
      title: 'Income',
      def:
          'Income is the amount of money you or an entity earns for services rendered.',
      img:
          'https://guinncenter.org/wp-content/uploads/2016/06/income-blog-1.jpeg'),
  Terms(
      title: 'Budget',
      def:
          'A budget is considered a financial plan tha determines how much money will be spent within a specific time frame',
      img:
          'https://gibsons.ca/wp-content/uploads/2020/05/budget-spelled-out-1024x683.jpg'),
  Terms(
      title: 'Loan',
      def:
          'A loan is a sum of money that one entity lets another entity borrow',
      img:
          'https://www.investopedia.com/thmb/5oPGxn23VPptX9PRbnff8Fp5spQ=/5894x3901/filters:fill(auto,1)/loan-text-written-on-wooden-block-with-stacked-coins-955530262-08c17c0eb3634e6daf780bdd9ac1d194.jpg'),
  Terms(
      title: 'Balance sheet',
      def:
          'A balance sheet is a financial document created by a business to capture the current dollar value of assets, liabilities and equity',
      img:
          'https://cameonetwork.org/wp-content/uploads/2015/10/Balance-Sheet-00a01.png'),
  Terms(
      title: 'Capital Gains',
      def:
          'Capital gains are the increase in value of an asset or investment above its initial purchase price',
      img: 'https://rpg.co.uk/wp-content/uploads/2020/10/1.jpg'),
];
