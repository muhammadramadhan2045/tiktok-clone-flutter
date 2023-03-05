import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/model/user.dart';

class SearchController extends GetxController {
  final Rx<List<User>> _searchUsers = Rx<List<User>>([]);
  List<User> get searchUsers => _searchUsers.value;

  searchUser(String typedUser) async {
    _searchUsers.bindStream(
      firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: typedUser)
          .snapshots()
          .map(
        (event) {
          List<User> retVal = [];
          for (var e in event.docs) {
            retVal.add(User.fromSnap(e));
          }
          return retVal;
        },
      ),
    );
  }
}
