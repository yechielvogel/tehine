import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authenticate/auth.dart';
import '../../shared/loading.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn(
    this.toggleView, {
    Key? key,
  }) : super(key: key);
  final Function toggleView;
  @override
  ConsumerState createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
 AuthService get _auth => ref.read(authProvider);
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xFFF5F5F5),
            appBar: AppBar(
              backgroundColor: Color(0xFFF5F5F5),
              elevation: 0.0,
              title: Center(
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.grey[850]),
                ),
              ),
              centerTitle: true,
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          cursorColor: Colors.grey[850],
                          decoration: InputDecoration(
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey[850] ?? Colors.grey)),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.grey[850]),
                            fillColor: Color(0xFFF5F5F5),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey[850] ?? Colors.grey,
                                    width: 3.0)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey[850] ?? Colors.grey,
                                    width: 3.0)),
                            errorStyle: TextStyle(
                              color: Colors.grey[850],
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Colors.grey[850] ?? Colors.grey,
                                  width: 3.0),
                            ),
                          ),
                          style: TextStyle(color: Colors.grey[850]),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter Email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          cursorColor: Colors.grey[850],
                          decoration: InputDecoration(
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey[850] ?? Colors.grey)),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey[850]),
                            fillColor: Color(0xFFF5F5F5),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey[850] ?? Colors.grey,
                                    width: 3.0)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey[850] ?? Colors.grey,
                                    width: 3.0)),
                            errorStyle: TextStyle(
                              color: Colors.grey[850],
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Colors.grey[850] ?? Colors.grey,
                                  width: 3.0),
                            ),
                          ),
                          style: TextStyle(color: Colors.grey[850]),
                          validator: (val) => val!.length < 6
                              ? 'Enter a password 6 + chars long'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            {
                              setState(() => password = val);
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Color(0xFFE6D3B3)),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password);
                                  // if (result != null) print(result);
                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'please enter a valid email and password';
                                      loading = false;
                                    });
                                  }
                                  // else {
                                  //   Navigator.pushReplacement(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) => Home()));
                                  // }
                                } else {
                                  print('couldnt sign in');
                                  print('this email ${email}');
                                  print(password);
                                }
                              },
                              child: Text(
                                'Sign in',
                                style: TextStyle(color: Colors.grey[850]),
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Color(0xFFE6D3B3)),
                              onPressed: () async {
                                widget.toggleView();
                                print('register');
                                print(email);
                                print(password);
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(color: Colors.grey[850]),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          error,
                          style:
                              TextStyle(color: Colors.grey[850], fontSize: 14),
                        )
                      ],
                    ))),
          );
  }
}
