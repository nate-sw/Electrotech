<?php
    include_once 'dbh.inc.php';
    

    $tag = mysqli_real_escape_string($conn, $argv[1]);
    $cartype = mysqli_real_escape_string($conn, substr($tag, 1, 3));
    $rmark = mysqli_real_escape_string($conn, substr($tag, 4, 4));
    $number = mysqli_real_escape_string($conn, substr($tag, 9, 6));
    $timestamp = mysqli_real_escape_string($conn, date("Y-m-d H:i:s"));

    $sql = "INSERT INTO yard (tag, cartype, rmark, num, timestmp) VALUES ('$tag', '$cartype', '$rmark', '$number', '$timestamp')";
    mysqli_query($conn, $sql);


    header("Location: ../list.php?entry=success");

