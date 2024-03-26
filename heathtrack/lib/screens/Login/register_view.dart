import 'package:flutter/material.dart';
import 'package:heathtrack/services/authService.dart';

class RegisterView extends StatelessWidget {
  static const String routeName = '/register';
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
        leading: BackButton(onPressed: () {
          Navigator.of(context).pop();
        }),
      ),
      body: const RegisterForm(),
      resizeToAvoidBottomInset: false,
      floatingActionButton: const FooterView(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  AuthService authService = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController familyCodeController = TextEditingController();

  bool _passwordVisible = false;
  bool _repeatPasswordVisible = false;

  void registerUser() {
    authService.registerUser(
        context: context,
        email: emailController.text,
        password: passwordController.text,
        name: userNameController.text,
        familyCode: familyCodeController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      // height: MediaQuery.of(context).size.height*0.9,
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
              controller: userNameController,
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
                        ? Icons.visibility
                        : Icons.visibility_off)),
                hintText: 'Type your password',
                // border: OutlineInputBorder(),
                // labelText: "Password"
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10),
              child: Text('Repeat your password'),
            ),
            TextFormField(
              controller: passwordCheckController,
              keyboardType: TextInputType.name,
              obscureText: _repeatPasswordVisible,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  hintText: 'Repeat your password',
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _repeatPasswordVisible = !_repeatPasswordVisible;
                        });
                      },
                      icon: Icon(_repeatPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off))),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10),
              child: Text('Family name'),
            ),
            TextFormField(
              controller: familyCodeController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail),
                hintText: 'Type your family name',
                border: UnderlineInputBorder(),
                // labelText: "Username"
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10),
              child: Text('Email'),
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail),
                hintText: 'abc@gmail.com',
                border: UnderlineInputBorder(),
                // labelText: "Username"
              ),
            ),
            const SizedBox(
              height: 20,
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
                      registerUser();
                    },
                    child: const Text(
                      'Create',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 2),
                    )),
              ),
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
              'Having an account ?',
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
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => const LoginView())
                // );
                Navigator.of(context).pop();
              },
              child: const Text(
                'Login',
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
