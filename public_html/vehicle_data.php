<?php
const DATA_FILE = "../data/vehicle_data.json";
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
