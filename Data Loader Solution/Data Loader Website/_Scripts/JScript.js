//Begin New JS Info
     function PostPanel(uparg) 
     {
       var oDiv = document.getElementsByTagName("div");
       var strs;
       var upPnl;
       for (var i = 0; i < oDiv.length; i++){
          if (oDiv[i].id.indexOf("mainFormPanel")>0){
          upPnl = oDiv[i];
          break;}}
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm._doPostBack(upPnl.id, uparg);
        //prm._doPostBack("UpdatePanel2", '');
    }//post back function for update panels that need js posts
    

 
    
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
  
  }//Displays and hides instructions

  function AddUploadFileControl()
       {
       
       var TdFiles = document.getElementById('CellForFileControls');
       var DivCont = TdFiles.getElementsByTagName('div');
       var DivFiles;
       var TheLabelNeeded;
       var argtopass;
       
       for (var i = 0; i < DivCont.length; i++){
          if (DivCont[i].id.indexOf("FileControls")>0){
          DivFiles = DivCont[i];
          break;}}
       var Labels = DivFiles.getElementsByTagName('span');
       var IpFileCtrl = DivFiles.getElementsByTagName('input');
       var IpFile;
       
       for (var i = 0; i < Labels.length; i++){
          if (Labels[i].id.indexOf("DispLabel")>0){
          TheLabelNeeded = Labels[i];
          break;}}
          
       if(TheLabelNeeded == null) 
       { 
          for (var i = 0; i < IpFileCtrl.length; i++){
             if (IpFileCtrl[i].id.indexOf("IpFile")>0){
             IpFile = IpFileCtrl[i];
             break;}}
             
             
          if(IpFile == null || IpFile.value == null || IpFile.value.length == 0)   
          {
             alert('Please select a file to add.');
             return;
          }
          else
          {
          var ver = Validate(IpFile);
          if (ver == "no")
          {
          alert("Invalid File Path for Upload!");
          return;
          }
          else
          {
             argtopass = IpFile.value + "|" + IpFile.id  + "|" + "UpPanel";
             DivFiles.removeChild(IpFile);
             document.getElementById('UploadFileControlHolder').appendChild(IpFile);
          }
          }
        }  
        else
        {
          argtopass = "UpPanel";
        }
       PostPanel(argtopass);
       }//Move File input Outside Updatepanel
       
       
  function swapImg (obj) {
	if (obj.src.indexOf('_on') >= 0){
		obj.src = obj.src.replace('_on','_off');
	}
	else if (obj.src.indexOf('_off') >=0){
		obj.src = obj.src.replace('_off','_on');
	}
}//Swap Image Function


function showFileTypeInfoDiv()
{
var fti = document.getElementById("FileTypeInfo");
if (fti.style.display == "none"){
fti.style.display = "block";
}
else
{
fti.style.display = "none";
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

function checkLength(ctrl)
{
if (ctrl.value.length > 500)
    {
    alert("You may only enter 500 charactes in the notes field.");
    var newvalue = ctrl.value.substring(0,499);
    ctrl.value = newvalue;
    }
}

function Validate(ctrl)
    {
    if(ctrl.value != "" && navigator.appName != "Netscape")
        {
        var iExt = ctrl.value.indexOf("\\");
        //var iDot = ctrl.value.indexOf(".");
        // || (iDot < 0))
        if((iExt < 0 ))
            {
            ctrl.focus();
            var ret = "no" 
            return ret ; 
        }
        }
    }
    
function getUploadsCount()
{ 
var oDiv = document.getElementById('QueueDataGrid');
var oInternal = document.getElementsByTagName('table');
var oTable;
for (var i = 0; i < oInternal.length; i++){
          if (oInternal[i].id.indexOf("fgrid")>0){
          oTable = oInternal[i];
          break;}}
            if (oTable || null) {
            return  oTable.rows.length - 1;
            }
            else 
            {
            return 1;
            }
            
}



  if (!document.all) {
    window.onbeforeunload = function() {
      Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequest);
    }
  }

  function endRequest(sender, e) {
    err = e.get_error();
    if (err){
      if (err.name == "Sys.WebForms.PageRequestManagerServerErrorException") {
        e.set_errorHandled(true);
      }
    }
  }

var theForm = document.forms['aspnetForm'];
if (!theForm) {
    theForm = document.aspnetForm;
}


function PostFullForm(eventTarget, eventArgument) {

        document.getElementById('FileInfotable').style.display = 'none';
        document.getElementById('QueueButtons').style.display = 'none';
        document.getElementById('UploadProgress').style.display = 'block';
        document.getElementById('UploadButtonDiv').style.display = 'none';
        theUniqueID = Math.floor(Math.random() * 1000000) * ((new Date()).getTime() % 1000);
        document.getElementById('myFrame').setAttribute('src','progressbar.aspx?ProgressID=' + theUniqueID);
        theForm.__EVENTTARGET.value = eventTarget;
        theForm.__EVENTARGUMENT.value = eventArgument;
        theForm.action += '?UploadID=' + theUniqueID;
        theForm.submit();
        
        return true;
}








