import 'package:flutter/material.dart';
import 'package:mitsubishi_motors_parts_e_commerce/presentation/provider/user_provider.dart';
import 'package:mitsubishi_motors_parts_e_commerce/presentation/ui/product_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Theme(
            data: Theme.of(context).copyWith(
              brightness: Brightness.light, // Set light theme
            ),
            child: _buildLoginForm(context),
          );
        },
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo-mitsubishi-motors.jpg',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to MMPE Product Management Platform',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please log in as an admin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  Provider.of<UserProvider>(context, listen: false)
                      .login(_usernameController.text, _passwordController.text)
                      .then((value) {
                    if (Provider.of<UserProvider>(context, listen: false)
                        .isLogin) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductPage()));
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
