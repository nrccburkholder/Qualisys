/**************************************************************************************
** Brock Fleming
** 20080606
** This JS file is used with the Error Page to toggle the display of details on the static 
** error page 
***************************************************************************************/

function ToggleVisible(id) {
    var ctrl = GetDocElement(id);
    if (ctrl != null){
        if (ctrl.style.display == "none"){
            ctrl.style.display = "block";
        }
        else {
            ctrl.style.display = "none";
        }
    }
}

function GetDocElement(elementId) {
	var browserId = GetBrowser();
	if (browserId == 1) {//IE5||NN6
		return document.getElementById(elementId);
	}
	else if (browserId == 2) { //IE4
		return document.all(elementId);
	}
	else if (browserId == 3) { //NN4
		return document.layers[elementId];
	}
}

function GetBrowser(){
	if (document.getElementById) { //IE5||NN6
		return 1;
	}
	else if (document.all) { //IE4
		return 2;
	}
	else if (document.layers) { //NN4
		return 3;
	}
	else {	//OTHER
		return 4;
	}
}




