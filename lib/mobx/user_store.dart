import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/model/user.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  // constructor:---------------------------------------------------------------
  _UserStore() {
    Repository.get().getUser().then((value) {
      if (value.id != 0) {
        user = value;
      }
    });
    googleSignIn = GoogleSignIn(
      serverClientId:
          '1041713167388-u3vb1ni0998vlae632petp0o6afp34d3.apps.googleusercontent.com',
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    googleSignIn?.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      currentUser = account;
      if (currentUser != null) {
        userName = currentUser?.displayName;
        print("userName is $userName");
      }
    });
    googleSignIn?.signInSilently();
  }

  @observable
  GoogleSignIn? googleSignIn;

  @observable
  GoogleSignInAccount? currentUser;

  @observable
  User? user;

  @observable
  String? userName = '';

  @action
  Future<int?> handleSignIn() async {
    try {
      return await googleSignIn?.signIn().then((value) async {
        currentUser = value;
        print("handleSignIn ${value.toString()}");
        await Repository.get().updateUser(User(
            id: double.parse(value!.id),
            displayName: value.displayName,
            email: value.email,
            photoUrl: value.photoUrl,
            serverAuthCode: value.serverAuthCode));
       return value?.id != null ? 0 : 1;
      });
    } catch (error) {
      print(error);
    }
    return null;
  }

  @action
  Future<void> handleSignOut() async =>
      googleSignIn != null ? await googleSignIn!.disconnect() : Future.value();
}
