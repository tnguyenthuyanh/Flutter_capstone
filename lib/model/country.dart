class Country {
  String? name;
  String? urlFlag;
  String? currency;

  Country({this.name, this.urlFlag, this.currency});
}

final List<Country> data = [
  Country(
      name: 'USA',
      urlFlag:
          'https://images.creativemarket.com/0.1.0/ps/1652957/6792/3656/m1/fpnw/wm1/american-flag-.jpg?1473760532&s=8ff7bab90a57b218e76e2b234a287857',
      currency: 'USD'),
  Country(
      name: 'EU',
      urlFlag:
          'https://www.gtreview.com/wp-content/uploads/2015/01/European-Union-Flag-Waving.jpg',
      currency: 'EU'),
  Country(
      name: 'JAP',
      urlFlag: 'https://wallpapercave.com/wp/wp3996166.jpg',
      currency: 'JPY'),
];
