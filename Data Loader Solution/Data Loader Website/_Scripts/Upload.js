/**************************************************************************************
** Tony Piccoli
** 20080402
** This file holds th jScripts relavent to the Upload ASPX Page
***************************************************************************************/

var reqArray = new Array();
var fileArray = new Array();

var divMode = '';
    
//*******************************************File Array Helper Methods*************************************
//Helper method to init file array so multiple methods can use it without fear of it not being initialized.
function InitFileArray()
{
    if (fileArray.length == 0)
        fileArray[0] = 1;
}
//Gets a unique FileID
function GetNewFileID()
{
    var newFileID = 0;
    for (i=0;i<fileArray.length;i++)
    {
	    if (newFileID <= fileArray[i])
	    {
		    newFileID = fileArray[i] + 1;
	    }
    }
    return newFileID;	
}
//When a user deletes a file control, it still keeps the array index, so this will get an accurate count of the file Array
function FileArrayCount()
{
    var count = 0;
    for(i=0;i<fileArray.length;i++)
    {
        if (fileArray[i] != 0)
        {
            count += 1;
        }
    }
    return count;
}
//************************************End File Array Helper Methods***************************************
    
   
    
//***********************************Display DHTML*******************************************************       
//This helper method shows/hides the upload queue grid and the progress bar for the upload queue grid.
function ToggleQueueGrid(hideGrid)
{
    if (hideGrid == true)
    {        
        document.getElementById("UpdateProgress").style.display = "block";
        document.getElementById("UpdateQueueGrid").style.display = "none";
        document.getElementById("UploadSessionStatus").style.display = "none";
        document.getElementById("MainDisplay").style.display = "none";
    }
    else
    {
        document.getElementById("UpdateProgress").style.display = "none";
        document.getElementById("UpdateQueueGrid").style.display = "block";
        document.getElementById("UploadSessionStatus").style.display = "block";
        document.getElementById("MainDisplay").style.display = "block";
    }
}
//**************************************End Display DHTML***************************************************


//*****************************************Page Validation methods***********************************************
//Validate that notes were entered in.
function NotesHasValue()
{
    /*Notes currently requires no validation.
    var retVal = false;
    if (document.forms[0].elements["SelectedNotes"].value != "")                    
        retVal = true;
    return retVal;*/
    return true;
}
//Validate that at least one package was selected.
function PackageSelected()
{

if (divMode != "Packages")
{
return false;
}

    var retVal = false;
    var packageIDs = new String();
    try {
    packageIDs = document.getElementById("SelectedPackageIDs").value;
    }
    catch(err)
    {
    //alert(err)
    return false;
    }
    var packageIDArray = new Array();
    packageIDArray = packageIDs.split(",");
    for(i=0;i<packageIDArray.length;i++)
    {
        var elName = new String();
        elName = "Package" + packageIDArray[i];
        var element = document.forms[0].elements[elName];
        if (element.checked == true)
        {
            retVal = true;
            i = packageIDArray.length;
        }
    }
    return retVal;
}

//Validate that a project manager was selected.
function ProjectManagerSelected() {
if (divMode != "Project Managers") { return false; }
    var retVal = false;
    for(i=0;i<document.forms[0].elements["SelectedProjectManagerID"].length;i++)
    {
        var element = document.forms[0].elements["SelectedProjectManagerID"][i];
        if (element.checked == true)
        {
           retVal = true;
        }
    }
    return retVal;
}


//Validate that the current file type has been selected.
function FileTypeSelected()
{
    var retVal = false;
    if (document.getElementById("SelectedFileType").selectedIndex >= 1) 
        retVal = true;
    return retVal;
}
//Validate that the current File control has a value in it.
function FileControlHasValue()
{
    InitFileArray();
    var retVal = false;
    var elName = new String();
    elName = "FileControl" + fileArray[fileArray.length-1];
    if (document.forms[0].elements[elName].value != "")
        retVal = true;
    return retVal;
}
//This method runs through the Add To Queue validation and displays the appropriate errors.
function ValidateAddToQueue()
{
    InitFileArray();
    
    if (FileControlHasValue() == false)
    {
        alert("You must first select a file to upload.");
    }
    else if (FileTypeSelected() == false)
    {
        alert("You must first select a file type.");
    }
    else if ((PackageSelected() == false) && (divMode == 'Packages'))
    {
        alert("You must select at least one package.");
    }
    else if ((ProjectManagerSelected() == false) && (divMode == 'Project Managers'))
    {
        alert("You must select a Measurement Services Manager.");
    }
    else if (NotesHasValue() == false)
    {
        alert("You must first input some notes.");
    }
    else if (FileArrayCount() - 1 >= 10)
    {
        alert("You may not upload more than 10 files at a time.");
    }
}
//**************************************End Page Validi ation methods**********************************************


//**************************************************Queue and Add File Event Handlers****************************************
//If valid, set flag and send ajax call to update the upload file queue grid.
function AddToQueue()
{       
    InitFileArray();
    
    if (NotesHasValue() && (PackageSelected() | ProjectManagerSelected()) && FileTypeSelected() && FileControlHasValue() && FileArrayCount() <= 10)
    {
        //Hide the current File control and add a new one.
        document.forms[0].elements["CurrentFileID"].value = fileArray[fileArray.length-1];
        AddNewFileControl();
        document.forms[0].elements["AjaxServerFlag"].value = "AddUpload";
        ToggleQueueGrid(true)
        var reqIndex = GetNewAjaxRequestIndex(); 
        MakeAjaxRequest("UploadQueueAjax.aspx", "POST", "", BuildUpdateGridFunctionString(reqIndex), reqIndex);
        ClearOptions(true);  
          
    }
    else
    {
            ValidateAddToQueue();
    }   
}




//This method Hides the existing file control and Adds a new visible one in its place.
function AddNewFileControl()    
{
    //if First time, init the file array.
    InitFileArray();
    //Hide the Current File Control.
    var elName = new String();        
    elName = "FileControlDiv" + fileArray[fileArray.length-1];
    document.getElementById(elName).style.display = "none";
    //Get the Set a new File Control.
    var newIndex = GetNewFileID();
    fileArray[fileArray.length] = newIndex;
    //Create the new file control.
    var newDiv = document.createElement("div");
    newDiv.setAttribute("id", "FileControlDiv" + newIndex);   
    var htmlString = "<input type=\"file\" name=\"FileControl" + newIndex + "\" style=\"width: 300px\" onkeydown=\"javascript:return false;\" oncontextmenu=\"javascript:return false;\" />";
    newDiv.innerHTML = htmlString;
    var containerDiv = document.getElementById("FileControlContainer");
    containerDiv.appendChild(newDiv);         
}


function ClearProjectManagersButtonGroup()
{
if(document.getElementById("SelectedProjectManagerID") != null) 
            {
                buttonGroup = document.forms[0].SelectedProjectManagerID;
                for (i=0; i < buttonGroup.length; i++) { 
                if (buttonGroup[i].checked == true) { 
                    buttonGroup[i].checked = false 
                    }
                }
            }
}



//Clears all of the form options for adding a file to the queue.
function ClearOptions(confirmFlag)
{
    InitFileArray();
    if (confirmFlag == false)
    {
        confirmFlag = confirm("Are you sure you would like to clear all file options?");
    }
    if (confirmFlag == true)
    {
        //Clear notes
        document.forms[0].elements["SelectedNotes"].value = "";
        
        
        //Clear packages, if packages were selected
        if (document.forms[0].elements["SelectedPackageIDs"] != null) {
        var packageIDs = new String();
        packageIDs = document.forms[0].elements["SelectedPackageIDs"].value;
        var packageIDArray = new Array();
        packageIDArray = packageIDs.split(",");
        for(i=0;i<packageIDArray.length;i++)
        {
            var elName = new String();
            elName = "Package" + packageIDArray[i];
            var element = document.forms[0].elements[elName];
            element.checked = false;                
        }
        }
        
        //Reset  Project Manager Selection
        ClearProjectManagersButtonGroup();
        
        
        //Reset the file type
        document.forms[0].elements["SelectedFileType"].selectedIndex = 0;
        //Remove and add in a new file control.
        var fileIndex = fileArray[fileArray.length-1];
        var containerDiv = document.getElementById("FileControlContainer");
        var elName = "FileControlDiv" + fileIndex;
        var currentDiv = document.getElementById(elName);
        containerDiv.removeChild(currentDiv);
        var newDiv = document.createElement("div");
        newDiv.setAttribute("id", "FileControlDiv" + fileIndex);   
        var htmlString = "<input type=\"file\" name=\"FileControl" + fileIndex + "\" style=\"width: 300px\" onkeydown=\"javascript:DisabledKeys(event);\"/>";
        newDiv.innerHTML = htmlString;            
        containerDiv.appendChild(newDiv);    
    }
}
//Delete a specific item from the queue.
function DeleteQueueItem(fileID)
{
    var result = false;
    result = confirm("Are you sure you wish to delete the selected item from the queue?");
    if (result)
    {
        //First delete the file control.
        var elName = new String();        
        elName = "FileControlDiv" + fileID;
        var containerDiv = document.getElementById("FileControlContainer");            
        var currentDiv = document.getElementById(elName);
        containerDiv.removeChild(currentDiv);
        //Remove from the file ID array.
        var fileIndex = 0;        
        for (i=0; i<fileArray.length; i++)
        {
            if (fileArray[i] == fileID)
            {
                //Clear the file Array
                fileArray[i] = 0;
            }
        }
        //Make the AJAX call to remove the file object.
        document.forms[0].elements["AjaxServerFlag"].value = "DELETEQUEUEITEM";
        document.forms[0].elements["CurrentFileID"].value = fileID;
		ToggleQueueGrid(true);
		var reqIndex = GetNewAjaxRequestIndex();
		MakeAjaxRequest("UploadQueueAjax.aspx", "POST", "", BuildUpdateGridFunctionString(reqIndex), reqIndex);
    }
}

function DeletedupItem(fileID)
{
    var result = true;
    if (result)
    {
        //First delete the file control.
        var elName = new String();        
        elName = "FileControlDiv" + fileID;
        var containerDiv = document.getElementById("FileControlContainer");            
        var currentDiv = document.getElementById(elName);
        containerDiv.removeChild(currentDiv);
        //Remove from the file ID array.
        var fileIndex = 0;        
        for (i=0; i<fileArray.length; i++)
        {
            if (fileArray[i] == fileID)
            {
                //Clear the file Array
                fileArray[i] = 0;
            }
        }
    }
}
//Delete all queue files.
function DeleteQueue()
{
    var result = false;
    result = confirm("Are you sure you wish to delete all queued items?");
    if (result)
    {
        //remove all but the current file control
        for (i=0; i<fileArray.length-1; i++)
        {
            var elName = new String();
            var index = fileArray[i];
            //If file array = 0, then this index has already been deleted.
            if (index != 0)
            {
                elName = "FileControlDiv" + index;
                var containerDiv = document.getElementById("FileControlContainer");            
                var currentDiv = document.getElementById(elName);
                containerDiv.removeChild(currentDiv);
                //TP 20080408 remove index from the file array
                fileArray[i] = 0;
            }
        }		
        //Make the ajax call to delete all of the queue.
		document.forms[0].elements["AjaxServerFlag"].value = "DELETEQUEUE";
		ToggleQueueGrid(true);
		var reqIndex = GetNewAjaxRequestIndex();
		MakeAjaxRequest("UploadQueueAjax.aspx", "POST", "", BuildUpdateGridFunctionString(reqIndex), reqIndex);
    }
}
//Upload all of the queued files.
function UploadQueuedFiles()
{
    var result = false;
    result = confirm("Are you sure you would like to upload the " + (FileArrayCount() -1) + " queued file(s)?");
    if (result)
    {
        //First, clear the current file control (it has not been added to the queue).
        //Remove and add in a new file control.
        var fileIndex = fileArray[fileArray.length-1];
        var containerDiv = document.getElementById("FileControlContainer");
        var elName = "FileControlDiv" + fileIndex;
        var currentDiv = document.getElementById(elName);
        containerDiv.removeChild(currentDiv);
        //Next, presave queued files.
        document.forms[0].elements["AjaxServerFlag"].value = "PRESAVEQUEUE";
        ToggleQueueGrid(true);
		var reqIndex = GetNewAjaxRequestIndex();
		MakeAjaxRequest("UploadQueueAjax.aspx", "POST", "", BuildPreSaveFunctionString(reqIndex), reqIndex);
	}
}
//This event fires when after the file queue has been updated and is ready to submit the form.
function ProcessPreUpdate(returnFlag)
{
    //var confirmFlag = false;
    try
    {
         //  [return flag] will either be 'TRUE': continue with no warning, 'FALSE'  Can not proceed, 'CONFIRM':  Some files succeeded, some did not, do they wish to continue?
        if (returnFlag == "FALSE")
        {
            alert("An error occured that has prevented the uploading of your files.");
        }
        else if (returnFlag == "CONFIRM")
        {
            confirmFlag = confirm("One or more files is unable to save.  Do you wish to continue?");
            if (confirmFlag)
            {
                document.forms[0].elements["ServerFlag"].value = "UploadFiles";
                ToggleQueueGrid(true);
                //document.forms[0].submit();
                DoUpload(document.forms[0]);

            }
        }
        else
        {
            document.forms[0].elements["ServerFlag"].value = "UploadFiles";
            ToggleQueueGrid(true);
            //Arman: commented out the following line
            //document.forms[0].submit();
            DoUpload(document.forms[0]);
        }
    }
    catch(e)
    {   //uncomment the next line to see the exception  
        //alert(e);      
        alert("We were unable to find the file specified. \n Please use the browse button to select the file.");
        window.location.href = "Upload.aspx";
    }
         
}
//**************************************End Queue Event Handlers************************************************

//**************************************ProgressBar related code***********************************************
//*************************************Added By Arman Mnatsakanyan*********************************************
          function DoUpload(inForm) {
             if ((typeof(Page_BlockSubmit) == 'boolean') && (Page_BlockSubmit == true)) return;
            //theFeats = 'height=160,width=600,location=no,menubar=no,resizable=no,scrollbars=no,status=no,toolbar=no';
            theUniqueID = Math.floor(Math.random() * 1000000) * ((new Date()).getTime() % 1000);
       
       //Steve Kennedy - changed from "document.all" to "document.getElementById"
            document.getElementById('myFrame').style.height = "160px";
            document.getElementById('myFrame').style.width = "750px";
            document.getElementById('myFrame').setAttribute("src","progressbar.aspx?ProgressID=" + theUniqueID);  
            //window.open('progressbar.aspx?ProgressID=' + theUniqueID, theUniqueID, theFeats);
            //Arman: The following line was causing an error in FireFox so I commented it out and 
            //  it seems to be working fine without it.
            //inForm = inForm.document.forms[0];
            
            thePos = inForm.action.indexOf('?');
            if (thePos >= 0)
            inForm.action = inForm.action.substring(0, thePos);
            inForm.action += '?UploadID=' + theUniqueID;
            inForm.submit();
            }
//**************************************************************************************************************
//***************************************AJAX Request methods***********************************************
//Each ajax request needs its own object.  This gets you a new pointer (index) to your ajax object
function GetNewAjaxRequestIndex()
{
    var index = reqArray.length;    
    return index;
}
//You must save all files to be uploads prior to actually posting the form..
function BuildPreSaveFunctionString(index)
{
    var retString = new String();        
    retString += "  if (reqArray[" + index + "].readyState == 4)";
    retString += "  {";
    retString += "     if (reqArray[" + index + "].status == 200)";
    retString += "     {";
    //  return values will be: [return flag]|[display HTML]
    //  [return flag] will either be 'TRUE': continue with no warning, 'FALSE'  Can not proceed, 'CONFIRM':  Some files succeeded, some did not, do they wish to continue?
    //  [display html]  will display the file queue grid along with any updating errors that may have happened.
    retString +=          "var retVal = new String();";
    retString += "        retVal = reqArray[" + index + "].responseText;";
    retString += "        var retArray = new Array();";
    retString += "        retArray = retVal.split(\"|\");";
    retString += "        ToggleQueueGrid(false);";
    retString += "        if (retVal.substring(0,2) == \"~~\") {";
    retString += "        retVal = retVal.replace(\"~~\",\"\");";
    retString += "        DeletedupItem(fileArray.length-1);";
    retString += "        alert('The Source File you are trying to upload has already been associated with the file type and package you have selected.'); }";
    retString += "        if (retVal == \"~ \") {";
    retString += "        location.href = ('ErrorTrap/StaticError.aspx'); }";
    retString += "        document.getElementById(\"UpdateQueueGrid\").innerHTML = retArray[1];";
    retString += "        ProcessPreUpdate(retArray[0]);";3
    retString += "     }";
    retString += "     else"
    retString += "     {";
    retString += "         alert(\"A problem was encountered with your request.\");";
    retString += "     }";
    retString += "  }";    
    return retString;
}
//You must use a function string for ajax calls when there are parameters in your return function.
function BuildUpdateGridFunctionString(index)
{
    var retString = new String();        
    retString += "  if (reqArray[" + index + "].readyState == 4)";
    retString += "  {";
    retString += "     if (reqArray[" + index + "].status == 200)";
    retString += "     {";
    retString += "        var retVal = new String();";
    retString += "        retVal = reqArray[" + index + "].responseText;";
    retString += "        ToggleQueueGrid(false);";
    retString += "        if (retVal.substring(0,2) == \"~~\") { ";
    retString += "        retVal = retVal.replace(\"~~\",\"\");";
    retString += "        DeletedupItem(fileArray.length-1);";
    retString += "        alert('The Source File you are trying to upload has already been associated with the file type and package you have selected.'); }";
    retString += "        if (retVal == \"~ \") {";
    retString += "        location.href = ('ErrorTrap/StaticError.aspx'); }";
    retString += "        document.getElementById(\"UpdateQueueGrid\").innerHTML = retVal;";
    retString += "     }";
    retString += "     else"
    retString += "     {";
    retString += "         alert(\"A problem was encountered with your request.\");";
    //retString += "         alert(reqArray[" + index + "].responseText);";
    retString += "     }";
    retString += "  }";    
    return retString;
}
function MakeAjaxRequest(url, postType, returnMethod, returnMethodString, reqArrayIndex)
{
    reqArray[reqArrayIndex] = false;
    //branch for native XMLHttpRequest object
    if (window.XMLHttpRequest && !(window.ActiveXObject))
    {
        //Handle Firefox bug.
        if (reqArray[reqArrayIndex].overrideMimeType)
        {
            reqArray[reqArrayIndex].overrideMimeType('text/html');
        }
        try
        {
            reqArray[reqArrayIndex] = new XMLHttpRequest();
        }
        catch (e)
        {
            reqArray[reqArrayIndex] = false;
        }
    }
    // branch for IE/Windows Active X version.
    else if (window.ActiveXObject)
    {
        try
        {
            reqArray[reqArrayIndex] = new ActiveXObject("Msxml2.XMLHTTP");
        }
        catch (e)
        {
            try
            {
                reqArray[reqArrayIndex] = new ActiveXObject("Microsoft.XMLHTTP");
            }
            catch (e)
            {
                reqArray[reqArrayIndex] = false;
            }
        }        
    }
    if (reqArray[reqArrayIndex])
    {
        if (returnMethodString == "")
        {
            reqArray[reqArrayIndex].onreadystatechange = returnMethod;
        }
        else
        {                     
            reqArray[reqArrayIndex].onreadystatechange = new Function(returnMethodString);
        }            
        if (postType == "GET")
        {
          reqArray[reqArrayIndex].open("GET", url, true);
          reqArray[reqArrayIndex].send("");
        }
        else
        {
            reqArray[reqArrayIndex].open('POST', url, true);
            reqArray[reqArrayIndex].setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            reqArray[reqArrayIndex].send(GetFormVars());
        }
    }   
}
//************************************End AJAX Request methods**************************************************


//*************************************Form Variable collection and URL Encoding methods************************
function URLEncode(strValue)
{
    var encodedString = new String();
    if (strValue.length > 0)
    {
    encodedString = escape(strValue);
    encodedString = encodedString.replace("+", "%2B");
    encodedString = encodedString.replace("/", "%2F");
    }
    return encodedString;
}
function URLDecode(strValue)
{
    var encodedString = new String();    
    if (strValue.length > 0)
    {
    encodedString = unescape(strValue);
    encodedString = encodedString.replace("%2B", "+");
    encodedString = encodedString.replace("%2F", "/");
    }
    return encodedString;
}
//Loop through the form and creates a key value pair of each element for ajax posting.
function GetFormVars()
{
    var retString = new String();
    var myForm = document.forms[0];
    for(i=0;i<myForm.elements.length; i++)
    {
        if (myForm.elements[i].name != "__VIEWSTATE")
        {
            if(myForm.elements[i].type == "checkbox")
            {
                if (myForm.elements[i].checked == true)
                {
                    retString += "&" + myForm.elements[i].name + "=on";
                }
                else
                {
                    retString += "&" + myForm.elements[i].name + "=";
                }
            }
            else if (myForm.elements[i].type == "select-multiple")
            {
                var cbo = myForm.elements[i];
                for(j=0;j<cbo.length;j++)
                {
                    
                }
            }
            
            
           else if (myForm.elements[i].type == "radio") 
           {
           if (myForm.elements[i].checked == true){ 
           retString += "&" + myForm.elements[i].name + "=" + URLEncode(myForm.elements[i].value) 
           }
           
           }
            
            
            
            else
            {
                retString += "&" + myForm.elements[i].name + "=" + URLEncode(myForm.elements[i].value);
            }
        }
    }
    if (retString.length > 0)
    {        
        retString.substr(1, retString.length -1);
    }
    return retString;
}
//************************************ End Form Variable collection and URL Encoding methods********************

//********************************* For swapping the menue images **********************************************
function swapImg (obj) {
	if (obj.src.indexOf('_on') >= 0){
		obj.src = obj.src.replace('_on','_off');
	}
	else if (obj.src.indexOf('_off') >=0){
		obj.src = obj.src.replace('_off','_on');
	}
}

//******************************** General use ******* copied from EReports.js **********************************
// changes the style of an object
// pass in reference to the object and the name of the new style
function swapStyle (obj, nStyle) {
	obj.className = nStyle;
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

//   Limits the amount of characters in the notes textbox
var charLimit=100;
function ResetValue(object)
{
var orgValue = object.value;
var newValue = orgValue.substr(0,(charLimit));
object.value = newValue;
}

function checkLimit() {
var charTyped = document.form1.SelectedNotes.value.length;
if(charTyped > charLimit)
{
ResetValue(document.form1.SelectedNotes);
alert("Notes Are Limited to 100 Characters");
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



//******************************** Specific use *****************************************
// toggles info of hiding and showing layer
// containing information about the FileType




//Begin New JS Info


var charLimit=100;
function ResetValue(ctl)
{
var orgValue = ctl.value;
var newValue = orgValue.substr(0,(charLimit));
ctl.value = newValue;
}

function checkLimit(ctl) {
var charTyped = ctl.value.length;
if(charTyped > charLimit)
{
ResetValue(ctl);
alert("Notes Are Limited to 100 Characters");
}
}//   Limits the amount of characters in the notes textbox

function showFileTypeInfoDiv()
{

if (document.getElementById("FileTypeInfo").style.display == "block")
{
document.getElementById("FileTypeInfo").style.display = "none";
}
else
{
document.getElementById("FileTypeInfo").style.display = "block";
}

}//   Shows the File type Info Div

function toggleContentDiv(id)
{

//hide others 
document.getElementById("Project Managers").style.display = "none";
document.getElementById("Packages").style.display = "none";
if (document.getElementById("Limited Access") != null) {
document.getElementById("Limited Access").style.display = "none";
}
//hide others 


var ctrl = GetDocElement(id);
if(ctrl.options[ctrl.selectedIndex].disabled)
{
ctrl.options[0].selected = true;
divMode = 'Limited Access';
if (document.getElementById(divMode) != null) {
    try {
    document.getElementById(divMode).style.display = "table-row";
    }
    catch(err)
    {
    document.getElementById(divMode).style.display = "block";
    }
}
return false;
} //   Limnited Access Div

var valueSelected = document.getElementById("SelectedFileType").value;

if (valueSelected > 0) 
{
    var divLayerToShow = document.getElementById(valueSelected).value;
    divMode = divLayerToShow;
    try {
    document.getElementById(divLayerToShow).style.display = "table-row";
    }
    catch(err)
    {
    document.getElementById(divLayerToShow).style.display = "block";
    }
}
else if (valueSelected == 0) {
    divMode = 'Limited Access';
    if (document.getElementById(divMode) != null) {
    try {
    document.getElementById(divMode).style.display = "table-row";
    }
    catch(err)
    {
    document.getElementById(divMode).style.display = "block";
    }
    }

}
}//   disables Items In Drop Down

   function DisabledKeys(e) {
        var intKey = window.Event ? e.which : e.KeyCode;
        
        if(intKey != 9)
            e.returnValue = false;
        else 
            e.returnValue = true;
    }//   disables text entry in file contol

function ViewInstructions(sender)
  {
  
  if (document.getElementById('InstructionTable').style.display == "block")
     {
     document.getElementById('InstructionTable').style.display = 'none';
     document.getElementById("ViewInstr").style.display = 'block';
     document.getElementById("CloseInstr").style.display = 'none';
     }
     else if (document.getElementById('InstructionTable').style.display == 'none')
     {
     document.getElementById('InstructionTable').style.display = 'block';
     document.getElementById("ViewInstr").style.display = 'none';
     document.getElementById("CloseInstr").style.display = 'block';
     }
  
  }//   Displays and hides instructions
  
onerror=handleErr; 
function handleErr(msg,url,l)
{
alert("You have been logged out due to inactivity");
location.href = "SignIn.aspx";
return true
}//   handles javascript Errors 

   //Parse string at Back slashes Or spaces     
   function ParseAtBackSlash(sToParse)
        {
        var fullString = new String();
        var ParseSizeString = 25;
        var TagSpot = new String();
        var increment = 0;
        var loopcount = 0;
        for (increment=0;increment<sToParse.length;increment++) 
        {
         var StopPointSlash = sToParse.substr(increment, ParseSizeString).lastIndexOf("\\") + 1;
         var StopPointSpace = sToParse.substr(increment, ParseSizeString).lastIndexOf(" ") + 1;
         if(StopPointSlash > 0)
         {
            TagSpot = sToParse.substr(increment, ParseSizeString).substring(0, StopPointSlash);
         }
         else if (StopPointSpace > 0) 
         {
            TagSpot = sToParse.substr(increment, ParseSizeString).substring(0, StopPointSpace);
         }
         else
         {
            TagSpot = sToParse.substr(increment, ParseSizeString);
         } 
         fullString += TagSpot;
         //fullstring += increment;  
         fullString += ("<br />");
         increment += TagSpot.length - 1;   
        } 
        return fullString
        }//   Parses at back slashes and adds <br /> tag 


                       
