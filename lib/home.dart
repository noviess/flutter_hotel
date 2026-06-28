import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail_hotel.dart';
import 'package:shared_preferences/shared_preferences.dart';  

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String nama = "";
  final String url = "http://192.168.1.13/hotel_api/get_hotel.php";
  Future<void> getUser() async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString("nama") ?? "";
    });
  }

  @override
  void initState() {

    super.initState();
    getUser();
  }

  Future<List<dynamic>> getHotels() async {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception("Gagal mengambil data hotel");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Booking Hotel"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 197, 229),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getHotels(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final hotels = snapshot.data ?? [];

          if (hotels.isEmpty) {
            return const Center(child: Text("Belum ada data hotel"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: hotels.length,
            itemBuilder: (context, index) {

              final hotel = hotels[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    "http://192.168.1.13/hotel_api/images/${hotel["gambar"]}",
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.hotel,
                        size: 40,
                      );
                    },
                  ),
                ),
                  title: Text(
                    hotel["nama_hotel"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(hotel["lokasi"]),

                      Text("⭐ ${hotel["rating"]}"),

                      Text(
                        "Rp ${hotel["harga"]} / malam",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Max ${hotel["max_tamu"]} orang / kamar",
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 13,
                        ),
                      ),

                    ],
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 197, 229),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Booking"),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailHotelPage(hotel: hotel),
                        ),
                      );
                    },
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
