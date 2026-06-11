
    /*
     * element cam-qr-result contains the qrcode value
    * It must be triggered on change to extract the value     
    */
    var snd = new Audio("display/images/sound.ogg");
    var hasFoundCamera = false;
    const video = document.getElementById('qr-video');
    const videoContainer = document.getElementById('video-container-reader');
    const camHasCamera = document.getElementById('cam-has-camera');
    const camList = document.getElementById('cam-list');
    const camHasFlash = document.getElementById('cam-has-flash');
    const flashToggle = document.getElementById('flash-toggle');
    const flashState = document.getElementById('flash-state');
    const camQrError = document.getElementById('cam-qr-error');
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
    function setResult(field, result) {
        field.value = result.data.trim();
        scanner.stop();
        var event = new Event('change');
        field.dispatchEvent(event);
    }

    // ####### Web Cam Scanning #######
    var videosize = Math.min(window.screen.height, window.screen.width);
    videoContainer.style.width = videosize;
    videoContainer.style.height = videosize;
    video.style.width = videosize;
    video.style.height = videosize;

    const scanner = new QrScanner(video, result => setResult(camQrResult, result), {
        onDecodeError: error => {
            camQrError.textContent = error;
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
