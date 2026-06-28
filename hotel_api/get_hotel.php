<?php

header("Content-Type: application/json");

include "koneksi.php";

$sql = "SELECT * FROM hotels";

$result = mysqli_query($conn, $sql);

$data = array();

while($row = mysqli_fetch_assoc($result)){
    $data[] = $row;
}

echo json_encode($data);

?>