import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_taking_app/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickalert/quickalert.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  var _pass = Hive.box('password');
  String enteredPass = '';
  String newPass = '';
  String msgText = 'Create Your PIN';
  bool isPinVisible = false;
  late bool isNew;
  bool isCorrect = true;

  Widget numButton(int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: () {
          setState(() {
            if (enteredPass.length < 4) {
              enteredPass += number.toString();
            }
            checkPass();
          });
        },
        child: Text(
          number.toString(),
          style: const TextStyle(
              fontSize: 24, color: Colors.white, fontFamily: 'SFBold'),
        ),
      ),
    );
  }

  Future checkUser() async {
    var myPass = _pass.get('pass');
    if (myPass == null) {
      setState(() {
        isNew = true;
        msgText = 'Create Your PIN';
      });
    } else {
      setState(() {
        isNew = false;
        msgText = 'Enter Your PIN';
      });
    }
    print(myPass);
    print(isNew);
  }

  resetState() {
    setState(() {
      isCorrect = true;
      msgText = 'Enter Your PIN';
    });
  }

  Future checkPass() async {
    resetState();
    var myPass = _pass.get('pass');

    if (isNew) {
      createPin();
    } else {
      if (enteredPass.length == 4) {
        if (enteredPass == myPass) {
          print('Logged In');
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            showConfirmBtn: false,
            title: 'Logged In',
            autoCloseDuration: Duration(seconds: 1)
          ).then((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage()
              ),
              (route) => false,
            );
          });
        } else {
          print('Wrong Password');
          setState(() {
            enteredPass = '';
            msgText = 'Wrong PIN';
            isCorrect = false;
          });
        }
      }
    }
  }

  Future createPin() async {
    setState(() {
      isCorrect = true;
      if (newPass == '') msgText = 'Create Your PIN';
      else msgText = 'Re-Enter Your PIN';
    });
    if (enteredPass.length == 4 && newPass == '') {
      print('Go to Confirm');
      setState(() {
        newPass = enteredPass;
        enteredPass = '';
        msgText = 'Re-Enter Your PIN';
      });
    } else if (enteredPass.length == 4 && newPass != '') {
      if (enteredPass == newPass) {
        print('Success');
        _pass.put('pass', enteredPass);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          showConfirmBtn: false,
          title: 'PIN Created',
          text: 'Input your PIN to log in.',
          autoCloseDuration: Duration(seconds: 1)
        ).then((_) {
          setState(() {
            enteredPass = '';
            newPass = '';
            msgText = 'Enter Your PIN';
            isNew = false;
            isCorrect = true;
          });
        });
      } else {
        print('Not Same');
        setState(() {
        enteredPass = '';
        msgText = 'Wrong PIN';
        isCorrect = false;
      });
      }
    }
  }

  Future resetPin() async {
    print('PIN Reset');
    _pass.delete('pass');
    setState(() {
      enteredPass = '';
      newPass = '';
      msgText = 'Create Your PIN';
      isNew = true;
      isCorrect = true;
    });

    if (mounted) {
      Navigator.pop(context);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        showConfirmBtn: false,
        text: 'Reset PIN Successfully!',
        autoCloseDuration: Duration(seconds: 1)
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(height: 50),
            const Center(
              child: Text(
                'SECURITY PIN',
                style: TextStyle(
                    fontSize: 33,
                    color: Colors.amber,
                    fontFamily: 'SFBold',
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 25),
            Center(
              child: Text(msgText,
                style: TextStyle(
                    fontSize: 16,
                    color: isCorrect ? Colors.black : Colors.red,
                    fontFamily: 'SFReguler',
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) {
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: index < enteredPass.length
                          ? Colors.amber
                          : Colors.amber.withOpacity(0.2),
                    ),
                    child: index < enteredPass.length
                        ? const Center(
                            child: Text(
                              '●',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : null,
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  title: 'PIN Reset',
                  text: 'Do you want to reset your PIN?',
                  animType: QuickAlertAnimType.scale,
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  confirmBtnColor: Colors.green,
                  onConfirmBtnTap: () {
                    resetPin();
                  },
                );
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                    fontFamily: 'SFBold',
                    fontSize: 16,
                    color: Colors.purple,
                    fontStyle: FontStyle.italic),
              ),
            ),
            SizedBox(height: 10),
            for (var i = 0; i < 3; i++)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (index) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber,
                      ),
                      padding: EdgeInsets.only(
                          bottom: 18), // Adjust padding for the circle size
                      child: Center(child: numButton(1 + 3 * i + index)),
                    ),
                  ).toList(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextButton(onPressed: null, child: SizedBox()),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
                    ),
                    padding: EdgeInsets.only(bottom: 18),
                    child: Center(child: numButton(0)),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(
                        () {
                          if (enteredPass.isNotEmpty) {
                            enteredPass = enteredPass.substring(
                                0, enteredPass.length - 1);
                          }
                        },
                      );
                    },
                    child: const Icon(
                      Icons.backspace,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // TextButton(
            //   onPressed: () {
            //     setState(() {
            //       enteredPass = '';
            //     });
            //   },
            //   style: ButtonStyle(
            //     backgroundColor: WidgetStateProperty.all<Color>(Colors.amber),
            //   ),
            //   child: const Text(
            //     'Reset',
            //     style: TextStyle(
            //       fontSize: 20,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
