import 'package:flutter/material.dart';
import 'package:latsol/constants/r.dart';
import 'package:latsol/models/paket_soal_list.dart';
import 'package:latsol/views/main/latihan_soal/kerjakan_latihan_soal_page.dart';

class PaketSoalWidget extends StatelessWidget {
  const PaketSoalWidget({
    Key? key,
    required this.data,
  }) : super(key: key);
  final PaketSoalData data;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => KerjakanLatihanSoalPage(id: data.exerciseId!),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.withOpacity(0.2),
              ),
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                R.assets.icNote,
                width: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.exerciseTitle!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${data.jumlahDone}/${data.jumlahSoal} Paket Soal",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 9,
                color: R.colors.greySubtitleHome,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
