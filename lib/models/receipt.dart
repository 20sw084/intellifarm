class Receipt {
  String imageURL;
  String date;
  String? done;

  Receipt({
    required this.imageURL,
    required this.date,
    this.done,
  });

  Map<String, dynamic> getReceiptDataMap() {
    return {
      "imageURL": imageURL,
      "date": date,
      "done": done ?? " ",
    };
  }
}
