
$(document).ready(function() {
	

});

/**
 * Fonction de generation aleatoire d'un mot de passe
 * 
 * @returns {String}
 */
function GeneratePassword() {

	var length = 10;
	var sPassword = "";
	// length =
	// document.aForm.charLen.options[document.aForm.charLen.selectedIndex].value;

	// var lowercase = 1;
	var uppercase = 1;
	var numbers = 1;
	var punction = 1;
	var i = 0;

	for (i = 1; i <= length; i++) {

		numI = getRandomNum();
		if ((punction == 0 && checkPunc(numI))
				|| (numbers == 0 && checkNumbers(numI))
				|| (uppercase == 0 && checkUppercase(numI))) {
			i -= 1;
		} else {
			sPassword = sPassword + String.fromCharCode(numI);
		}
	}

	// document.aForm.passField.value = sPassword;

	return sPassword;
}

function getRandomNum() {
	// between 0 - 1
	var rndNum = Math.random();
	// rndNum from 0 - 1000
	rndNum = parseInt(rndNum * 1000);
	// rndNum from 33 - 127
	rndNum = (rndNum % 94) + 33;
	return rndNum;
}

function checkPunc(num) {
	if (((num >= 33) && (num <= 47)) || ((num >= 58) && (num <= 64))) {
		return true;
	}
	if (((num >= 91) && (num <= 96)) || ((num >= 123) && (num <= 126))) {
		return true;
	}
	return false;
}

function checkNumbers(num) {
	if ((num >= 48) && (num <= 57)) {
		return true;
	} else {
		return false;
	}
}

function checkUppercase(num) {
	if ((num >= 65) && (num <= 90)) {
		return true;
	} else {
		return false;
	}
}
/*
 * Verfication de la complexite d'un mot de passe Au minimum 3 jeux de
 * caracteres
 */
function verifyComplexity(password) {
	var caractere = "";
	var isLower = 0;
	var isUpper = 0;
	var isPonctuation = 0;
	var isNumber = 0;
	//console.log("password :" + password);
	for (i = 0; i < password.length; i++) {
		caractere = password.substr(i, 1).charCodeAt(0);
		//console.log(i + " : " + caractere);
		if (checkUppercase(caractere)) {
			isUpper = 1;
		} else if (checkNumbers(caractere)) {
			isNumber = 1;
		} else if (checkPunc(caractere)) {
			isPonctuation = 1;
		} else
			isLower = 1;
	}
	var complexity = parseInt(isLower) + parseInt(isUpper) + parseInt(isPonctuation) + parseInt(isNumber);
	if (complexity > 2) {
		return true;
	} else
		return false;
}

/*
 * Verification de la longueur du mot de passe au minimum, 8 caracteres
 */
function verifyLength(password) {
	if (password.length < 10) {
		return false;
	} else {
		return true;
	}
}
/*
 * Fin de la fonction de generation aleatoire d'un mot de passe
 */

function getPassword(password1, password2, display) {
	sPassword = GeneratePassword();
	document.getElementById(password1).value = sPassword;
	document.getElementById(password2).value = sPassword;
	document.getElementById(display).value = sPassword;
}