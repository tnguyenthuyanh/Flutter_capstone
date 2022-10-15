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
    amount: 10,
    badgeUrl: 'https://www.pikpng.com/pngl/b/99-992927_money-emoji-png.png',
  ),
  SavingsBadge(
    amount: 100,
    badgeUrl:
        'https://ih1.redbubble.net/image.211684808.9255/bg,f8f8f8-flat,750x,075,f-pad,750x1000,f8f8f8.u4.jpg',
  ),
  SavingsBadge(
    amount: 250,
    badgeUrl:
        'https://img.stickers.cloud/packs/69d2652f-b739-4e72-b194-fbcfafd182b9/png/b1947535-b91e-4a3c-baf5-68d1364836fa.png',
  ),
  SavingsBadge(
    amount: 500,
    badgeUrl:
        'https://i.pinimg.com/originals/5a/5f/2f/5a5f2ff558d8245a0399ae9bec0d892e.png',
  ),
  SavingsBadge(
    amount: 1000,
    badgeUrl:
        'https://ih1.redbubble.net/image.795164663.6967/st,small,507x507-pad,600x600,f8f8f8.u3.jpg',
  ),
  SavingsBadge(
    amount: 2500,
    badgeUrl:
        'https://ih1.redbubble.net/image.458252520.5071/st,small,507x507-pad,600x600,f8f8f8.u1.jpg',
  ),
  SavingsBadge(
    amount: 5000,
    badgeUrl:
        'https://i.pinimg.com/originals/f2/0c/a9/f20ca959b7a4af49faa19fbcb353e102.png',
  ),
  SavingsBadge(
      amount: 10000,
      badgeUrl: 'https://cdn130.picsart.com/235850924022212.png?r1024x1024'),
];
