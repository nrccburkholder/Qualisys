<%@ Page Language="vb" AutoEventWireup="false" Codebehind="scriptscreen.aspx.vb" Inherits="QMSWeb.frmScriptScreen" %>
<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<style type="text/css">
		.script_status_hl { FONT-SIZE: 8pt; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none }
		</style>
		<LINK href="../Styles.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body onkeypress="handleKeyPress()">
		<form id="Form1" method="post" runat="server">
			<!-- BEGIN HEADER -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td rowspan="2" width="241">
						<table width="241" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td rowspan="3" bgcolor="#990000" width="1"><img src="../images/clear.gif" width="1" height="1"></td>
								<td><img src="../images/qms-logo.gif" width="241" height="36"></td>
							</tr>
							<tr>
								<td height="3" bgcolor="#d7d7c3"><img src="../images/clear.gif" width="1" height="1"></td>
							</tr>
							<tr>
								<td height="1" bgcolor="#990000"><img src="../images/clear.gif" width="1" height="1"></td>
							</tr>
						</table>
					</td>
					<td bgcolor="#990000"><img src="../images/clear.gif" width="1" height="18"></td>
				</tr>
				<tr>
					<td width="100%">
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td width="100%" background="../images/header-bg.gif"><img src="../images/clear.gif" width="4" height="22"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<!-- END HEADER -->
			<p>
				<TABLE class="main" align="center">
					<tr>
						<td>
							<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
								<tr>
									<td>
										<!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
										<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<tr>
												<td class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td bgColor="#d7d7c3" rowSpan="2">
													<table cellSpacing="0" cellPadding="1" border="0">
														<tr>
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;<SPAN class="plus"><asp:label id="lblPageTitle" runat="server" Font-Bold="True"></asp:label></SPAN></td>
														</tr>
													</table>
												</td>
												<td vAlign="top" width="22" bgColor="#d7d7c3" rowSpan="2"><IMG height="21" src="../images/tableheader.gif" width="22"></td>
												<td class="bordercolor" width="100%"><IMG height="18" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td width="100%" bgColor="#d7d7c3"><IMG height="3" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
										</table>
										<!-- END TITLE AND TABLE HEADING TABLE -->
										<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<tr>
												<td class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td width="100%" bgColor="#cccccc">
													<table cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
														<tr>
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE-->
																<table width="100%" border="0" cellspacing="0" cellpadding="5">
																	<tr>
																		<td>
																			<asp:label id="lblScriptName" runat="server" CssClass="plus"></asp:label><br>
																			<br>
																			<asp:label id="lblRespondentInfo" runat="server" CssClass="label"></asp:label><br>
																			<br>
																			<asp:table id="tblScriptStatus" runat="server" BorderWidth="0px" CellSpacing="1" CellPadding="0" Width="100%"></asp:table>
																			<table width="100%" border="0" cellspacing="1" cellpadding="0">
																				<tr>
																					<td colspan="5" align="left"><asp:button id="btnPrevScreen" runat="server" Text="<" ToolTip="Go to previous screen" CssClass="button"></asp:button><a href="#"></a></td>
																					<td colspan="5" align="right"><asp:button id="btnNextScreen" runat="server" Text=">" ToolTip="Go to next screen" CssClass="button"></asp:button><a href="#"></a></td>
																				</tr>
																			</table>
																		</td>
																	</tr>
																</table>
																<!-- END SEARCH FORM AND FIELDS TABLE --></td>
														</tr>
													</table>
												</td>
												<td class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td class="bordercolor" width="100%" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
										</table>
									</td>
								</tr>
							</TABLE>
						</td>
					</tr>
					<tr>
						<td>
							<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
								<tr>
									<td>
										<!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
										<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<tr>
												<td class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td bgColor="#d7d7c3" rowSpan="2">
													<table cellSpacing="0" cellPadding="1" border="0">
														<tr>
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;<asp:label id="lblScreenTitle" runat="server"></asp:label></td>
														</tr>
													</table>
												</td>
												<td vAlign="top" width="22" bgColor="#d7d7c3" rowSpan="2"><IMG height="21" src="../images/tableheader.gif" width="22"></td>
												<td class="bordercolor" width="100%"><IMG height="18" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td width="100%" bgColor="#d7d7c3"><IMG height="3" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td class="bordercolor" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
										</table>
										<!-- END TITLE AND TABLE HEADING TABLE -->
										<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<tr>
												<td class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td width="100%" bgColor="#cccccc">
													<table cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
														<tr>
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE-->
																<P><asp:literal id="ltScreenText" runat="server"></asp:literal></P>
																<P><asp:placeholder id="phAnswerCategories" runat="server"></asp:placeholder></P>
																<!-- END SEARCH FORM AND FIELDS TABLE --></td>
														</tr>
													</table>
												</td>
												<td class="bordercolor" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td class="bordercolor" width="100%" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
										</table>
										<p><asp:linkbutton id="lbExitAndScoreSurvey" runat="server" ToolTip="Exit to respondent details page and score survey for completeness">Exit And Score Survey</asp:linkbutton>&nbsp;
											<asp:LinkButton id="lbExit" runat="server" ToolTip="Exit to respondent details page without scoring survey for completeness">Exit Survey (No Scoring)</asp:LinkButton></p>
									</td>
								</tr>
							</TABLE>
						</td>
					</tr>
				</TABLE>
			</p>
		</form>
		<SCRIPT>
var textfocus = false;
var lastChecked = null;

window.onerror = handleError;

function checkRadio(radio)
{
	if (radio == lastChecked)
	{
		radio.checked = !radio.checked;
		lastChecked = null;
	}
	else
	{
		lastChecked = radio;
	}
}

function handleKeyPress()
{
	var keypressed;
	var numbers = /\d/
	var carriagereturn = /\r/

	keypressed = String.fromCharCode(event.keyCode);
	
	if ((keypressed.match(numbers) != null) && (textfocus == false))
	{
		if (document.Form1.elements["C" + keypressed]) 
		{
			selectControl("C" + keypressed);
		}
		
		if (document.Form1.elements["OA" + keypressed])
		{
			selectControl("OA" + keypressed);
		}
				
		event.returnValue = false;
		return false;
	}
	else if (keypressed.match(carriagereturn) !== null)
	{
		document.Form1.btnNextScreen.click();
		event.returnValue = false;
		return false;
	}
	else
	{
		return true;
	}
}

function selectControl(ctrlname)
{
	switch (document.Form1.elements[ctrlname].type) {
		case "text":
			document.Form1.elements[ctrlname].focus();
			document.Form1.elements[ctrlname].focus();
			break;
		case "radio":
			document.Form1.elements[ctrlname].click();
			document.Form1.elements[ctrlname].focus();
			break;
		case "checkbox":
			document.Form1.elements[ctrlname].click();
			document.Form1.elements[ctrlname].focus();
			break;
	}

	return true;
}

function focusTextBox()
{
	if (textfocus)
	{
		textfocus = false;
	}
	else
	{
		textfocus = true;
	}
	return;
}

function handleError()
{
	return true;
}

function onClickPrev()
{
	document.Form1.submit();
	return false;
}
		</SCRIPT>
	</body>
</HTML>
