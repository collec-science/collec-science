<div id="video-container">
    <div class="row">
        <div class="col-xs-12 center">
            <div id="video-container-reader">
            <video id="qr-video"></video>
            </div>
        </div>
    </div>
    <div class="form-horizontal">
        <div class="row">
            <label class="col-xs-4 form-label ">{t}Caméra :{/t}</label>
            <div class="col-xs-8">
                <select id="cam-list" class="form-select ">
                    <option value="environment" selected>{t}Caméra arrière (défaut){/t}</option>
                    <option value="user">{t}Caméra frontale{/t}</option>
                </select>
            </div>
        </div>
        <div class="row">
            <label class="col-xs-4 form-label ">{t}Mode couleur :{/t}</label>
            <div class="col-xs-8">
                <select id="inversion-mode-select" class="form-select ">
                    <option value="original">Scan original (dark QR code on bright background)</option>
                    <option value="invert">Scan with inverted colors (bright QR code on dark background)
                    </option>
                    <option value="both">Scan both</option>
                </select>
            </div>
        </div>
        <div class="row">
            <label for="cam-has-flash" class="col-xs-4 form-label ">{t}Flash présent :{/t}</label>
            <div class="col-xs-8">
                <span id="cam-has-flash"></span>
                <button id="flash-toggle">
                    📸 Flash: <span id="flash-state">{t}off{/t}</span>
                </button>
            </div>
        </div>
        <input type="hidden" id="cam-qr-result">
        <input type="hidden" id="cam-qr-error">
    </div>
</div>
<script src='display/node_modules/qr-scanner/qr-scanner.umd.min.js'></script>
<!-- from : https://nimiq.github.io/qr-scanner/demo/ -->
<link rel="stylesheet" href="display/CSS/qr-scanner.css">
<script src="display/javascript/qr-scanner.js"></script>
