import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'main_menu.dart';

class BookingPage extends StatefulWidget {
  final Map hotel;

  const BookingPage({super.key, required this.hotel});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final tamuController = TextEditingController(text: "1");

  DateTime? checkIn;
  DateTime? checkOut;
  int jumlahKamar = 0;
  int jumlahMalam = 0;
  int totalHarga = 0;

  final String bookingUrl = "http://192.168.1.13/hotel_api/booking.php";

  Future<void> pilihTanggal(bool isCheckIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkIn = picked;
        } else {
          checkOut = picked;
        }
      });
      hitungBooking();
    }
  }

  void hitungBooking() {

    if (checkIn == null || checkOut == null) return;

    int tamu = int.tryParse(tamuController.text) ?? 1;

    int maxTamu = int.parse(
      widget.hotel["max_tamu"].toString(),
    );

    int harga = int.parse(
      widget.hotel["harga"].toString(),
    );

    setState(() {

      jumlahKamar = (tamu / maxTamu).ceil();

      jumlahMalam = checkOut!
          .difference(checkIn!)
          .inDays;

      if (jumlahMalam <= 0) {
        jumlahMalam = 1;
      }

      totalHarga =
          harga *
          jumlahKamar *
          jumlahMalam;

    });

  }

  Future<void> simpanBooking() async {
    SharedPreferences prefs =
    await SharedPreferences.getInstance();
    int idUser =
    prefs.getInt("id_user") ?? 0;
    if (checkIn == null || checkOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi data booking")),
      );
      return;
    }

    final body = {
      "id_user": idUser.toString(),
      "id_hotel": widget.hotel["id_hotel"].toString(),
      "check_in": checkIn.toString().substring(0,10),
      "check_out": checkOut.toString().substring(0,10),
      "jumlah_tamu": tamuController.text,
      "jumlah_kamar": jumlahKamar.toString(),
      "jumlah_malam": jumlahMalam.toString(),
      "total_harga": totalHarga.toString(),
    };

    final res = await http.post(
      Uri.parse(bookingUrl),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode(body),
    );

    final result = jsonDecode(res.body);

    if (!mounted) return;

    if (result["status"] == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Booking berhasil"),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MainMenu(),
        ),
        (route) => false,
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking gagal")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Hotel"),
        backgroundColor: Color.fromARGB(255, 255, 197, 229),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 15),
            ListTile(
              tileColor: Colors.grey.shade200,
              title: Text(checkIn == null
                  ? "Pilih Check In"
                  : checkIn.toString().substring(0,10)),
              trailing: const Icon(Icons.calendar_month),
              onTap: ()=>pilihTanggal(true),
            ),
            const SizedBox(height: 10),
            ListTile(
              tileColor: Colors.grey.shade200,
              title: Text(checkOut == null
                  ? "Pilih Check Out"
                  : checkOut.toString().substring(0,10)),
              trailing: const Icon(Icons.calendar_month),
              onTap: ()=>pilihTanggal(false),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: tamuController,
              onChanged: (value) {
                hitungBooking();
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Jumlah Tamu",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Harga : Rp ${widget.hotel["harga"]}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Max Tamu / Kamar : ${widget.hotel["max_tamu"]}",
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Jumlah Kamar : $jumlahKamar",
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Jumlah Malam : $jumlahMalam",
                    ),

                    const Divider(),

                    Text(
                      "TOTAL : Rp $totalHarga",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),

                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: simpanBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 197, 229),
                  foregroundColor: Colors.white,
                ),
                child: const Text("BOOKING"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

