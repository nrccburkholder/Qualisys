<%@ Page Language="vb" AutoEventWireup="false" Codebehind="interviewLite.aspx.vb" Inherits="QMSWeb.frmInterviewLite" enableViewState="True"%>
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
		<asp:Literal ID="ltBackground" Runat="server" />
	</HEAD>
	<body onkeypress="handleKeyPress()">
		<form id="Form1" method="post" runat="server">
			<!-- BEGIN HEADER -->
			<table cellSpacing="0" cellPadding="0" width="100%" border="0">
				<tr>
					<td>
						<table cellSpacing="0" cellPadding="0" border="0" width="100%">
							<tr>								
								<td rowspan="2" style="background-color:#cccccc"><img height="39" src="../images/surveytracker_header.gif" width="241" /></td>
								<td style="background-color:#000099" width="100%">
					                <img height="34px" src="../images/clear.gif" width="1" />
					            </td>
							</tr>
							<tr>
							    <td width="100%" style="background-color:#CCCCCC"><img height="4px" src="../images/clear.gif" width="1" /></td>
							</tr>							
						</table>
					</td>					
				</tr>				
			</table>
			<!-- END HEADER -->
			<p>
				<TABLE class="main" align="center" border="0" cellpadding="0">
					<tr>
						<td>
							<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
								<tr>
									<td>
										<!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
										<table cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
											<tr>
												<td class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
											</tr>
											<tr>
												<td bgColor="#d7d7c3" rowSpan="2">
													<table cellSpacing="0" cellPadding="1" border="0">
														<tr>
															<td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;
																<asp:literal id="ltScriptTitle" runat="server"></asp:literal><SPAN class="plus"></SPAN></td>
														</tr>
													</table>
												</td>
												<td vAlign="top" width="22" rowSpan="2"><IMG height="21" src="../images/tableheader.gif" width="22"></td>
												<td width="100%"><IMG height="18" src="../images/clear.gif" width="1"></td>
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
												<td width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td width="100%" class="WritableBG">
													<table cellSpacing="0" cellPadding="10" width="100%" align="center" border="0">
														<tr>
															<td> <!-- SEARCH FORM AND FIELDS GO IN AN INNER TABLE HERE-->
																<table cellSpacing="0" cellPadding="5" width="100%" border="0">
																	<tr>
																		<td colSpan="3">
																			<P><asp:literal id="ltRespondent" runat="server"></asp:literal></P>
																		</td>
																	</tr>
																	<tr>
																		<td align="left"><asp:button id="btnPrev" runat="server" EnableViewState="False" ToolTip="Previous Screen" CausesValidation="False"
																				Text="<" CssClass="button"></asp:button></td>
																		<td align="center"><asp:literal id="ltScreenIndex" runat="server"></asp:literal>
																			<asp:literal id="ltTotalScreenCount" runat="server"></asp:literal></td>
																		<TD align="right"><asp:button id="btnNext" runat="server" EnableViewState="False" ToolTip="Next Screen" CausesValidation="False"
																				Text=">" CssClass="button"></asp:button></TD>
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
												<td  colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
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
												<td vAlign="top" width="22" rowSpan="2"><IMG height="21" src="../images/tableheader.gif" width="22"></td>
												<td width="100%"><IMG height="18" src="../images/clear.gif" width="1"></td>
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
												<td width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
												<td class="WritableBG" width="100%">
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
										<table border="0" cellpadding="0" cellspacing="0" width="100%">
										    <tr>
										        <td class="WritableBG">
										<asp:imagebutton id="ibExitScore" runat="server" EnableViewState="False" ToolTip="Exit interview"
											ImageUrl="../images/qms_score_exit_btn.gif"></asp:imagebutton>
                                        <asp:imagebutton id="ibNoScoreExit" runat="server" ToolTip="Exit interview without scoring completeness"
											ImageUrl="../images/qms_noscore_exit_btn.gif"></asp:imagebutton>
										<p>
                                            <asp:Literal id="ltKeyStrokes" runat="server" EnableViewState="False"></asp:Literal>										    
										</p>
										<p>
											<asp:Literal id="ltScriptStatus" runat="server" EnableViewState="False"></asp:Literal>
											<asp:LinkButton id="lbUpdateStatus" runat="server" EnableViewState="False" ToolTip="Click to view script status summary grid">View Script Status</asp:LinkButton></p>
											    </td>
											   </tr>
										</table>
									</td>
								</tr>
							</TABLE>
						</td>
					</tr>
				</TABLE>
			</p>
			<asp:literal id="ltSoundTag" runat="server" EnableViewState="False"></asp:literal></form>
		<SCRIPT>
		var textfocus = false;
		var lastChecked = null;
		var bSumitted = false;

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
				bSumitted = true;
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
	</body>
</HTML>
