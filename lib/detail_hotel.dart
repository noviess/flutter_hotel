import 'package:flutter/material.dart';
import 'booking.dart';

class DetailHotelPage extends StatelessWidget {
  final Map hotel;

  const DetailHotelPage({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Hotel"),
        backgroundColor: Color.fromARGB(255, 255, 197, 229),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              "http://192.168.1.13/hotel_api/images/${hotel["gambar"]}",
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 220,
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(
                      Icons.hotel,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
            const SizedBox(height: 20),
            Text(
              hotel["nama_hotel"],
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 5),
                Expanded(child: Text(hotel["lokasi"])),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange),
                const SizedBox(width: 5),
                Text(hotel["rating"].toString()),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              "Rp ${hotel["harga"]} / malam",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.groups,
                  color: Colors.blueGrey,
                  size: 20,
                ),
                const SizedBox(width: 5),
                Text(
                  "Maks. ${hotel["max_tamu"]} orang / kamar",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Deskripsi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(hotel["deskripsi"] ?? "-"),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 197, 229),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingPage(hotel: hotel),
                    ),
                  );
                },
                child: const Text("BOOKING SEKARANG"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
