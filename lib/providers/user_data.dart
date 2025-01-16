import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trabalho1/models/user.dart';

class UserDataNotifier extends StateNotifier<UserModel?> {
  UserDataNotifier() : super(null);

  void addUserData(UserModel userData) {
    state = userData;
  }

  void removeUserData() {
    state = null;
  }
}

final userDataProvider =
    StateNotifierProvider<UserDataNotifier, UserModel?>((ref) {
  return UserDataNotifier();
});
