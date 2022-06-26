import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:latsol/constants/r.dart';
import 'package:latsol/helpers/preference_helper.dart';
import 'package:latsol/models/user_by_email.dart';
import 'package:latsol/views/login_page.dart';
import 'package:latsol/views/main/profile/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserData? user;
  getUserData() async {
    final data = await PreferenceHelper().getUserData();
    user = data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Akun Saya"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const EditProfilePage();
                }),
              );
              print("result");
              print(result);
              if (result == true) {
                getUserData();
              }
            },
            child: const Text(
              "Edit",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 60,
                    right: 15,
                    left: 15,
                  ),
                  decoration: BoxDecoration(
                    color: R.colors.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(9),
                      bottomRight: Radius.circular(9),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.userName ?? "-",
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              user?.userAsalSekolah ?? "-",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      user?.userFoto != null
                          ? CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(user!.userFoto!),
                              backgroundColor: Colors.transparent,
                            )
                          : Image.asset(
                              R.assets.imgUser,
                              height: 50,
                              width: 50,
                            ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7,
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 13),
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Identitas Diri"),
                      const SizedBox(height: 15),
                      Text(
                        "Name Lengkap",
                        style: TextStyle(
                          color: R.colors.greySubtitleHome,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        user?.userName ?? "-",
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Email",
                        style: TextStyle(
                          color: R.colors.greySubtitleHome,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        user?.userEmail ?? "-",
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Jenis Kelamin",
                        style: TextStyle(
                          color: R.colors.greySubtitleHome,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        user?.userGender ?? "-",
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Kelas",
                        style: TextStyle(
                          color: R.colors.greySubtitleHome,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        user?.jenjang ?? "-",
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Asal Sekolah",
                        style: TextStyle(
                          color: R.colors.greySubtitleHome,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        user?.userAsalSekolah ?? "-",
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await GoogleSignIn().signOut();
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginPage.route,
                      (route) => false,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 13),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          color: Colors.black.withOpacity(0.25),
                        )
                      ],
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Keluar",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
