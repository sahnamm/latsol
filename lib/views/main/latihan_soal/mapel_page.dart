import 'package:flutter/material.dart';
import 'package:latsol/constants/route_name.dart';
import 'package:latsol/models/mapel_list.dart';
import 'package:latsol/views/main/latihan_soal/paket_soal_page.dart';
import 'package:latsol/widgets/mapel.dart';

class MapelPage extends StatelessWidget {
  static const String route = RouteName.routeMapelPage;
  const MapelPage({Key? key, required this.mapel}) : super(key: key);

  final MapelList mapel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Mata Pelajaran"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 8,
        ),
        child: ListView.builder(
          itemCount: mapel.data?.length,
          itemBuilder: (context, index) {
            final currentMapel = mapel.data![index];
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
        ),
      ),
    );
  }
}
