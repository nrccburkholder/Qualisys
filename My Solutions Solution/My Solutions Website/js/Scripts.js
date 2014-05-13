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

function SetTreeDivHtml(htmlString) {
	var treeDiv = GetDocElement('UnitTreeDiv');
	var browserId = GetBrowser();
	if (browserId == 1) {//IE5||NN6
		treeDiv.innerHTML=htmlString;
	}
	else if (browserId == 2) { //IE4
		treeDiv.innerHTML=htmlString;
	}
	else if (browserId == 3) { //NN4
		treeDiv.document.open();
		treeDiv.document.write(htmlString);
		treeDiv.document.close();
	}			
}

function ShowLoadingMessage(hideUnitTree) {
	var navPanel = GetDocElement('NextButtonDiv');
	if (navPanel != null) navPanel.style.display='none';
	
	if (hideUnitTree==true){
		var loadingHtml = '<font face="verdana, arial, helvetica" color="#7c7c7c" size="2">Loading...</font>';
		SetTreeDivHtml(loadingHtml);
	}
	else {
		var loadingPanel = GetDocElement('LoadingDiv');
		if (loadingPanel != null) loadingPanel.style.display='block';
	}
}

function StyleReplace(obj, sourceText, targetText){
    obj.className = targetText;
    var childElements = obj.childNodes;
    for (var i=0; i < childElements.length; i++){
        if (childElements[i].tagName == "SPAN"){
            childElements[i].className = targetText;
        }
    }
}

function UncheckOtherNodes(checkedNode, containerDiv, normalStyle, selectedStyle){
    var treeContainer = GetDocElement(containerDiv);
    var controls = treeContainer.getElementsByTagName("INPUT");      
        
    //Uncheck and set style of other nodes;
    for (var i=0; i < controls.length; i++){
        if (controls[i].type == "checkbox"){
            if (controls[i] != checkedNode){
                UncheckNode(controls[i], normalStyle, selectedStyle);
            }
        }
    }
}

function UncheckNode(checkBox, normalStyle, selectedStyle){
    var cell = null;
    checkBox.checked = false;
    if (document.all){
        cell = checkBox.parentElement;
    }
    else {
        cell = checkBox.parentNode;
    }
    StyleReplace(cell, selectedStyle, normalStyle);
}
function CheckNode(checkBox, normalStyle, selectedStyle){
    var cell = null;
    //Set style of checked node
    if (document.all){
        cell = checkBox.parentElement;
    }
    else {
        cell = checkBox.parentNode;
    }
    StyleReplace(cell, normalStyle, selectedStyle);
    checkBox.checked = true;
}

function SingleCheckTree_OnClick(e, containerDiv, normalStyle, selectedStyle) {
    var obj = null;
    if (document.all) {
        obj = window.event.srcElement;
    }
    else {
        obj = e.target;
    }
    if (obj.tagName == "INPUT" && obj.type == "checkbox") {
        var treeNode = obj;
        if (treeNode.checked != true) {
            UncheckNode(treeNode, normalStyle, selectedStyle);
        }
        else {
            CheckNode(treeNode, normalStyle, selectedStyle);
            UncheckOtherNodes(treeNode, containerDiv, normalStyle, selectedStyle);
        }
    }
    else if (obj.tagName == 'SPAN') {
        var nodeContainer = null;
        if (document.all) {
            nodeContainer = window.event.srcElement.parentElement;
        }
        else {
            nodeContainer = e.target.parentNode;
        }
        var controls = nodeContainer.getElementsByTagName("INPUT");
        if (controls.length == 1){
            var checkBox = controls[0];

            if (checkBox.checked == true){
                UncheckNode(checkBox, normalStyle, selectedStyle);
            }
            else {
                CheckNode(checkBox, normalStyle, selectedStyle);
                UncheckOtherNodes(checkBox, containerDiv, normalStyle, selectedStyle);
            }
        }
    }
} 

function UnitSelection_OnClick(source, e){
    SingleCheckTree_OnClick(e, "UnitTreeDiv", "UnitTreeNode", "UnitTreeNodeSelected");
	var dotNetName = source.id.split('_').join(':');
    __doPostBack(dotNetName, 'NodeCheckChanged');
}

var myWin;		// global reference for popup windows - use for function below to reload an existing popup and give it focus
function OpenWindow(url, nm, features) {
	// check to see if the window is already open or has been closed
	if ( !myWin || myWin.closed ) {
		myWin = window.open( url, nm, features );
	} else {										// if open reload with the new url and give window focus
		myWin.location = url;
		myWin.focus();
	}
}

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