// ignore_for_file: unused_element, use_build_context_synchronously

import 'dart:convert';

import 'package:code_mid/common/component/custom_text_field.dart';
import 'package:code_mid/common/const/colors.dart';
import 'package:code_mid/common/const/data.dart';
import 'package:code_mid/common/layout/default_layout.dart';
import 'package:code_mid/common/view/root_tab.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(height: 16),
                const _SubTile(),
                Image.asset(
                  'assets/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  obscureText: false,
                  onChanged: (value) {
                    username = value;
                  },
                  hintText: '이메일을 입력해주세요',
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  onChanged: (value) {
                    password = value;
                  },
                  hintText: '이메일을 입력해주세요',
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final rawString = '$username:$password';

                    Codec<String, String> stringToBase64 = utf8.fuse(base64);

                    String token = stringToBase64.encode(rawString);

                    final res = await dio.post(
                      'http://$ip/auth/login',
                      options: Options(
                        headers: {'authorization': 'Basic $token'},
                      ),
                    );
                    final refresh = res.data['refreshToken'];
                    final access = res.data['accessToken'];
                    storage.write(key: REFRESH_TOKEN_KEY, value: refresh);
                    storage.write(key: ACCESS_TOKEN_KEY, value: access);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RootTab(),
                      ),
                    );
                  },
                  child: const Text('로그인'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async {},
                  child: const Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다.',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

class _SubTile extends StatelessWidget {
  const _SubTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요! \n오늘도 성공적인 주문이 되길:)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
