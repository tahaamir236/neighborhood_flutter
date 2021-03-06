import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neighborhood/app/sign_in/sign_up_page.dart';
import 'package:neighborhood/common_widgets/platform_exception_alert_dialog.dart';
import 'package:neighborhood/app/sign_in/validators.dart';
import 'package:neighborhood/app/sign_in/sign_in_button.dart';
import 'package:neighborhood/services/auth.dart';
import 'package:provider/provider.dart';

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _isLoading = false;

  void _submit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithEmailAndPassword(_email, _password);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Can\'t Sign In',
        exception: e,
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toSignUp(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => SignUpPage.create(context)
      ),
    );
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  List<Widget> _buildChildren() {

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) && !_isLoading;

    return [
      _buildEmailTextField(),
      _buildPasswordTextField(),

      SizedBox(height: 32.0),

      SignInButton(
        text: 'Sign in',
        textColor: Colors.white,
        color: Theme.of(context).accentColor,
        onPressed: submitEnabled?() => _submit(): null,
      ),
//          style: TextStyle(color: Colors.black87, fontSize: 14.0) ,

      FlatButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: RichText(
          text: new TextSpan(
            // Note: Styles for TextSpans must be explicitly defined.
            // Child text spans will inherit styles from parent
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
            children: <TextSpan>[
              new TextSpan(
                text: 'Need an account? ',
                style: TextStyle(color: Colors.black87)
              ),
              new TextSpan(text: 'Sign up',
                  style: new TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w600)),
            ],
          ),
        ),

        onPressed: () => _toSignUp(),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      cursorColor: Colors.black87,
      style: TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
        ),
        enabled: _isLoading == false,
        hintText: 'Password',
        hintStyle: TextStyle(
          color: Colors.black54,
          fontSize: 18.0,
        ),
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (password) => _updateState() ,
    );
  }

  TextField _buildEmailTextField() {
//    bool emailValid = widget.emailValidator.isValid(_email);
    return TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        cursorColor: Colors.black87,
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54),
          ),
          errorStyle: TextStyle(
            color: Colors.black54,
          ),
          enabled: _isLoading == false,
          hintText: 'Email',
          hintStyle: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: _emailEditingComplete,
        onChanged: (email) => _updateState()
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildChildren(),
    );
  }

  _updateState() {
    setState(() {
    });
  }
}