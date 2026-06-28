<?php
header("Content-Type: application/json");
include "koneksi.php";

$data = json_decode(file_get_contents("php://input"), true);

$id_user      = $data["id_user"];
$id_hotel     = $data["id_hotel"];
$check_in     = $data["check_in"];
$check_out    = $data["check_out"];
$jumlah_tamu   = $data["jumlah_tamu"];
$jumlah_kamar  = $data["jumlah_kamar"];
$jumlah_malam  = $data["jumlah_malam"];
$total_harga   = $data["total_harga"];

$sql = "INSERT INTO bookings
(id_user, id_hotel, check_in, check_out, jumlah_tamu, jumlah_kamar, jumlah_malam, total_harga)
VALUES
('$id_user', '$id_hotel', '$check_in', '$check_out', '$jumlah_tamu', '$jumlah_kamar', '$jumlah_malam', '$total_harga')";

if(mysqli_query($conn,$sql)){
    echo json_encode([
        "status"=>"success",
        "message"=>"Booking berhasil"
    ]);
}else{
    echo json_encode([
        "status"=>"failed",
        "message"=>mysqli_error($conn)
    ]);
}
?>
