<?php
    include_once 'dbh.inc.php';
    
    function _bin8dec($bin) {
    // Function to convert 8bit binary numbers to integers using two's complement
        $num = bindec($bin);
        if($num > 0xFF) { return false; }
        if($num >= 0x80) {
            return -(($num ^ 0xFF)+1);
        } else {
            return $num;
        }
    }

    $received = mysqli_real_escape_string($conn, $argv[1]);
    $temperature = _bin8dec($received)
    $datetime = mysqli_real_escape_string($conn, date("Y-m-d H:i:s"));

    $query = "INSERT INTO weather (temp, datetime) VALUES ('$temperature', '$datetime')";
    mysqli_query($conn, $query);

?>