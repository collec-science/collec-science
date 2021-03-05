<?php
require_once 'framework/identification/totp.class.php';
require_once "framework/droits/acllogin.class.php";
$gacltotp = new Gacltotp($privateKey,$pubKey);

if (empty($_SESSION["login"])) {
  $module_coderetour = -1;
} else {
  $acllogin = new Acllogin($bdd_gacl, $ObjetBDDParam);
  $datalogin = $acllogin->getFromLogin($_SESSION["login"]);
  if (empty($datalogin["acllogin_id"])) {
    $datalogin["acllogin_id"] = $acllogin->addLoginByLoginAndName($_SESSION["login"]);
  }
  switch ($t_module["param"]) {
    case "create":
      if ($acllogin->isTotp()) {
        $message->set(_("Vous avez déjà activé l'identification à double facteur : contactez un administrateur de l'application pour réinitialiser cette fonction"), true);
        $module_coderetour = -1;
      }
      if (!isset($_SESSION["totpSecret"])) {
        $_SESSION["totpSecret"] = $gacltotp->createSecret();
        $gacltotp->createQrCode();
      }
      $vue->set("framework/droits/otpCreate.tpl", "corps");
      break;
    case "createVerify":
      if (empty($_POST["otpcode"])) {
        $module_coderetour = -1;
        $message->set(_("Les informations fournies sont insuffisantes pour valider la création de la double identification"));
      } else {
        if ($gacltotp->verifyOtp($_SESSION["totpSecret"], $_POST["otpcode"])) {
          /**
           * Write the secret into the database
           */
          $datalogin["totp_key"] = $gacltotp->encodeTotpKey($_SESSION["totpSecret"]);
          $acllogin->ecrire($datalogin);
          unset($_SESSION["totpSecret"]);
          $module_coderetour = 1;
          $message->set(_("La double authentification est maintenant activée."));
          /**
           * Delete the qrcode
           */
          $filename = $APPLI_temp."/".$_SESSION["login"]."_totp.png";
          if (file_exists($filename)) {
            unlink($filename);
          }
        } else {
          $message->set(_("Le code fourni n'a pu être vérifié"), true);
          $module_coderetour = -1;
        }
      }
      break;

    case "getQrcode":
      /**
       * must be a vuebinaire instance
       */
      $vue->setParam(
        array(
          "disposition" => "inline",
          "tmp_name" => $APPLI_temp . "/" . $_SESSION["login"] . "_totp.png"
        )
      );
  }
}
