/* ======================================================================================
STRING MANIPULATION FUNCTIONS
=======================================================================================*/

/* calls ltrim and rtrim to remove leading and trailing characters from a string
 inputString = string to trim
 removeChar = the character to remove
 */
 
function lrtrim (inputString, removeChar) {
	var returnString = inputString;
	if (removeChar.length) 	{
		returnString = ltrim(returnString, removeChar);
		returnString = rtrim(returnString, removeChar);
	}
	return returnString;
}

// removes leading characters from a string
function ltrim (inputString, removeChar) {
	var returnString = inputString;
	if (removeChar.length) {
	  while(''+returnString.charAt(0)==removeChar) {
		  returnString=returnString.substring(1,returnString.length);
		}
	}
	return returnString;
}

// removes trailing characters from a string
function rtrim (inputString, removeChar) {
	var returnString=inputString;
	if (removeChar.length) 	{
		while(''+returnString.charAt(returnString.length-1)==removeChar) {
			returnString=returnString.substring(0,returnString.length-1);
		}
	}
	return returnString;
}

// use with a form text field event handler to update a form field with a trimmed value
function autotrim ( txtfield, removechar ) {
	var cntrl, value;										// variable for the form control and its value
	cntrl = txtfield;										// reference to the text field control
	value = txtfield.value;								// reference to the text field's value
	txtfield.value = lrtrim(value, removechar);						// trim the field value using the lrtrim() function
}

/* ======================================================================================
END STRING MANIPULATION FUNCTIONS
=======================================================================================*/


/* ======================================================================================
START UTILITY FUNCTIONS
=======================================================================================*/
var w;
function winOpen(link) {
	if (w == undefined || w.closed == true) {
		w = window.open(link, '','height=300,width=300,location=0,resizable=no,toolbar=no,scrollbars=yes');
	} else {
		w.focus();
		w.location = link;
	}
}
function winClose () {
	window.close();
}
var myWin;		// global reference for popup windows - use for function below to reload an existing popup and give it focus
function newWin(url, nm, features) {
	// check to see if the window is already open or has been closed
	if ( !myWin || myWin.closed ) {
		myWin = window.open( url, nm, features );
	} else {										// if open reload with the new url and give the window focus
		myWin.location = url;
		myWin.focus();
	}
}
/* ======================================================================================
END UTILITY FUNCTIONS
=======================================================================================*/

function GetCookie (name) {
	strCookies = document.cookie.split(';');
	//alert(document.cookie);
	for (var i=0; i < strCookies.length; i++){
	//alert('{' + ltrim(strCookies[i].substring(0,name.length),' ') + '}');
		if (ltrim(strCookies[i],' ').substring(0,name.length) == name){
			//alert('Cookie found');
			return strCookies[i].substring(name.length+1);
		}
	}
	return null;
 }

function SetCookie (name, value)
 {
	var argv = SetCookie.arguments;
	var argc = SetCookie.arguments.length;
	var expires = (argc > 2) ? argv[2] : null;
	var path = (argc > 3) ? argv[3] : null;
	var domain = (argc > 4) ? argv[4] : null;
	var secure = (argc > 5) ? argv[5] : false;
	document.cookie = name + "=" + escape (value) + ((expires == null) ? "" : ("; expires=" + expires.toGMTString())) + ((path == null) ? "" : ("; path=" + path)) + ((domain == null) ? "" : ("; domain=" + domain)) + ((secure == true) ? "; secure" : "");
 }

function CookiesEnabled(){
	var cookies_enabled = "";
	SetCookie ('testcookie', 1, null, null, null, (document.location.href.substring(0,6).toLowerCase() == 'https:') );
	cookies_enabled = GetCookie('testcookie');

	if (cookies_enabled==null)
		//alert('Cookies are disabled');
		document.location.href='GotCookies.aspx';
}
