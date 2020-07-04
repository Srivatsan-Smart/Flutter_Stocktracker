import 'package:flutter/material.dart';
import 'package:stocktrackerapp/services/auth.dart';
class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String email = '';
  String password = '';
  String error = '';
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign in to stock tracker app'),
        actions: <Widget>[
          FlatButton.icon(onPressed: (){
            widget.toggleView();
          }, icon: Icon(Icons.person), label: Text('Register'))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
        child: Form(
          key : _formKey,
          child: Column(
            children:<Widget> [
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val){
                  if(val.length>0){
                    return null;
                  }
                  else{
                    return 'Enter a valid email';
                  }
                },
                onChanged: (val){
                  setState(() => email = val);
                },
              ),
              SizedBox(height:20.0),
              TextFormField(
                obscureText: true,
                validator: (val){
                  if(val.length>7){
                    return null;
                  }
                  else{
                    return 'password must be 8 characters long';
                  }
                },
                onChanged: (val){
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.pink[400],
                child: Text('Sign In',
                style: TextStyle(color: Colors.white),),
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                    dynamic result = await _auth.signInWithEmailandPassword(email, password);

                    if(result == null){
                      setState(() {
                        error = 'Could not sign in with those credentials';
                      });
                    }

                  }
                },
              ),
              SizedBox(height: 20.0),
              Text(
                error,
                style: TextStyle(color: Colors.red,fontSize: 14.0),

              )
            ],
          ),
        )
      ),
    );
  }
}
