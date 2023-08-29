import 'dart:isolate';

// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ely_ai_messenger/DatabaseManager/databaseQuery.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginAndRegisterPage extends StatefulWidget {
  const LoginAndRegisterPage({super.key});

  @override
  State<LoginAndRegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginAndRegisterPage> {
  String? errorMessage = "";
  bool isLogin = true, _isNotEmpty = false, _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final String defaultAvatar =
      'https://th.bing.com/th/id/R.945f33b643f2ceffcdae90fb57c61854?rik=ZbauAhRVa2agEw&riu=http%3a%2f%2fgetdrawings.com%2ffree-icon-bw%2fgeneric-avatar-icon-3.png&ehk=MEKRKETvvufVVLoShHum%2baEfkHOctyKClaf6qCu3Msg%3d&risl=&pid=ImgRaw&r=0';
  final currentUserId = DatabaseQuery().currentUser?.uid;

  void checkIfInputted() {
    if (!isLogin) {
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty) {
        if (_passwordController.text != _confirmPasswordController.text) {
          setState(() {
            _isNotEmpty = false;
            errorMessage = 'Passwords do not match';
          });
        } else {
          setState(() {
            _isNotEmpty = true;
            errorMessage = '';
          });
        }
      } else {
        setState(() {
          errorMessage = '';
        });
      }
    } else {
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        setState(() {
          _isNotEmpty = true;
        });
      } else {
        setState(() {
          _isNotEmpty = false;
        });
      }
    }
  }

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await DatabaseQuery().loginUser(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        errorMessage = e.message;
      });
    }
  }

  Future<void> registerUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check if user EMAIL already exists

      if (await DatabaseQuery().checkIfEmailExists(_emailController.text)) {
        setState(() {
          errorMessage = "Email Already Exists";
          _isLoading = false;
        });
      } else {
        // Create user
        await DatabaseQuery()
            .registerUser(
              email: _emailController.text,
              password: _passwordController.text,
            )
            .then((value) => addUserDetails(
                  _emailController.text.trim(),
                  _firstNameController.text.trim(),
                  _lastNameController.text.trim(),
                  defaultAvatar,
                  true,
                ));

        // Add user details
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        errorMessage = e.message;
      });
    }
  }

  Future addUserDetails(
    String email,
    String firstName,
    String lastName,
    String avatar,
    bool online,
  ) async {
    await DatabaseQuery().usersModel.add({
      'email': email,
      'name': firstName,
      'last_name': lastName,
      'avatar': avatar,
      'online': online,
    });
  }

  Widget _entryField(
    String label,
    TextEditingController controller,
    bool isPassword,
    bool isLogin,
  ) {
    if (isLogin && label == 'Confirm Password' ||
        isLogin && label == 'First name' ||
        isLogin && label == 'Last name') {
      return Container();
    }
    return TextField(
      controller: controller,
      onChanged: (value) async => {checkIfInputted()},
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: InputBorder.none,
      ),
      style: const TextStyle(
        fontSize: 18,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : '$errorMessage',
      style: const TextStyle(color: Colors.redAccent, fontSize: 16),
    );
  }

  Widget _submitButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: _isNotEmpty ? Colors.blue[700] : Colors.grey),
        onPressed: _isLoading ? null : (isLogin ? loginUser : registerUser),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Text(
                  (isLogin ? 'LOG IN' : 'REGISTER'),
                  style: const TextStyle(fontSize: 17),
                ),
        ),
      ),
    );
  }

  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {},
      child: Text(
        isLogin ? 'FORGOT PASSWORD' : '',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _registerOrLoginInstead() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
        isLogin ? 'REGISTER INSTEAD' : 'LOGIN INSTEAD',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _horizontalLine(bool isHidden) {
    return Container(
      width: double.infinity,
      height: isLogin && isHidden ? 0 : 1,
      color: Colors.grey[400],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: CachedNetworkImage(
                    key: UniqueKey(),
                    imageUrl:
                        'https://logodownload.org/wp-content/uploads/2017/04/facebook-messenger-logo-0-1.png',
                    height: 150,
                    width: 150,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              _entryField('First name', _firstNameController, false, isLogin),
              _horizontalLine(true),
              _entryField('Last name', _lastNameController, false, isLogin),
              _horizontalLine(true),
              _entryField('Email', _emailController, false, isLogin),
              _horizontalLine(false),
              _entryField('Password', _passwordController, true, isLogin),
              _horizontalLine(true),
              _entryField('Confirm Password', _confirmPasswordController, true,
                  isLogin),
              _errorMessage(),
              const SizedBox(height: 16.0),
              _submitButton(),
              _forgotPassword(),
              _registerOrLoginInstead(),
              const SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }
}
