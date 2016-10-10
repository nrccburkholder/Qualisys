// javascript functions supporting ucHeader.ascx rollovers and image caching
function swapImg (obj) {
	if (obj.src.indexOf('_on') >= 0){
		obj.src = obj.src.replace('_on','_off');
	}
	else if (obj.src.indexOf('_off') >=0){
		obj.src = obj.src.replace('_off','_on');
	}
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