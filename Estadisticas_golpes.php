<?php

// Conecta a la base de datos
$host = "localhost";
$user = "tu_usuario";
$password = "tu_contraseña";
$database = "tu_base_de_datos";

$pdo = new PDO('mysql:host=localhost;dbname=scoringc_golf;charset=utf8', 'scoringc_db', 'Et@290570');

// Prepara la consulta
$sql = "SELECT
  CONCAT(ROUND(AVG(CASE WHEN score - par <= -2 THEN 1 ELSE 0 END) * 100)) AS aguilas_pct,
  CONCAT(ROUND(AVG(CASE WHEN score - par = -1 THEN 1 ELSE 0 END) * 100)) AS birdies_pct,
  CONCAT(ROUND(AVG(CASE WHEN score - par = 0 THEN 1 ELSE 0 END) * 100)) AS pares_pct,
  CONCAT(ROUND(AVG(CASE WHEN score - par = 1 THEN 1 ELSE 0 END) * 100)) AS bogeys_pct,
  CONCAT(ROUND(AVG(CASE WHEN score - par = 2 THEN 1 ELSE 0 END) * 100)) AS doble_bogeys_pct,
  CONCAT(ROUND(AVG(CASE WHEN score - par >= 3 THEN 1 ELSE 0 END) * 100)) AS triple_bogeys_pct,
  AVG(score - golpes_hcp) AS avg_score_neto,
  AVG(score) AS avg_score_bruto
FROM
  tarjeta_jugadores_final_hoyos
  JOIN torneos ON tarjeta_jugadores_final_hoyos.id_torneo = torneos.id_torneo
WHERE
  tarjeta_jugadores_final_hoyos.matricula = :matricula
  AND torneos.start_date >= '2021-01-01'
  AND torneos.start_date <= CURDATE()
  AND score <> 0";

$stmt = $pdo->prepare($sql);

// Ejecuta la consulta con el parámetro :matricula
$matricula = $_GET['matricula'];
$stmt->bindParam(':matricula', $matricula);
$stmt->execute();

// Obtiene los resultados como un array asociativo
$resultado = $stmt->fetch(PDO::FETCH_ASSOC);

// Retorna los resultados en formato JSON
echo json_encode($resultado);

?>
