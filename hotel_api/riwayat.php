<?php
header("Content-Type: application/json");
include "koneksi.php";

$data = json_decode(file_get_contents("php://input"), true);
$id_user = $data["id_user"];
$sql = "SELECT b.id_booking, h.nama_hotel, b.check_in, b.check_out, b.jumlah_tamu, b.jumlah_kamar, b.jumlah_malam, b.total_harga
        FROM bookings b JOIN hotels h ON b.id_hotel = h.id_hotel
        WHERE b.id_user = '$id_user'
        ORDER BY b.id_booking DESC";

$result = mysqli_query($conn,$sql);

$data = [];
while($row = mysqli_fetch_assoc($result)){
    $data[] = $row;
}

echo json_encode($data);
?>