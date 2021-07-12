import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qoutesapp/Models/QuoteModel.dart';

class QuotesService {
  FirebaseFirestore? _instance;

  List<QuoteModel> _Quotes = [];

  List<QuoteModel> getQuotes(){
    return _Quotes;
  }

  Future<void> getQuotesCollectionFromFireStore() async {
    //This will create direct connection to firebase instance in the cloud
    _instance = FirebaseFirestore.instance;
    CollectionReference quotes = _instance!.collection("positivequotes");

    DocumentSnapshot snapshot = await quotes.doc('quotes').get();
    if(snapshot.exists){
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      var quotesData =  data['quotes'] as List<dynamic>;

      print(quotesData);
      quotesData.forEach((quotesd) {
        QuoteModel cat = QuoteModel.fromJson(quotesd);
        _Quotes.add(cat);
      });
    }

  }

  Future<List<QuoteModel>?> getMyQuotes() async {
    List<QuoteModel> _Quotess = [];

    _instance = FirebaseFirestore.instance;
    CollectionReference quotes = _instance!.collection("positivequotes");

    DocumentSnapshot snapshot = await quotes.doc('quotes').get();
    if(snapshot.exists){
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      var quotesData =  data['quotes'] as List<dynamic>;

    /*  var r =  quotesData.where((snapshot) => snapshot == "7/7/2021").first as Map<String, dynamic>;
      QuoteModel ff = QuoteModel.fromJson(r) ;
      print("I am rrrrrrrrrrrrrrrrrr" + ff.quote.toString());*/
      print(quotesData);
      quotesData.forEach((quotesd) {
        QuoteModel cat = QuoteModel.fromJson(quotesd as Map<String, dynamic>);
        _Quotess.add(cat);
      });
    }
    return _Quotess;
  }

   Future<QuoteModel> getQuoteOfToday() async {

    QuoteModel QuoteOfToday = new QuoteModel(author: "", quote: "", time: "", category: "", date: "");

    _instance = FirebaseFirestore.instance;
    CollectionReference quotes = _instance!.collection("positivequotes");

    DocumentSnapshot snapshot = await quotes.doc('DailyQuote').get();
    if(snapshot.exists){
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      var quotesData =  data['DailyQuotes'] as Map<String, dynamic>;
      print(quotesData);
      QuoteOfToday = QuoteModel.fromJson(quotesData);
      print(QuoteOfToday.quote);

    }
    return QuoteOfToday;
  }
}