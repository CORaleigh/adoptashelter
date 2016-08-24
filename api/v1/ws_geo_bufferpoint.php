<?php
/*
    Buffer Point
*/

# Return header
header('content-type: application/json; charset=utf-8');
header("access-control-allow-origin: *");

# Includes
require("../inc/database.inc.php");
require("../inc/error_handler.inc.php");

# Time limit and error reporting level
# For debugging set error_reporting(E_ERROR | E_WARNING | E_PARSE | E_NOTICE);
error_reporting(E_ERROR);
set_time_limit(5);

# Retrive URL arguments
$x = $_REQUEST['x'];
$y = $_REQUEST['y'];
$srid = $_REQUEST['srid'];
$distance = $_REQUEST['distance'];
$table = $_REQUEST['table'];
$geometryfield = isset($_REQUEST['geometryfield']) ? $_REQUEST['geometryfield'] : "the_geom";
$nsrid = isset($_REQUEST['nsrid']) ? $_REQUEST['nsrid'] : 2264;
$fields = isset($_REQUEST['fields']) ? $_REQUEST['fields'] : "*";
$parameters = isset($_REQUEST['parameters']) ? " and " . $_REQUEST['parameters'] : "";
$limit = isset($_REQUEST['limit']) ? " limit " . $_REQUEST['limit'] : '';
$order = isset($_REQUEST['order']) ? " order by " . $_REQUEST['order'] : ' order by distance ';

# Perform the query
$sql = "SELECT " . $fields . ",
ST_Distance(ST_GeomFromText('POINT(" . $x . " " . $y . ")'," . $srid ."),ST_transform(a." . $geometryfield . ",".$srid.")) as distance
FROM " . $table . " a WHERE ST_DWithin(a." . $geometryfield . ",
ST_Transform(ST_GeomFromText('POINT(" . $x . " " . $y . ")'," . $srid . "), " . $nsrid .  "), " . $distance . ") " . $parameters . $order . $limit;

$db = pgConnection();
$statement=$db->prepare( $sql );
$statement->execute();
$result = $statement->fetchAll(PDO::FETCH_ASSOC);

# send return
if (isset($_REQUEST['debug'])) $result = array_merge($result, array("sql" => $sql));
$json= json_encode( $result );
echo isset($_GET['callback']) ? "{$_GET['callback']}($json)" : $json;

?>
