import 'package:flutter/foundation.dart';
import 'package:notabox/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? currentUser;

  void updateUser(UserModel? user) {
    currentUser = user;
    notifyListeners();
  }
}
