<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/styles.css">
    <title>Yard</title>
</head>
<body>
    <div class="menu">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" class="logo" id="dropdown-icon">
            <path d="M40,40 L40,0 20,0 20,20 0,20 0,40 40,40 Z"/>
            <path d="M60,40 L80,40 80,80 40,80 40,40 60,40 Z"/>
        </svg>
        <div class="dropdown-content" id="dropdown-content">
            <a href="#">Link 1</a>
            <a href="#">Link 2</a>
            <a href="#">Link 3</a>
        </div>
    </div>
    <div id="container">
        <h1>Yard Entries</h1>
        
        <table>
            <tr>
                <th>Tag</th>
                <th>Cargroup</th>
                <th>Cartype</th>
                <th>Reporting Mark</th>
                <th>ID number</th>
                <th>Time stamp</th>
            </tr>
            <?php
                // Connect to MySQL
                include_once 'includes/dbh.inc.php';

                // Query to fetch data
                $query = "select * from yard";
                $result = mysqli_query($conn, $query);

                // Display data
                if (mysqli_num_rows($result) > 0) {
                    while($row = mysqli_fetch_assoc($result)) {
                        echo "<tr>";
                        echo "<td>".$row['tag']."</td>";
                        echo "<td>".$row['cargroup']."</td>";
                        echo "<td>".$row['cartype']."</td>";
                        echo "<td>".$row['rmark']."</td>";
                        echo "<td>".$row['num']."</td>";
                        echo "<td>".$row['timestmp']."</td>";
                        echo "</tr>";
                    }
                } else {
                    echo "0 results";
                }

                // Close connection
                mysqli_close($conn);
            ?>
        </table>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('dropdown-icon').addEventListener('click', function() {
                var menu = document.getElementById('dropdown-content');
                menu.classList.toggle('show');
            });
        });
    </script>
</body>
</html>
