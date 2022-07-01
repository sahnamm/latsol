import 'package:flutter/material.dart';
import 'package:latsol/constants/enums.dart';
import 'package:latsol/constants/r.dart';
import 'package:latsol/models/result_response.dart';
import 'package:latsol/respository/latihan_soal_api.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.exerciseId}) : super(key: key);
  final String exerciseId;
  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  ResultResponse? resultData;
  getResult() async {
    final result = await LatihanSoalApi().getResult(widget.exerciseId);
    if (result.status == Status.success) {
      resultData = ResultResponse.fromJson(result.data!);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: resultData == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "Tutup",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Selamat",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const Text(
                      "Kamu telah menyelesaikan Kuiz ini",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 34),
                    Image.asset(
                      R.assets.imgResult,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    const SizedBox(height: 35),
                    const Text(
                      "Nilai kamu:",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      resultData!.data!.result!.jumlahScore!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 96,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
