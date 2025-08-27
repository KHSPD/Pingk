import 'package:flutter/material.dart';
import 'package:pingk/common/constants.dart';
import 'package:pingk/common/my_colors.dart';
import 'package:pingk/common/my_functions.dart';
import 'package:pingk/common/my_widget.dart';
import 'package:pingk/page_sign_up/sign_up.dart';
import 'package:pingk/page_sign_up/set_password.dart';

// ====================================================================================================
// 휴대전화번호 인증 페이지
// ====================================================================================================
class PhoneNumberAuth extends StatefulWidget {
  final SignUpData signUpData;
  const PhoneNumberAuth(this.signUpData, {super.key});
  @override
  State<PhoneNumberAuth> createState() => _PhoneNumberAuthState();
}

class _PhoneNumberAuthState extends State<PhoneNumberAuth> {
  final List<String> _carriers = ['SKT', 'KT', 'LGT'];
  String _selectedCarrier = 'SKT';
  String _inputPhoneNumber = '';
  String _inputAuthCode = '';
  bool _enabledCodeRequestButton = false;
  bool _showCodeInputForm = false;
  bool _showCompleteButton = false;

  // --------------------------------------------------
  // API - 인증코드 요청
  // --------------------------------------------------
  Future<void> _requestCode() async {
    Loading().show(context);
    try {
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
  // API - 인증코드 확인
  // --------------------------------------------------
  Future<void> _checkCode() async {
    Loading().show(context);
    try {
      // TODO: 실제 인증코드 확인 로직 추가 할것
      await Future.delayed(const Duration(seconds: 1));
      widget.signUpData.carrier = _selectedCarrier;
      widget.signUpData.phoneNumber = _inputPhoneNumber;
      if (mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SetPassword(widget.signUpData)));
      }
    } catch (e) {
      debugPrint(e.toString());
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
      backgroundColor: MyColors.background1,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        // 위젯이 없는 빈영역까지 터치 이벤트 감지
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
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                            color: MyColors.background2,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: MyColors.border1),
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
                                  color: MyColors.background2,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: MyColors.border1),
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
                                  backgroundColor: _enabledCodeRequestButton ? MyColors.primary : MyColors.background2,
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
                              color: MyColors.background2,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: MyColors.border1),
                            ),
                            child: TextField(
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 20),
                              decoration: const InputDecoration(border: InputBorder.none, hintText: '(임시) 임의 숫자 6자리 입력', hintStyle: TextStyle(fontSize: 14), counterText: ''),
                              onChanged: (value) {
                                _showCompleteButton = value.length == 6 && RegExp(r'^[0-9]+$').hasMatch(value);
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
