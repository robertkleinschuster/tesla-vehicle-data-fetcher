<?php
const DATA_FILE = "../data/vehicle_data.json";
if (isset($_SERVER['HTTP_ORIGIN'])) {
    // should do a check here to match $_SERVER['HTTP_ORIGIN'] to a
    // whitelist of safe domains
    header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Max-Age: 86400');    // cache for 1 day
}
// Access-Control headers are received during OPTIONS requests
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {

    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD']))
        header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");

    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']))
        header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");

}
$response = [];
if (file_exists(DATA_FILE)) {
    $vehicleData = (array) json_decode(file_get_contents(DATA_FILE));
    unset($vehicleData["id"]);
    unset($vehicleData["user_id"]);
    unset($vehicleData["vehicle_id"]);
    unset($vehicleData["vin"]);
    $response = $vehicleData;
} else {
    $response["error"] = "no_vehicle_data";
    $response["error_description"] = "Data file does not exist.";
}
header( "Content-type: application/json" );
echo json_encode($response);
