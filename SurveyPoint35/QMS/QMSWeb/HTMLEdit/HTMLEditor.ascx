<%@ Control language="vb" CodeBehind="HTMLEditor.ascx.vb" Inherits="QMSWeb.HtmlEditor" AutoEventWireup="false" %>
<STYLE TYPE="text/css"> TABLE#tblCoolbar { BORDER-RIGHT: buttonshadow 1px solid; PADDING-RIGHT: 1px; BORDER-TOP: buttonhighlight 1px solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; BORDER-LEFT: buttonhighlight 1px solid; COLOR: menutext; PADDING-TOP: 1px; BORDER-BOTTOM: buttonshadow 1px solid; BACKGROUND-COLOR: buttonface }
	.cbtn { BORDER-RIGHT: buttonface 1px solid; BORDER-TOP: buttonface 1px solid; BORDER-LEFT: buttonface 1px solid; BORDER-BOTTOM: buttonface 1px solid; HEIGHT: 18px }
	.txtbtn { FONT-SIZE: 70%; COLOR: menutext; FONT-FAMILY: tahoma }
</STYLE>
<script LANGUAGE="jscript">
function button_over(eButton)
	{
	eButton.style.backgroundColor = "#B5BDD6";
	eButton.style.borderColor = "darkblue darkblue darkblue darkblue";
	}
function button_out(eButton)
	{
	eButton.style.backgroundColor = "threedface";
	eButton.style.borderColor = "threedface";
	}
function button_down(eButton)
	{
	eButton.style.backgroundColor = "#8494B5";
	eButton.style.borderColor = "darkblue darkblue darkblue darkblue";
	}
function button_up(eButton)
	{
	eButton.style.backgroundColor = "#B5BDD6";
	eButton.style.borderColor = "darkblue darkblue darkblue darkblue";
	eButton = null; 
	}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

var isHTMLMode=false
var bShow = false
function cmdExec(cmd,opt) 
	{
  	if (isHTMLMode){alert("Please uncheck 'Edit HTML'");return;}
  	idContent.focus()
  	idContent.document.execCommand(cmd,bShow,opt);
  	bShow=false;
  	EditTextCopy();
	}
function EditTextCopy()
	{
	document.body.all("tbEditTextName").value = idContent.innerHTML;
	}
function setMode(bMode)
	{
	var sTmp;
  	isHTMLMode = bMode;
  	if (isHTMLMode){sTmp=idContent.innerHTML;idContent.innerText=sTmp;} 
	else {sTmp=idContent.innerText;idContent.innerHTML=sTmp;};
	}
function createLink()
	{
	if (isHTMLMode){alert("Please uncheck 'Edit HTML'");return;}
	cmdExec("CreateLink");
	}
function insertImage()
	{
	if (isHTMLMode){alert("Please uncheck 'Edit HTML'");return;}
	bShow=true;
	cmdExec("InsertImage");
	}
function insertRuler()
	{
	if (isHTMLMode){alert("Please uncheck 'Edit HTML'");return;}
	cmdExec("InsertHorizontalRule","");
	}
function foreColor()
	{
	var arr = showModalDialog("../HTMLEdit/selcolor.htm","","font-family:Verdana; font-size:10; dialogWidth:40em; dialogHeight:50em" );
	if (arr != null) cmdExec("ForeColor",arr);	
	}
</script>
<table id="tblCoolbar" height="100%" cellpadding="0" cellspacing="0">
	<tr valign="center">
		<td colspan="16" class="Normal">
			<select onchange="cmdExec('formatBlock',this[this.selectedIndex].value);this.selectedIndex=0">
				<option selected>Style</option>
				<option value="Normal">Normal</option>
				<option value="Heading 1">Heading 1</option>
				<option value="Heading 2">Heading 2</option>
				<option value="Heading 3">Heading 3</option>
				<option value="Heading 4">Heading 4</option>
				<option value="Heading 5">Heading 5</option>
				<option value="Address">Address</option>
				<option value="Formatted">Formatted</option>
				<option value="Definition Term">Definition Term</option>
			</select>
			<select onchange="cmdExec('fontname',this[this.selectedIndex].value);">
				<option selected>Font</option>
				<option value="Arial">Arial</option>
				<option value="Arial Black">Arial Black</option>
				<option value="Arial Narrow">Arial Narrow</option>
				<option value="Comic Sans MS">Comic Sans MS</option>
				<option value="Courier New">Courier New</option>
				<option value="System">System</option>
				<option value="Tahoma">Tahoma</option>
				<option value="Times New Roman">Times New Roman</option>
				<option value="Verdana">Verdana</option>
				<option value="Wingdings">Wingdings</option>
			</select>
			<select onchange="cmdExec('fontsize',this[this.selectedIndex].value);">
				<option selected>Size</option>
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6">6</option>
				<option value="7">7</option>
				<option value="8">8</option>
				<option value="10">10</option>
				<option value="12">12</option>
				<option value="14">14</option>
			</select>
			<input type="checkbox" onclick="setMode(this.checked)"><font size="1" style="font-size: 8pt">Edit 
				Html</font>
		</td>
	</tr>
	<tr>
		<td><div class="cbtn" onClick="cmdExec('cut')" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="1" vspace="1" align="absMiddle" src="../HTMLEdit/Cut.gif" alt="Cut">
			</div>
		</td>
		<td><div class="cbtn" onClick="cmdExec('copy')" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="1" vspace="1" align="absMiddle" src="../HTMLEdit/Copy.gif" alt="Copy">
			</div>
		</td>
		<td><div class="cbtn" onClick="cmdExec('paste')" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="1" vspace="1" align="absMiddle" src="../HTMLEdit/Paste.gif" alt="Paste">
			</div>
		</td>
		<td><div class="cbtn" onClick="cmdExec('bold')" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="1" vspace="1" align="absMiddle" src="../HTMLEdit/Bold.gif" alt="Bold">
			</div>
		</td>
		<td><div class="cbtn" onClick="cmdExec('italic')" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="1" vspace="1" align="absMiddle" src="../HTMLEdit/Italic.gif" alt="Italic">
			</div>
		</td>
		<td><div class="cbtn" onClick="cmdExec('underline')" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="1" vspace="1" align="absMiddle" src="../HTMLEdit/Under.gif" alt="Underline">
			</div>
		</td>
		<td><div class="cbtn" onClick="cmdExec('justifyleft')" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="1" vspace="1" align="absMiddle" src="../HTMLEdit/Left.gif" alt="Justify Left">
			</div>
		</td>
		<td><div class="cbtn" onClick="cmdExec('justifycenter')" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="1" vspace="1" align="absMiddle" src="../HTMLEdit/Center.gif" alt="Center">
			</div>
		</td>
		<td><div class="cbtn" onClick="cmdExec('justifyright')" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="1" vspace="1" align="absMiddle" src="../HTMLEdit/Right.gif" alt="Justify Right">
			</div>
		</td>
		<td><div class="cbtn" onClick="cmdExec('insertorderedlist')" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="2" vspace="1" align="absMiddle" src="../HTMLEdit/numlist.GIF" alt="Ordered List">
			</div>
		</td>
		<td><div class="cbtn" onClick="cmdExec('insertunorderedlist')" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="2" vspace="1" align="absMiddle" src="../HTMLEdit/bullist.GIF" alt="Unordered List">
			</div>
		</td>
		<td><div class="cbtn" onClick="cmdExec('outdent')" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="2" vspace="1" align="absMiddle" src="../HTMLEdit/deindent.gif" alt="Decrease Indent">
			</div>
		</td>
		<td><div class="cbtn" onClick="cmdExec('indent')" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="2" vspace="1" align="absMiddle" src="../HTMLEdit/inindent.gif" alt="Increase Indent">
			</div>
		</td>
		<td><div class="cbtn" onClick="foreColor()" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="2" vspace="1" align="absMiddle" src="../HTMLEdit/fgcolor.gif" alt="Forecolor">
			</div>
		</td>
		<td><div class="cbtn" onClick="cmdExec('createLink')" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="2" vspace="1" align="absMiddle" src="../HTMLEdit/Link.gif" alt="Link">
			</div>
		</td>
		<td><div class="cbtn" onClick="insertImage()" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="2" vspace="1" align="absMiddle" src="../HTMLEdit/Image.gif" alt="Image">
			</div>
		</td>
		<td><div class="cbtn" onClick="insertRuler()" onmouseover="button_over(this);" onmouseout="button_out(this);" onmousedown="button_down(this);" onmouseup="button_up(this);">
				<img hspace="2" vspace="1" align="absMiddle" src="../HTMLEdit/HR.gif" alt="Ruler">
			</div>
		</td>
		<td width="100%">
		</td>
	</tr>
	<tr>
		<td class="Normal" colspan="18">
			<input id="tbEditTextId" name="tbEditTextName" type=hidden value="<%=tbEditText%>">
		</td>
	</tr>
	<tr>
		<td height="100%" colspan="18">
			<DIV id="idContent" onkeyup="EditTextCopy();" contentEditable="true" width="100%" style="BORDER-RIGHT: 1px ridge; BORDER-TOP: 1px ridge; BORDER-LEFT: 1px ridge; BORDER-BOTTOM: 1px ridge; HEIGHT: 100%; BACKGROUND-COLOR: white">
				<%=EditText%>
			</DIV>
		</td>
	</tr>
</table>
