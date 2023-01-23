<!DOCTYPE html>
<html>

  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <style>
      html {
        font-family: sans-serif;
        -ms-text-size-adjust: 100%;
        -webkit-text-size-adjust: 100%;
      }

      h1 {
        font-size: x-large;
        font-weight: bold;
        color: #003A80;
      }

      h2 {
        font-size: large;
        font-weight: bold;
        color: #009EE0;
      }

      h3 {
        color: #009EE0;
      }

      .messagebas {
        color: #009EE0;
        font-size: small;
        font-style: italic;
      }

    </style>
  </head>

  <body>
    {include file=$mailContent}
    <br>
    <p></p>
    <div class="messagebas">
    <img src="{$logo}" alt="logo" height="25px">
      {t}Ne répondez pas à ce mail, qui est généré automatiquement{/t}
    </div>
  </body>

</html>
