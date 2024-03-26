import 'package:flutter/material.dart';
import 'register_view.dart';
import 'package:heathtrack/services/authService.dart';

class LoginView extends StatelessWidget {
  static const String routeName = '/login';

  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Login';
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: LoginForm(),
      floatingActionButton: const FooterView(),
      // endDrawer: FooterView(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  AuthService authService = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController familyCodeController = TextEditingController();
  bool _passwordVisible = true;

  void loginUser() {
    authService.loginUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
      familyCode: familyCodeController.text,
    );
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text('Username'),
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.account_circle),
                hintText: 'Type your username',
                border: UnderlineInputBorder(),
                // labelText: "Username"
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10),
              child: Text('Password'),
            ),
            TextFormField(
              controller: passwordController,
              obscureText: _passwordVisible,
              // keyboardType: TextInputType.,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    icon: Icon(_passwordVisible
                        ? Icons.visibility_off
                        : Icons.visibility)),
                hintText: 'Type your password',
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10),
              child: Text('Family Code'),
            ),
            TextFormField(
              controller: familyCodeController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.home),
                hintText: 'Type your family code',
                border: UnderlineInputBorder(),
                // labelText: "Username"
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {}, child: const Text('Forgot password ?'))
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.lightBlueAccent, Colors.blue],
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                    onPressed: () {
                      loginUser();
                    },
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 2),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16),
              child: Row(
                children: [
                  Expanded(
                      child: Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Or sign up using',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  Expanded(
                      child: Divider(
                    thickness: 1,
                    color: Colors.grey[400],
                  )),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {},
                  child: Image.asset('images/googleBtn.png', height: 32),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {},
                  child: Image.asset('images/facebookBtn.png', height: 32),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class FooterView extends StatelessWidget {
  const FooterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Not a member ?',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Colors.greenAccent, Colors.cyan],
                    stops: [0.1, 0.5]),
                borderRadius: BorderRadius.circular(20)),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterView()));
              },
              child: const Text(
                'Register',
                style: TextStyle(
                    color: Colors.white, fontSize: 16, letterSpacing: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
