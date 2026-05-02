
    var snd = new Audio("display/images/sound.ogg");
    var destination = "object";
    var hasFoundCamera = false;

    const video = document.getElementById('qr-video');
    const videoContainer = document.getElementById('video-container');
    const camHasCamera = document.getElementById('cam-has-camera');
    const camList = document.getElementById('cam-list');
    const camHasFlash = document.getElementById('cam-has-flash');
    const flashToggle = document.getElementById('flash-toggle');
    const flashState = document.getElementById('flash-state');
    const camQrResult = document.getElementById('cam-qr-result');

    function searchCamera() {
        if (!hasFoundCamera) {
            QrScanner.listCameras(true).then(cameras => cameras.forEach(camera => {
                const option = document.createElement('option');
                option.value = camera.id;
                option.text = camera.label;
                camList.add(option);
            }));
            hasFoundCamera = true;
        }
    }
    //$("#video-container").width($(document).width());

    // ####### Web Cam Scanning #######
    var videosize = Math.min(window.screen.height, window.screen.width);
    $("#video-container-reader").width(videosize);
    $("#video-container-reader").height(videosize);

    const scanner = new QrScanner(video, result => setResult(camQrResult, result), {
        onDecodeError: error => {
            camQrResult.textContent = error;
            camQrResult.style.color = 'inherit';
        },
        highlightScanRegion: true,
        highlightCodeOutline: true,
    });

    const updateFlashAvailability = () => {
        scanner.hasFlash().then(hasFlash => {
            camHasFlash.textContent = hasFlash;
            flashToggle.style.display = hasFlash ? 'inline-block' : 'none';
        });
    };

    // for debugging
    window.scanner = scanner;

    document.getElementById('inversion-mode-select').addEventListener('change', event => {
        scanner.setInversionMode(event.target.value);
    });

    camList.addEventListener('change', event => {
        scanner.setCamera(event.target.value).then(updateFlashAvailability);
    });

    flashToggle.addEventListener('click', () => {
        scanner.toggleFlash().then(() => flashState.textContent = scanner.isFlashOn() ? 'on' : 'off');
    });

    $("#video-container").hide();
