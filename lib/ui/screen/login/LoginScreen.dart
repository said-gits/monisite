import 'package:flutter/material.dart';
import 'package:flutter_monisite/core/provider/AuthProvider.dart';
import 'package:flutter_monisite/core/routes/router.gr.dart';
import 'package:flutter_monisite/ui/screen/login/SignupPage.dart';
import 'package:flutter_monisite/ui/shared/color.dart';
import 'package:flutter_monisite/ui/shared/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _obscureText = true;
  TextEditingController _email;
  TextEditingController _password;

  _validator(String value, String textWarning) {
    if (value.isEmpty) {
      return 'Harap mengisi $textWarning';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: colorBackground,
      body: Stack(
        children: <Widget>[
          _showForm(context),
        ],
      ),
    );
  }

  Container _showForm(BuildContext context) {
    final user = Provider.of<AuthProvider>(context);

    return Container(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                showLogo(),
                SizedBox(
                  height: 60,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Masuk',
                    style: TextStyle(
                        color: colorDefault,
                        fontFamily: 'PTSans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: showEmailInput()),
                      SizedBox(
                        height: 30.0,
                      ),
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: showPasswordInput()),
                      SizedBox(
                        height: 30.0,
                      ),
                      user.status == Status.Authenticating
                          ? Center(child: CircularProgressIndicator())
                          : showPrimaryButton(user),
                      SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        child: Text(
                          'Daftar?',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: colorDefault,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20)),
                        child: FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () {
                            Navigator.pushNamed(context, Router.signUpPage);
                          },
                          child: new Text('Klik Disini',
                              style: new TextStyle(
                                  fontSize: 16.0,
                                  color: colorDefault,
                                  fontFamily: 'PTSans')),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showLogo() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Text('Monisite',
            style: GoogleFonts.poppins(fontSize: 26, color: Colors.blueAccent)),
      ),
    );
  }

  TextFormField showPasswordInput() {
    return TextFormField(
      obscureText: _obscureText,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        border: InputBorder.none,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
        icon: Icon(
          Icons.lock,
          size: 35.0,
        ),
        hintText: 'Kata Sandi',
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: colorDefault),
      ),
      style: TextStyle(
        color: Colors.black,
      ),
      validator: (value) => _validator(value, 'password'),
      controller: _password,
    );
  }

  TextFormField showEmailInput() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.left,
      decoration: inputDecorationPlusIconStyle(
          "Alamat Email", Icon(Icons.account_circle)),
      style: TextStyle(
        color: Colors.black,
      ),
      validator: (value) => _validator(value, 'password'),
      controller: _email,
    );
  }

  Widget showPrimaryButton(AuthProvider user) {
    return Container(
      width: double.infinity,
      child: Material(
        elevation: 5.0,
        child: RaisedButton(
          color: Colors.blueAccent,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () async {
            final snackBar =
                new SnackBar(content: new Text("Email atau password salah !"));

            print("email : ${_email.text}, password: ${_password.text}");
            if (formKey.currentState.validate()) {
              if (await user.doLogin(_email.text, _password.text) != true) {
                scaffoldKey.currentState.showSnackBar(snackBar);
              } else {
                await user.saveToken(user.getUserId());
              }
            }

            // Navigator.pushNamed(context, Router.navBottomMain);
          },
          child: new Text('Masuk',
              style: new TextStyle(
                  fontSize: 20.0, color: Colors.white, fontFamily: 'PTSans')),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
