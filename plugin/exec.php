<?php
require(dirname(__FILE__).'/lib/csscomb.php');
$input = file_get_contents('php://stdin');
$c = new csscomb();
echo $c->csscomb($input);
?>
