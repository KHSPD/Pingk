import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pingk/common/constants.dart';
import 'package:pingk/common/my_styles.dart';
import 'package:pingk/common/my_functions.dart';
import 'package:pingk/common/my_widget.dart';
import 'package:pingk/common/local_storage.dart';

// ====================================================================================================
// 휴대전화번호 인증 페이지
// ====================================================================================================
class PhoneNumberAuth extends StatefulWidget {
  const PhoneNumberAuth({super.key});
  @override
  State<PhoneNumberAuth> createState() => _PhoneNumberAuthState();
}

class _PhoneNumberAuthState extends State<PhoneNumberAuth> {
  final int _authCodeLength = 4;
  final List<String> _carriers = ['SKT', 'KT', 'LGT'];
  String _selectedCarrier = 'SKT';
  String _inputPhoneNumber = '';
  String _inputAuthCode = '';
  bool _enabledCodeRequestButton = false;
  bool _showCodeInputForm = false;
  bool _showCompleteButton = false;

  // --------------------------------------------------
  // Lifecycle Methods
  // --------------------------------------------------
  @override
  void initState() {
    debugPrint('PhoneNumberAuth : initState');
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('PhoneNumberAuth : dispose');
    super.dispose();
  }

  // --------------------------------------------------
  // 인증코드 요청
  // --------------------------------------------------
  Future<void> _requestCode() async {
    Loading().show(context);
    try {
      // 전화번호 형식 검사
      if (!_inputPhoneNumber.startsWith('010') || _inputPhoneNumber.length != 11) {
        Loading().hide();
        MyFN.showSnackBar(message: '휴대전화 번호 형식이 잘못되었습니다.');
        return;
      }
      // TODO: 실제 인증코드 요청 로직 추가 할것
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _showCodeInputForm = true;
      });
    } catch (e) {
      debugPrint(e.toString());
      MyFN.showSnackBar(message: messageError);
    } finally {
      Loading().hide();
    }
  }

  // --------------------------------------------------
  // 인증코드 확인
  // --------------------------------------------------
  Future<void> _checkCode() async {
    FocusScope.of(context).unfocus();
    Loading().show(context);
    try {
      final String apiUrl = '$apiServerURL/api/auth/access';
      final Map<String, dynamic> body = {'phoneNumber': _inputPhoneNumber, 'authCode': _inputAuthCode, 'registerType': _selectedCarrier};
      final response = await http.post(Uri.parse(apiUrl), headers: {'Content-Type': 'application/json', 'Accept': 'application/json'}, body: jsonEncode(body));

      debugPrint('========== API Response: $apiUrl =====');
      debugPrint('status: ${response.statusCode}');
      debugPrint('body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['code'] == '200') {
          final String accessToken = responseBody['result']['accessToken'];
          final String refreshToken = responseBody['result']['refreshToken'];
          await LocalStorage().saveAccessToken(accessToken);
          await LocalStorage().saveRefreshToken(refreshToken);
          if (mounted) {
            context.go('/set_password');
          }
        } else {
          final String message = responseBody['message'];
          MyFN.showSnackBar(message: message);
        }
      } else {
        // API 응답이 실패한 경우
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        final String errorMessage = errorData['message'] ?? '인증에 실패했습니다.';
        MyFN.showSnackBar(message: errorMessage);
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
      MyFN.showSnackBar(message: messageError);
    } finally {
      Loading().hide();
    }
  }

  // --------------------------------------------------
  // build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        // ----- 타이틀 -----
                        const Text(
                          '휴대전화번호 인증',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 40),

                        // ----- 설명 -----
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('서비스를 사용하기 위해\n휴대전화번호를 인증해주세요.', textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
                        ),

                        const SizedBox(height: 40),

                        // ----- 통신사 선택 -----
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('통신사 선택', textAlign: TextAlign.left, style: TextStyle(fontSize: 14)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0xFF4A4A4A)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCarrier,
                              isExpanded: true,
                              items: _carriers.map((carrier) {
                                return DropdownMenuItem<String>(value: carrier, child: Text(carrier));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCarrier = value ?? _carriers[0];
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // ----- 휴대전화 번호 입력 폼 -----
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('휴대전화번호', textAlign: TextAlign.left, style: TextStyle(fontSize: 14)),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            // ----- 휴대전화번호 입력 필드 -----
                            Expanded(
                              child: Container(
                                height: 60,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Color(0xFF4A4A4A)),
                                ),
                                child: TextField(
                                  maxLength: 11,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontSize: 20),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '휴대전화번호 입력 ("-" 없이 숫자만 입력)',
                                    hintStyle: TextStyle(fontSize: 16),
                                    counterText: '',
                                  ),
                                  onChanged: (value) {
                                    _enabledCodeRequestButton = value.length == 11 && RegExp(r'^[0-9]+$').hasMatch(value);
                                    setState(() {
                                      _inputPhoneNumber = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // ----- 코드 요청 버튼 -----
                            SizedBox(
                              width: 80,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: _enabledCodeRequestButton
                                    ? () {
                                        FocusScope.of(context).unfocus();
                                        _requestCode();
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _enabledCodeRequestButton ? Color(0xFFFF437A) : Color(0xFF4A4A4A),
                                  foregroundColor: _enabledCodeRequestButton ? Colors.white : MyColors.text2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.zero,
                                  elevation: 0,
                                ),
                                child: const Text('코드요청', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // ----- 인증 코드 입력 폼 -----
                        if (_showCodeInputForm) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('인증코드 입력', textAlign: TextAlign.left, style: TextStyle(fontSize: 14)),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xFF4A4A4A)),
                            ),
                            child: TextField(
                              maxLength: _authCodeLength,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 20),
                              decoration: const InputDecoration(border: InputBorder.none, hintText: '(임시) 임의 숫자 4자리 입력', hintStyle: TextStyle(fontSize: 14), counterText: ''),
                              onChanged: (value) {
                                _showCompleteButton = value.length == _authCodeLength && RegExp(r'^[0-9]+$').hasMatch(value);
                                setState(() {
                                  _inputAuthCode = value;
                                });
                              },
                            ),
                          ),
                        ],

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),

              // ----- 확인 -----
              if (_showCompleteButton) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                  child: BottomLongButton('확인', () {
                    _checkCode();
                  }),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
