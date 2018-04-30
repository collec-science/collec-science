<?php
/**
 * Created : 24 avr. 2018
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2018 - All rights reserved
 * Script called after language changed in the software
 */
if (isset($_SESSION["searchSample"])) {
    $_SESSION["searchSample"]->reinit();
}
if (isset($_SESSION["searchMovement"])) {
    $_SESSION["searchMovement"]->reinit();
}

?>