class JournalModel {
  String journal;
  String date;

  JournalModel({
    required this.journal,
    required this.date

  });

  Map<String, dynamic> toJson() => {
    'journal': journal,
    'date': date,
  };

  factory JournalModel.fromJson(Map<String, dynamic> json){
    return JournalModel(
        journal : json['journal'],
        date :json['date']
    );
  }
}