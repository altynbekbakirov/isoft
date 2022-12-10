import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:isoft/data/shared_prefs.dart';
import 'package:isoft/screens/home_page.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordVisible = true;
  var isSubmitButtonEnabled = false;
  var rememberMe = true;
  Language? currentLanguage;

  @override
  void initState() {
    getSharedLocale().then((value) {
      setState(() {
        currentLanguage = Language.languageList()
            .where((element) => element.languageCode == value.languageCode)
            .first;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildEmail(),
              const SizedBox(
                height: 8,
              ),
              buildPassword(),
              const SizedBox(
                height: 8,
              ),
              buildDropDown(),
              const SizedBox(
                height: 8,
              ),
              buildCheckBox(),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [buildSubmit()],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmail() {
    return TextFormField(
      autofocus: true,
      maxLength: 30,
      controller: emailController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail_outline_outlined),
        labelText: translation(context).email,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        if (emailController.text.isEmpty ||
            !EmailValidator.validate(emailController.text) ||
            passwordController.text.isEmpty ||
            passwordController.text.length < 6) {
          setState(() {
            isSubmitButtonEnabled = false;
          });
        } else {
          setState(() {
            isSubmitButtonEnabled = true;
          });
        }
      },
      validator: (value) {
        if (value!.isEmpty || !EmailValidator.validate(value)) {
          return translation(context).enter_valid_email;
        } else {
          return null;
        }
      },
    );
  }

  Widget buildPassword() {
    return TextFormField(
      maxLength: 15,
      obscureText: isPasswordVisible,
      controller: passwordController,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value!.isEmpty || value.length < 6) {
          return translation(context).enter_password;
        } else {
          return null;
        }
      },
      onChanged: (value) {
        if (passwordController.text.isEmpty ||
            passwordController.text.length < 6 ||
            emailController.text.isEmpty ||
            !EmailValidator.validate(emailController.text)) {
          setState(() {
            isSubmitButtonEnabled = false;
          });
        } else {
          setState(() {
            isSubmitButtonEnabled = true;
          });
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
            icon: Icon(isPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined)),
        labelText: translation(context).password,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildCheckBox() {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(translation(context).remember_me),
      controlAffinity: ListTileControlAffinity.leading,
      value: rememberMe,
      onChanged: (bool? value) {
        setState(() {
          rememberMe = value!;
        });
      },
    );
  }

  Widget buildDropDown() {
    return DropdownButtonFormField<Language>(
      value: currentLanguage ?? Language.languageList()[0],
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 16)),
      isExpanded: true,
      items: Language.languageList()
          .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem<Language>(
              value: lang,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    lang.flag,
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(lang.name)
                ],
              )))
          .toList(),
      onChanged: (Language? language) async {
        if (language != null) {
          setState(() {
            currentLanguage = language;
          });
          Locale locale = await setSharedLocale(language.languageCode);
          MyApp.setLocale(context, locale);
        }
      },
    );
  }

  Widget buildSubmit() {
    return Expanded(
        child: ElevatedButton(
      onPressed: !isSubmitButtonEnabled
          ? null
          : () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              }
            },
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
      child: Text(
        translation(context).login,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
    ));
  }
}
