<?php
header('Content-Type: application/json');

$pdo = new PDO('mysql:host=localhost;dbname=scoringc_golf;charset=utf8', 'scoringc_db', 'Et@290570');

if (empty($_GET['matricula'])) {
    $response = [
        'status' => 'error',
        'message' => 'Missing parameter: matricula'
    ];
    echo json_encode($response);
    exit();
}

$stmt = $pdo->prepare("
SELECT 
    torneos.title AS club_name,
    DATE_FORMAT(torneos.start_date, '%Y/%m/%d') AS start_date,
    CONCAT(ROUND(AVG(CASE WHEN score - par <= -2 THEN 1 ELSE 0 END) * 100), '%') AS aguilas_pct,
    CONCAT(ROUND(AVG(CASE WHEN score - par = -1 THEN 1 ELSE 0 END) * 100), '%') AS birdies_pct,
    CONCAT(ROUND(AVG(CASE WHEN score - par = 0 THEN 1 ELSE 0 END) * 100), '%') AS pares_pct,
    CONCAT(ROUND(AVG(CASE WHEN score - par = 1 THEN 1 ELSE 0 END) * 100), '%') AS bogeys_pct,
    CONCAT(ROUND(AVG(CASE WHEN score - par = 2 THEN 1 ELSE 0 END) * 100), '%') AS doble_bogeys_pct,
    CONCAT(ROUND(AVG(CASE WHEN score - par >= 3 THEN 1 ELSE 0 END) * 100), '%') AS triple_bogeys_pct,
    SUM(score - golpes_hcp) AS total_score_neto,
    CONCAT('https://www.scoring.com.ar/app/images/clubes/', clubes.imagen) AS club_image,
    CONCAT('https://www.scoring.com.ar/app/images/clubes/logos/', clubes.logo) AS club_logo,
    jugadores.nombre AS player_name,
    CONCAT('https://www.scoring.com.ar/app/images/jugadores/', jugadores.imagen) AS player_image
FROM 
    tarjeta_jugadores_final_hoyos
    JOIN torneos ON tarjeta_jugadores_final_hoyos.id_torneo = torneos.id_torneo
    JOIN clubes ON torneos.id_club = clubes.id_club
    JOIN jugadores ON tarjeta_jugadores_final_hoyos.matricula = jugadores.matricula
WHERE 
    tarjeta_jugadores_final_hoyos.matricula = :matricula 
    AND torneos.start_date >= '2021-01-01' 
    AND torneos.start_date <= CURDATE()
GROUP BY tarjeta_jugadores_final_hoyos.id_torneo
HAVING COUNT(CASE WHEN score = 0 THEN 1 ELSE NULL END) = 0
ORDER BY start_date DESC
");

$stmt->bindParam(':matricula', $_GET['matricula']);

if ($stmt->execute()) {
    $response = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($response);
    exit();
} else {
    $response = [
        'status' => 'error',
        'message' => 'Error fetching data from database'
    ];
    echo json_encode($response);
    exit();
}