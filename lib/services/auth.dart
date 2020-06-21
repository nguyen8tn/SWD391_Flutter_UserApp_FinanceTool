import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:swd/models/user.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();
  final storage = new FlutterSecureStorage();
  Future<User> signInWithGoogle() async {
    signOutGoogle();
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser firebaseUser = authResult.user;

    //debugPrint("ccc" + credential.toString());

    assert(!firebaseUser.isAnonymous);
    assert(await firebaseUser.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(firebaseUser.uid == currentUser.uid);
    IdTokenResult idTokenResult;
    Duration duration = new Duration(hours: 1);
    idTokenResult = await firebaseUser.getIdToken(refresh: false).then((value) => value).timeout(duration);
    User user = new User(idTokenResult.token, firebaseUser.uid, firebaseUser.displayName, firebaseUser.email);
    storage.write(key: "token", value: idTokenResult.token);
    return user;
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
    print("User Sign Out");
  }

  Future<User> signInWithFacebook() async {
    signOutFb();
    FacebookLoginResult loginResult = await facebookLogin.logIn(['email']);
    User user;
    switch (loginResult.status) {
      case FacebookLoginStatus.loggedIn:
        FacebookAccessToken accessToken = loginResult.accessToken;
        final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: accessToken.token );
        FirebaseUser firebaseUser;
        AuthResult ar = await _auth.signInWithCredential(credential);
        firebaseUser = ar.user;
        IdTokenResult idTokenResult;
        Duration duration = new Duration(hours: 1);
        idTokenResult = await firebaseUser.getIdToken(refresh: false).then((value) => value).timeout(duration);
        print('User:  ' + firebaseUser.uid + firebaseUser.displayName + firebaseUser.email);
        user = new User(idTokenResult.token, firebaseUser.uid, firebaseUser.displayName, firebaseUser.email);
        return user;
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }
    return user;
  }

  void signOutFb() async {
    await facebookLogin.logOut();
    _auth.signOut();
    print('logged out');
  }
}
