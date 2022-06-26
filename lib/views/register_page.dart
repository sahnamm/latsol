import 'package:flutter/material.dart';
import 'package:latsol/constants/enums.dart';
import 'package:latsol/constants/r.dart';
import 'package:latsol/constants/route_name.dart';
import 'package:latsol/helpers/preference_helper.dart';
import 'package:latsol/helpers/user_email.dart';
import 'package:latsol/models/network_response.dart';
import 'package:latsol/models/user_by_email.dart';
import 'package:latsol/respository/auth_api.dart';
import 'package:latsol/views/main_page.dart';
import 'package:latsol/widgets/button_login.dart';
import 'package:latsol/widgets/register_textfield.dart';

class RegisterPage extends StatefulWidget {
  static const String route = RouteName.routeRegisterPage;
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<String> classSlta = ["10", "11", "12"];

  String gender = R.strings.regGenderMan;
  String selectedClass = "10";
  final emailController = TextEditingController();
  final schoolNameController = TextEditingController();
  final fullNameController = TextEditingController();

  onTapGender(Gender genderInput) {
    if (genderInput == Gender.lakiLaki) {
      gender = R.strings.regGenderMan;
    } else {
      gender = R.strings.regGenderWoman;
    }
    setState(() {});
  }

  initDataUSer() {
    emailController.text = UserEmail.getUserEmail()!;
    fullNameController.text = UserEmail.getUserDisplayName()!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initDataUSer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f3f5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            R.strings.regTitle,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RegisterTextField(
                controller: fullNameController,
                title: R.strings.regFullName,
                hintText: R.strings.regFullName,
              ),
              const SizedBox(height: 10),
              RegisterTextField(
                controller: emailController,
                title: R.strings.regEmail,
                hintText: R.strings.regEmail,
              ),
              const SizedBox(height: 10),
              Text(
                R.strings.regGender,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: gender == R.strings.regGenderMan
                            ? R.colors.primary
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            width: 1,
                            color: R.colors.greyBorder,
                          ),
                        ),
                      ),
                      onPressed: () {
                        onTapGender(Gender.lakiLaki);
                      },
                      child: Text(
                        R.strings.regGenderMan,
                        style: TextStyle(
                          fontSize: 14,
                          color: gender == R.strings.regGenderMan
                              ? Colors.white
                              : const Color(0xff282828),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: gender == R.strings.regGenderWoman
                            ? R.colors.primary
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            width: 1,
                            color: R.colors.greyBorder,
                          ),
                        ),
                      ),
                      onPressed: () {
                        onTapGender(Gender.perempuan);
                      },
                      child: Text(
                        R.strings.regGenderWoman,
                        style: TextStyle(
                          fontSize: 14,
                          color: gender == R.strings.regGenderWoman
                              ? Colors.white
                              : const Color(0xff282828),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                R.strings.regClass,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: R.colors.greyBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: selectedClass,
                      items: classSlta
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (String? val) {
                        selectedClass = val!;
                        setState(() {});
                      }),
                ),
              ),
              const SizedBox(height: 10),
              RegisterTextField(
                controller: schoolNameController,
                title: R.strings.regSchoolName,
                hintText: R.strings.regSchoolName,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: ButtonLogin(
            onTap: () async {
              Navigator.of(context).pushNamed(MainPage.route);
              final json = {
                "email": emailController.text,
                "nama_lengkap": fullNameController.text,
                "nama_sekolah": schoolNameController.text,
                "kelas": selectedClass,
                "gender": gender,
                "foto": UserEmail.getUserPhotoUrl(),
              };
              final result = await AuthApi().postRegister(json);
              if (result.status == Status.success) {
                final registerResult = UserByEmail.fromJson(result.data!);
                if (registerResult.status == 1) {
                  await PreferenceHelper().setUserData(registerResult.data!);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainPage.route,
                    (context) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(registerResult.message!),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Terjadi kesalahan, silahkan ulangi kembali"),
                  ),
                );
              }
            },
            backgroundColor: R.colors.primary,
            borderColor: R.colors.primary,
            child: Text(
              R.strings.regButton,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
