import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}
class _RiwayatPageState extends State<RiwayatPage> {

  Future<List<dynamic>> getRiwayat() async {
    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    int idUser = prefs.getInt("id_user") ?? 0;
    final res = await http.post(
        Uri.parse("http://192.168.1.13/hotel_api/riwayat.php",),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
            "id_user": idUser.toString(),
        }),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception("Gagal memuat riwayat");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Booking"),
        backgroundColor: Color.fromARGB(255, 255, 197, 229),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getRiwayat(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(child: Text("Belum ada booking"));
          }

          return ListView.builder(
            itemCount: data.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, i) {
              final item = data[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.hotel,color: Color.fromARGB(255, 13, 0, 86)),
                  title: Text(item["nama_hotel"]),
                  subtitle: Text(
                    "Check In : ${item["check_in"]}\n"
                    "Check Out : ${item["check_out"]}\n"
                    "Jumlah Tamu : ${item["jumlah_tamu"]}\n"
                    "Jumlah Kamar : ${item["jumlah_kamar"]}\n"
                    "Jumlah Malam : ${item["jumlah_malam"]}",
                    ),
                  trailing: Text(
                    "Rp ${item["total_harga"]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
