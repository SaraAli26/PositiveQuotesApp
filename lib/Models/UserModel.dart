class UserModel {
  String firstName;
  String lastName;

  UserModel({
    required this.firstName,
    required this.lastName
  });

  Map<String, dynamic> toJson() => {
    'author': firstName,
    'quote': lastName,
  };

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
        firstName : json['firstname'],
        lastName :json['lastname']
    );
  }
}
