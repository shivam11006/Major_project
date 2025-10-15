class SignUp {
  String Name;
  String UserName;
  String Email;
  String Number;
  String Password;

  SignUp(this.Name, this.UserName, this.Email, this.Number, this.Password);

  static toMap (SignUp signUp) {
    return {
      'Name': signUp.Name,
      'UserName': signUp.UserName,
      'Email': signUp.Email,
      'Number': signUp.Number,
      'Password': signUp.Password,


    };
  }
  factory SignUp.fromMap(Map<String, dynamic> map) {
    return SignUp(map['Name'], map['UserName'], map['Email'], map['Number'], map['Password']);
  }

}

class UserSignUp {
  String Name;
  String UserName;
  String Email;
  String Number;

  UserSignUp(this.Name, this.UserName, this.Email, this.Number);

  static toMap (UserSignUp userSignUp) {
    return {

      'Name': userSignUp.Name,
      'UserName': userSignUp.UserName,
      'Email': userSignUp.Email,
      'Number': userSignUp.Number,

  };
}
factory UserSignUp.fromMap(Map<String, dynamic> map) {
    return UserSignUp(map['Name'], map['UserName'], map['Email'], map['Number']);
  }
}