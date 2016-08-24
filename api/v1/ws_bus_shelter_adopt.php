<?php
/*
    Attribute Query
    Performs attribute query on a table.
*/

# Return header
date_default_timezone_set('America/New_York');
header('content-type: application/json; charset=utf-8');
header("access-control-allow-origin: *");

# Includes
require("../inc/database.inc.txt");
require("../inc/error_handler.inc.php");

# Time limit and error reporting level
# For debugging set error_reporting(E_ERROR | E_WARNING | E_PARSE | E_NOTICE);
set_time_limit(5);
error_reporting(E_ERROR);
$sender = "gis@raleighnc.gov";
# Retrive URL arguments
$id = 0;
$email = "";
$contact = "";
$org = "";
$phone = "";
$shelter = "";
$values = "";

try {
	if (isset($_REQUEST['id'])) {
		$id = $_REQUEST['id'];
		$values  .= "id = " .$_REQUEST['id'];
	} else {
		throw new Exception('id value required');
	}

	$sql = "select * from adopt.adopters WHERE shelter_fk = " .$id;
	$db = pgConnection();
	$statement=$db->prepare($sql);
	$statement->execute();

	$count = $statement->rowCount();

	if ($count > 0) {
		throw new Exception("This shelter has already been adopted.");
	}

	if (isset($_REQUEST['email'])) {
		$email = $_REQUEST['email'];
	} else {
		throw new Exception("ERROR: email address required");
	}
	

	if (isset($_REQUEST['contact'])) {
		$contact = $_REQUEST['contact'];
	} else {
		throw new Exception("ERROR: contact value required");
	}
	

	if (isset($_REQUEST['organization'])) {
		$org = $_REQUEST['organization'];
	} else {
		throw new Exception("ERROR: organization value required");
	}

	if (isset($_REQUEST['phone'])) {
		$phone = $_REQUEST['phone'];
	} else {
		throw new Exception("ERROR: phone value required");
	}

	if (isset($_REQUEST['shelter'])) {
		$shelter = $_REQUEST['shelter'];
	} else {
		throw new Exception("ERROR: shelter name required");
	}
	

	if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
		throw new Exception("ERROR: valid email address required");
	}
	$sql = "select * from adopt.adopters where lower(email) = lower('$email') or lower(organization) = lower('$org')";
	$db = pgConnection();
	$statement=$db->prepare($sql);
	$statement->execute();
	if ($statement->rowCount() >= 3) {
		throw new Exception('A maximum of 3 shelters can be adopted by a single person or organization');
	}

	$sql = "INSERT into adopt.adopters (shelter_fk, organization, contact, phone, email, start, expires) VALUES ($id,'$org','$contact','$phone','$email',current_date, current_date + interval '1 year');";	



	$db = pgConnection();
	$statement=$db->prepare( $sql );
	$statement->execute();
	
	if ($statement->rowCount() > 0) {
		echo json_encode(array(
			'success' => array(
				'msg' => 'Shelter successfully adopted'
			)
		));
		$date = date("F jS, Y");
		$headers = 'MIME-Version: 1.0' . "\r\n" .
			'Content-type: text/html; charset=iso-8859-1' ."\r\n" . 
			'From: $sender' . "\r\n" .
			'Cc: $sender' . "\r\n" .
			'Reply-To: $sender' . "\r\n" .
			'X-Mailer: PHP/' .phpversion();
	
	
		$message = '
		<html>
			<head>
				<title>Adopt-A-Shelter Program</title>
			</head>
			<body style="font-family: calibri">
				<p>Thank you for your interest in the City of Raleigh Adopt-A-Shelter Program.  To complete the adoption process, please fill out the <a href="http://www.raleighnc.gov/content/PWksTransit/Documents/AdoptaShelter.pdf">Adopt-A-Shelter Agreement Form</a> and return the agreement form by email to goraleigh@raleighnc.gov or in person at 222 West Hargett Street, 4th Floor, Raleigh, NC 27601. Transit Staff <i>must</i> receive your agreement form prior to your first cleaning.</p>
				<p>Once Transit Staff has received your completed form, you will be provided with trash bags, disposable gloves and safety vests so you may begin trash removal at your adopted shelter at ' .$shelter .' for a period of 12 months beginning on ' .$date .'.</p>
				<p>Please contact Transit Staff with any questions regarding the Adopt-A-Shelter program by email at goraleigh@raleighnc.gov or by phone at 919-996-3030.</p>
			</body>
		</html>
		';
		mail($email, "Adopt-A-Shelter Program", $message, $headers);
	}
} catch (Exception $e) {
	echo json_encode(array(
		'error' => array(
			'msg' => $e->getMessage(),
			'code' => $e->getCode()
		)
	));
	exit();
}
?>
