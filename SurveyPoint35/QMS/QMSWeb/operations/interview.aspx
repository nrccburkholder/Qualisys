<%@ Page Language="vb" AutoEventWireup="false" Codebehind="interview.aspx.vb" Inherits="QMSWeb.frmInterview" enableViewState="True"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<style type="text/css">.script_status_hl { FONT-SIZE: 8pt; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none }
		</style>
		<LINK href="../Styles.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body onkeypress="handleKeyPress()">
		<form id="Form1" method="post" runat="server">
			<!-- BEGIN HEADER -->
			<table cellSpacing="0" cellPadding="0" width="100%" border="0">
				<tr>
					<td width="241" rowSpan="2">
						<table cellSpacing="0" cellPadding="0" width="241" border="0">
							<tr>
								<td width="1" bgColor="#990000" rowSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
								<td><IMG height="39" src="../images/surveypoint_header.gif" width="241"></td>
							</tr>
							<tr>
								<td bgColor="#990000" height="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
							</tr>
						</table>
					</td>
					<td bgColor="#990000"><IMG height="18" src="../images/clear.gif" width="1"></td>
				</tr>
				<tr>
					<td width="100%">
						<table cellSpacing="0" cellPadding="0" width="100%" border="0">
							<tr>
								<td width="100%" background="../images/header-bg.gif"><IMG height="22" src="../images/clear.gif" width="4"></td>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;
																<asp:literal id="ltScriptTitle" runat="server" EnableViewState="False"></asp:literal><SPAN class="plus"></SPAN></td>
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
																<table cellSpacing="0" cellPadding="5" width="100%" border="0">
																	<tr>
																		<td colSpan="2">
																			<P><asp:literal id="ltRespondent" runat="server" EnableViewState="False"></asp:literal></P>
																			<P><asp:literal id="ltSummaryTable" runat="server" EnableViewState="False"></asp:literal></P>
																		</td>
																	</tr>
																	<tr>
																		<td align="left">
																			<asp:Button id="btnPrev" runat="server" CssClass="button" Text="<" EnableViewState="False" CausesValidation="False"
																				ToolTip="Previous Screen"></asp:Button></td>
																		<td align="right">
																			<asp:Button id="btnNext" runat="server" Text=">" CssClass="button" EnableViewState="False" CausesValidation="False"
																				ToolTip="Next Screen"></asp:Button></td>
																	</tr>
																</table>
																<!-- END SEARCH FORM AND FIELDS TABLE --></td>
														</tr>
													</table>
												</td>
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
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;
																<asp:literal id="ltScreenTitle" runat="server" EnableViewState="False"></asp:literal></td>
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
																<P><asp:literal id="ltScreenText" runat="server" EnableViewState="False"></asp:literal></P>
																<p><asp:literal id="ltCategoryText" runat="server" EnableViewState="False"></asp:literal></p>
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
										<asp:imagebutton id="ibExitScore" runat="server" EnableViewState="False" ImageUrl="../images/qms_score_exit_btn.gif"
											ToolTip="Score completeness &amp; exit interview"></asp:imagebutton><asp:imagebutton id="ibNoScoreExit" runat="server" EnableViewState="False" ImageUrl="../images/qms_noscore_exit_btn.gif"
											ToolTip="Exit interview without scoring completeness"></asp:imagebutton></td>
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
		document.Form1.btnNext.focus();
		
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
			var validinput = /[A-C\d]/

			keypressed = String.fromCharCode(event.keyCode).toUpperCase();
			
			if ((keypressed.match(validinput) != null) && (textfocus == false))
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
				document.Form1.btnNext.click();
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
		<asp:Literal id="ltSoundTag" runat="server" EnableViewState="False"></asp:Literal>
	</body>
</HTML>
