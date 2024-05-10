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
    

    $data = $argv[1];
    $timestamp = mysqli_real_escape_string($conn, date("Y-m-d H:i:s"));

    $tcheck = substr($data, 0, 1);
    if($tcheck == 't'){

        //The Temperature values are all being returned as 0, you should look into that.
        $tempstr = substr($data, 1, 1); 

        //settype($tempstr, "integer");
        
        $temperature = hexdec($tempstr);
        //$temperature = _bin8dec($tempstr);

        $query = "INSERT INTO weather (temp, datetime) VALUES ('$temperature', '$timestamp')";
        mysqli_query($conn, $query);
    }
    else{
        $tag = mysqli_real_escape_string($conn,$data);
        $cargroup = mysqli_real_escape_string($conn, substr($tag, 1, 1));
        $cartype = mysqli_real_escape_string($conn, substr($tag, 2, 2));
        $rmark = mysqli_real_escape_string($conn, substr($tag, 4, 4));
        $number = mysqli_real_escape_string($conn, substr($tag, 9, 6));

        $query = "INSERT INTO yard (tag, cargroup, cartype, rmark, num, timestmp) VALUES ('$tag', '$cargroup', '$cartype', '$rmark', '$number', '$timestamp')";
        mysqli_query($conn, $query);
    }
?>
