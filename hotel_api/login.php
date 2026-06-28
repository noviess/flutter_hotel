<?php

include "koneksi.php";

$data = json_decode(file_get_contents("php://input"), true);

$email = $data["email"];
$password = $data["password"];

$sql = "SELECT * FROM users
WHERE email='$email'
AND password='$password'";

$query = mysqli_query($conn,$sql);

if(mysqli_num_rows($query)>0){

    $user = mysqli_fetch_assoc($query);

    echo json_encode([
        "status"=>"success",
        "id_user"=>$user["id_user"],
        "nama"=>$user["nama"],
        "email"=>$user["email"],
        "no_hp"=>$user["no_hp"]
    ]);

}else{

    echo json_encode([
        "status"=>"failed"
    ]);

}