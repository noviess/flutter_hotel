<?php

include "koneksi.php";

$data = json_decode(file_get_contents("php://input"), true);

$nama = $data["nama"];
$email = $data["email"];
$no_hp = $data["no_hp"];
$password = $data["password"];

$sql = mysqli_query($conn,

"INSERT INTO users
(nama,email,no_hp,password)

VALUES

('$nama','$email','$no_hp','$password')"

);

if($sql){

    echo json_encode([
        "status"=>"success"
    ]);

}else{

    echo json_encode([
        "status"=>"failed"
    ]);

}