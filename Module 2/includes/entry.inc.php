<?php
    include_once 'dbh.inc.php';
    

    $tag = mysqli_real_escape_string($conn, $argv[1]);
    $cargroup = mysqli_real_escape_string($conn, substr($tag, 1, 1));
    $cartype = mysqli_real_escape_string($conn, substr($tag, 2, 2));
    $rmark = mysqli_real_escape_string($conn, substr($tag, 4, 4));
    $number = mysqli_real_escape_string($conn, substr($tag, 9, 6));
    $timestamp = mysqli_real_escape_string($conn, date("Y-m-d H:i:s"));

    $query = "INSERT INTO yard (tag, cargroup, cartype, rmark, num, timestmp) VALUES ('$tag', '$cargroup', '$cartype', '$rmark', '$number', '$timestamp')";
    mysqli_query($conn, $query);


    header("Location: ../list.php?entry=success");

