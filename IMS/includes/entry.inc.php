<?php
    include_once 'dbh.inc.php';
    

    $data = mysqli_real_escape_string($conn, $argv[1]);
    $timestamp = mysqli_real_escape_string($conn, date("Y-m-d H:i:s"));

    $tcheck = substr($data, 0, 1);
    if($tcheck == 't'){

        $tempascii = substr($argv[1],1,1);
        
        $tempdec = ord($tempascii);
        if($tempdec >= 0x80){
            $temperature = (($tempdec^0xFF)+1);
        }
        else{
            $temperature = $tempdec;
        }

        $query = "INSERT INTO weather (temp, datetime) VALUES ('$temperature', '$timestamp')";
        mysqli_query($conn, $query);
    }
    else{
        $tag = $data;
        $cargroup = mysqli_real_escape_string($conn, substr($tag, 1, 1));
        $cartype = mysqli_real_escape_string($conn, substr($tag, 2, 2));
        $rmark = mysqli_real_escape_string($conn, substr($tag, 4, 4));
        $number = mysqli_real_escape_string($conn, substr($tag, 9, 6));

        $query = "INSERT INTO yard (tag, cargroup, cartype, rmark, num, timestmp) VALUES ('$tag', '$cargroup', '$cartype', '$rmark', '$number', '$timestamp')";
        mysqli_query($conn, $query);
    }
?>
