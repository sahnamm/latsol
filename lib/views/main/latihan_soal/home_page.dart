import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latsol/constants/enums.dart';
import 'package:latsol/constants/r.dart';
import 'package:latsol/helpers/preference_helper.dart';
import 'package:latsol/models/banner_list.dart';
import 'package:latsol/models/mapel_list.dart';
import 'package:latsol/models/user_by_email.dart';
import 'package:latsol/respository/latihan_soal_api.dart';
import 'package:latsol/views/main/latihan_soal/mapel_page.dart';
import 'package:latsol/views/main/latihan_soal/paket_soal_page.dart';
import 'package:latsol/widgets/mapel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapelList? mapelList;
  getMapel() async {
    final mapelResult = await LatihanSoalApi().getMapel();
    if (mapelResult.status == Status.success) {
      mapelList = MapelList.fromJson(mapelResult.data!);
      setState(() {});
    }
  }

  BannerList? bannerList;
  getBanner() async {
    final banner = await LatihanSoalApi().getBanner();
    if (banner.status == Status.success) {
      bannerList = BannerList.fromJson(banner.data!);
      setState(() {});
    }
  }

  setupFcm() async {
// Get any messages which caused the application to open from
    // a terminated state.
    final tokenFcm = await FirebaseMessaging.instance.getToken();
    debugPrint("tokenfcm: $tokenFcm");

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    // if (initialMessage != null) {
    //   _handleMessage(initialMessage);
    // }

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification}');
      }
    });
  }

  UserData? dataUser;
  Future getUserDAta() async {
    dataUser = await PreferenceHelper().getUserData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMapel();
    getBanner();
    setupFcm();
    getUserDAta();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildUserHomeProfile(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildTopBanner(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildHomeListMapel(mapelList),
            ),
            Column(
              children: [
                Text(
                  R.strings.homeBannerLatest,
                  style: GoogleFonts.poppins().copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 170,
                  child: bannerList == null
                      ? const SizedBox(
                          height: 70,
                          width: double.infinity,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : ListView.builder(
                          itemCount: bannerList!.data!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final currentBanner = bannerList!.data![index];
                            return Padding(
                              padding: index != 4
                                  ? const EdgeInsets.only(left: 20.0)
                                  : const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(currentBanner.eventImage!),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 35),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column _buildHomeListMapel(MapelList? list) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              R.strings.homeChooseSubject,
              style: GoogleFonts.poppins().copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return MapelPage(mapel: mapelList!);
                  }),
                );
              },
              child: Text(
                R.strings.homeShowAll,
                style: GoogleFonts.poppins().copyWith(
                  fontSize: 12,
                  color: R.colors.primary,
                ),
              ),
            )
          ],
        ),
        list == null
            ? const SizedBox(
                height: 70,
                width: double.infinity,
                child: Center(child: CircularProgressIndicator()),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.data!.length > 3 ? 3 : list.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final currentMapel = list.data![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PaketSoalPage(
                            id: currentMapel.courseId!,
                          ),
                        ),
                      );
                    },
                    child: MapelWidget(
                      title: currentMapel.courseName!,
                      totalPacket: currentMapel.jumlahMateri!,
                      totalDone: currentMapel.jumlahDone!,
                    ),
                  );
                },
              )
      ],
    );
  }

  Widget _buildUserHomeProfile() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, ${dataUser?.userName ?? "Nama User"}",
                  style: GoogleFonts.poppins().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  R.strings.welcome,
                  style: GoogleFonts.poppins().copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          dataUser?.userFoto != null
              ? CircleAvatar(
                  radius: 17.5,
                  backgroundImage: NetworkImage(dataUser!.userFoto!),
                  backgroundColor: Colors.transparent,
                )
              : Image.asset(
                  R.assets.imgUser,
                  height: 35,
                  width: 35,
                ),
        ],
      ),
    );
  }

  Container _buildTopBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      height: 147,
      width: double.infinity,
      decoration: BoxDecoration(
        color: R.colors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0,
            ),
            child: Text(
              R.strings.homeStackLine,
              style: GoogleFonts.poppins().copyWith(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              R.assets.imgHome,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
