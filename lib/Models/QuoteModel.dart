class QuoteModel {
  String author;
  String quote;
  String time;
  String category;
  String date;

  QuoteModel({
      required this.author,
      required this.quote,
      required this.time,
      required this.category,
      required this.date
  });

  Map<String, dynamic> toJson() => {
    'author': author,
    'quote': quote,
    'time': time,
    'category': category,
    'date': date,
  };

  factory QuoteModel.fromJson(Map<String, dynamic> json){
    return QuoteModel(
        author : json['author'],
        quote :json['quote'],
        time : json['time'],
        category : json['category'],
        date : json['date']
    );
  }

  static List<QuoteModel> formJsonArray(List<dynamic> jsonArray){
    List<QuoteModel> quoteModelFromJson = [];

    jsonArray.forEach((jsonData) {
      quoteModelFromJson.add(QuoteModel.fromJson(jsonData));
    });

    return quoteModelFromJson;
  }
}
