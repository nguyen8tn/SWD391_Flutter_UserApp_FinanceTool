import 'package:flutter/material.dart';
import 'package:swd/main.dart';
import 'package:swd/services/auth.dart';
import 'package:swd/services/httprequest.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              _signInButton(),
              _loginFBButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
          AuthService().signInWithGoogle().then((value) {
            if (value != null) {
              print('----------value: ' + value.uid);
              HttpRequest().login(value).then((value) {
                print('----------value2: ' + value);
                if(value.isNotEmpty) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return MainPage(appTitle: 'Messaging');
                  }));
                } else {
                  Toast.show("Error at Http", context,duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }));
                }
              });
            } else {
              Toast.show("Error at Login", context,duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return LoginPage();
              }));
            }
          });
        },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _loginFBButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        AuthService().signInWithFacebook().then((value) {
          if (value != null) {
            print('----------value: ' + value.uid);
            HttpRequest().login(value).then((value) {
              print('----------value2: ' + value);
              if(value.isNotEmpty) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return MainPage(appTitle: 'Messaging');
                }));
              } else {
                Toast.show("Error at Http", context,duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              }
            });
          } else {
            Toast.show("Error at Login", context,duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return LoginPage();
            }));
          }
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Facebook',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
