class Category {
  String? thumbnail;
  String? name;

  Category({
    this.name,
    this.thumbnail,
  });

  void add(Category c) {}
}

List categoryList = [
  Category(
    name: 'โคทั้งหมดในฟาร์ม',
    thumbnail: 'images/cow-01.png',
  ),
  Category(
    name: 'ข้อมูลการพัฒนาการโค',
    thumbnail: 'images/cow-01.png',
  ),
  Category(
    name: 'ข้อมูลการให้อาหารโค',
    thumbnail: 'images/cow-01.png',
  ),
  Category(
    name: 'ข้อมูลวัคซีนโค',
    thumbnail: 'images/cow-01.png',
  ),
  Category(
    name: 'ข้อมูลการผสมพันธุ์โค',
    thumbnail: 'images/cow-01.png',
  ),
];
