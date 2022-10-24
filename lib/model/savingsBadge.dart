import 'package:firebase_auth/firebase_auth.dart';

class SavingsBadge {
  double amount;
  String badgeUrl;
  String name;

  SavingsBadge({
    this.amount = 0,
    this.badgeUrl = 'n/a',
    this.name = 'n.a',
  });
}

var badgeList = [
  SavingsBadge(
    amount: 1,
    badgeUrl:
        'https://www.imprintlogo.com/images/products/saving-money-is-smart-sticker-rolls_11979.jpg',
  ),
  SavingsBadge(
    amount: 50,
    badgeUrl: 'https://www.pikpng.com/pngl/b/99-992927_money-emoji-png.png',
  ),
  SavingsBadge(
    amount: 150,
    badgeUrl:
        'https://img.stickers.cloud/packs/69d2652f-b739-4e72-b194-fbcfafd182b9/png/b1947535-b91e-4a3c-baf5-68d1364836fa.png',
  ),
  SavingsBadge(
    amount: 350,
    badgeUrl:
        'https://i.pinimg.com/originals/5a/5f/2f/5a5f2ff558d8245a0399ae9bec0d892e.png',
  ),
  SavingsBadge(
    amount: 550,
    badgeUrl:
        'https://i.pinimg.com/originals/f2/0c/a9/f20ca959b7a4af49faa19fbcb353e102.png',
  ),
  SavingsBadge(
      amount: 1550,
      badgeUrl: 'https://cdn130.picsart.com/235850924022212.png?r1024x1024'),
];
