<div class="container">
    <p class="text-muted hidden-xs hidden-sm">
        {$copyright}
        <br>
        {t}Pour tout problème :{/t} <a href="{$APP_help_address}" target="_blank">{$APP_help_address}</a>
    </p>
    {if strlen($developmentMode) > 1}
    <div class="red">{$developmentMode}</div>
    {/if}
</div>
<button type="button" class="btn btn-primary btn-floating btn-lg" id="btn-back-to-top">
    <i class="bi bi-arrow-bar-up"></i>
</button>
<script>
    //Get the button
    let mybutton = document.getElementById("btn-back-to-top");

    // When the user scrolls down 20px from the top of the document, show the button
    window.onscroll = function () {
        scrollFunction();
    };

    function scrollFunction() {
        if (
            document.body.scrollTop > 20 ||
            document.documentElement.scrollTop > 20
        ) {
            mybutton.style.display = "block";
        } else {
            mybutton.style.display = "none";
        }
    }
    // When the user clicks on the button, scroll to the top of the document
    mybutton.addEventListener("click", backToTop);

    function backToTop() {
        document.body.scrollTop = 0;
        document.documentElement.scrollTop = 0;
    }
</script>