import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authenticate/auth.dart';
import '../../shared/loading.dart';

class Register extends ConsumerStatefulWidget {
  const Register(
    this.toggleView, {
    Key? key,
  }) : super(key: key);
  final Function toggleView;
  @override
  ConsumerState createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  AuthService get _auth => ref.read(authProvider);
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  String displayName = '';
  String phoneNumber = '';
  String error = '';
  bool loading = false;

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
                  'Register',
                  style: TextStyle(color: Colors.grey[850]),
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
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
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3)),
                              hintText: 'First Name',
                              hintStyle: TextStyle(color: Colors.grey[850]),
                              fillColor: Colors.grey[350] ?? Colors.grey,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3.0)),
                              errorStyle: TextStyle(
                                color: Colors.grey[850],
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey[350] ?? Colors.grey,
                                    width: 3.0),
                              ),
                            ),
                            style: TextStyle(color: Colors.grey[850]),
                            textCapitalization: TextCapitalization.words,
                            validator: (val) =>
                                val!.isEmpty ? 'Enter First Name' : null,
                            onChanged: (val) {
                            

                              {
                                setState(() => firstName = val);
                                setState(() {
                                });
                              }
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
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3)),
                              hintText: 'Last Name',
                              hintStyle: TextStyle(color: Colors.grey[850]),
                              fillColor: Colors.grey[350] ?? Colors.grey,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3.0)),
                              errorStyle: TextStyle(
                                color: Colors.grey[850],
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey[350] ?? Colors.grey,
                                    width: 3.0),
                              ),
                            ),
                            style: TextStyle(color: Colors.grey[850]),
                            textCapitalization: TextCapitalization.words,
                            validator: (val) =>
                                val!.isEmpty ? 'Enter Last Name' : null,
                            onChanged: (val) {
                             
                              {
                                setState(() => lastName = val);
                                setState(() {
                                });
                              }
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
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3)),
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.grey[850]),
                              fillColor: Colors.grey[350] ?? Colors.grey,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3.0)),
                              errorStyle: TextStyle(
                                color: Colors.grey[850],
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey[350] ?? Colors.grey,
                                    width: 3.0),
                              ),
                            ),
                            style: TextStyle(color: Colors.grey[850]),
                            validator: (val) =>
                                !val!.contains('@') && !val!.contains('.')
                                    ? 'Enter a valid Email'
                                    : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            cursorColor: Colors.grey[850],
                               decoration: InputDecoration(
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3)),
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(color: Colors.grey[850]),
                              fillColor: Colors.grey[350] ?? Colors.grey,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3.0)),
                              errorStyle: TextStyle(
                                color: Colors.grey[850],
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey[350] ?? Colors.grey,
                                    width: 3.0),
                              ),
                            ),
                            style: TextStyle(color: Colors.grey[850]),
                            validator: (val) => val!.length < 10
                                ? 'Enter a valid Phone Number'
                                : null,
                            onChanged: (val) {
                              {
                                setState(() => phoneNumber = val);
                                setState(() {
                                });
                              }
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
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3)),
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.grey[850]),
                              fillColor: Colors.grey[350] ?? Colors.grey,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Colors.grey[350] ?? Colors.grey,
                                      width: 3.0)),
                              errorStyle: TextStyle(
                                color: Colors.grey[850],
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey[350] ?? Colors.grey,
                                    width: 3.0),
                              ),
                            ),
                            style: TextStyle(color: Colors.grey[850]),
                            obscureText: true,
                            validator: (val) => val!.length < 6
                                ? 'Enter a password 6 + chars long'
                                : null,
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
                                      borderRadius: BorderRadius.circular(
                                          20), 
                                    ),
                                    backgroundColor: Color(0xFFE6D3B3)),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => loading = true);
                                    print(email);
                                    print(password);
                                    if (Platform.isAndroid) {
                                      displayName =
                                          '${firstName.capitalizeFirstLetter()} ${lastName.capitalizeFirstLetter()}';
                                    } else {
                                      displayName = firstName + ' ' + lastName;
                                    }

                                    dynamic result = await _auth
                                        .registerWithEmailAndPassword(
                                      email,
                                      password,
                                      displayName,
                                      phoneNumber,
                                      firstName.capitalizeFirstLetter(),
                                      lastName.capitalizeFirstLetter(),
                                    );
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    if (result == null) {
                                      setState(() {
                                        error =
                                            'please enter a valid email and password';
                                        loading = false;
                                      });
                                    } else {
                                      print('registered');
                                      // await userInfoAt(
                                      //     ref.read(userStreamProvider).value?.uid,
                                      //     ref
                                      //         .read(userStreamProvider)
                                      //         .value
                                      //         ?.username);
                                    }
                                  } else
                                    print("couldn't register");
                                  // widget.toggleView();
                                },
                                child: Text(
                                  'Register',
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
                                  print(email);
                                  print(password);
                                },
                                child: Text(
                                  'Sign in',
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
                            style: TextStyle(
                                color: Colors.grey[850], fontSize: 14),
                          )
                        ],
                      ))),
            ),
          );
  }
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    return this.isNotEmpty ? this[0].toUpperCase() + this.substring(1) : '';
  }
}
