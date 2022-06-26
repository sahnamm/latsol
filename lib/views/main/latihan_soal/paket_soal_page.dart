import 'package:flutter/material.dart';
import 'package:latsol/constants/r.dart';
import 'package:latsol/constants/route_name.dart';
import 'package:latsol/models/network_response.dart';
import 'package:latsol/models/paket_soal_list.dart';
import 'package:latsol/respository/latihan_soal_api.dart';
import 'package:latsol/widgets/paket_soal.dart';

class PaketSoalPage extends StatefulWidget {
  static const String route = RouteName.routePaketSoalPage;
  const PaketSoalPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  State<PaketSoalPage> createState() => _PaketSoalPageState();
}

class _PaketSoalPageState extends State<PaketSoalPage> {
  PaketSoalList? paketSoalList;
  getPaketSoal() async {
    final mapelREsult = await LatihanSoalApi().getPaketSoal(widget.id);
    if (mapelREsult.status == Status.success) {
      paketSoalList = PaketSoalList.fromJson(mapelREsult.data!);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getPaketSoal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paket Soal"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Paket Soal",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: paketSoalList == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      primary: true,
                      child: GridView.builder(
                        shrinkWrap: true,
                        primary: false,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 2.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: paketSoalList!.data!.length,
                        itemBuilder: (BuildContext ctx, index) {
                          final currentPaketSoal = paketSoalList!.data![index];
                          return Container(
                            padding: const EdgeInsets.all(3),
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: PaketSoalWidget(data: currentPaketSoal),
                          );
                        },
                      ),

                      // child: GridView.count(
                      //   shrinkWrap: true,
                      //   mainAxisSpacing: 10,
                      //   crossAxisSpacing: 10,
                      //   crossAxisCount: 2,
                      //   childAspectRatio: 3 / 2,
                      //   children: const [
                      //     PaketSoalWidget(),
                      //     PaketSoalWidget(),
                      //     PaketSoalWidget(),
                      //     PaketSoalWidget(),
                      //   ],
                      // ),

                      // child: Wrap(
                      //   children:
                      //       List.generate(paketSoalList!.data!.length, (index) {
                      //     final currentPaketSoal = paketSoalList!.data![index];
                      //     return Container(
                      //       padding: const EdgeInsets.all(3),
                      //       width: MediaQuery.of(context).size.width * 0.45,
                      //       child: PaketSoalWidget(data: currentPaketSoal),
                      //     );
                      //   }).toList(),
                      // ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
