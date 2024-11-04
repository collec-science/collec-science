<!doctype html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="robots" content="noindex">

    <!-- Bootstrap -->
    <link rel="stylesheet" href="display/javascript/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="display/javascript/bootstrap/css/bootstrap-theme.min.css">
    <script src="display/node_modules/bootstrap/dist/js/bootstrap.min.js"></script>

    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="display/CSS/bootstrap-prototypephp.css">

    <title><?= lang('PpciError.title') ?></title>
</head>

<body>
    <div id="wrap">
        <div class="container-fluid">
        <?php if (lang('PpciError.locale') == "fr")  { ?>
            <h1><?= lang('PpciError.titletext') ?></h1>
            <p><?= lang('PpciError.incident') ?></p>
            <ul>
                <li><?= lang('PpciError.url') ?></li>
                <li><?= lang('PpciError.heure') ?></li>
                <li><?= lang('PpciError.detail') ?></li>
            </ul>
            <?php } else { ?>
                <h1>An error has occurred during execution of the requested module</h1>
            <p>Report the incident to the application administrator, indicating:</p>
                <ul>
                <li>the URL called (address bar)</li>
                <li>the date and the time</li>
                <li>details of the operation you were carrying out</li>
            </ul>
            <?php } ?>

        </div>
    </div>

</body>

</html>