<%@ Page Language="vb" AutoEventWireup="false" Codebehind="progress.aspx.vb" Inherits="QMSWeb.frmProgress"%>
<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<%--<asp:literal id="ltRefreshMetaTag" runat="server"></asp:literal>--%><LINK href="../Styles.css" type="text/css" rel="stylesheet">
	    <style type="text/css">
            .style1
            {
                background-color: #f0f0f0;
                width: 18px;
            }
        </style>
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
			<uc1:ucqmsheader id="UcQMSHeader1" runat="server"></uc1:ucqmsheader>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			    <tr><td>&nbsp;<p></p></td></tr>			    
			    <tr>
			        <td align="center">
			            <table cellpadding="0" cellspacing="0" border="0" align="center">
			                <tr>
			                    <td colspan="2">
			                        <!-- THIS TABLE IS THE TITLE AND TABLE HEADING -->
						            <table cellSpacing="0" cellPadding="0" border="0">
							            <tr>
								            <td class="bordercolor" width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
								            <td colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
								            <td width="1" rowSpan="4"><IMG height="1" src="../images/clear.gif" width="1"><IMG height="1" src="../images/clear.gif" width="1"></td>
							            </tr>
							            <tr>
								            <td bgColor="#d7d7c3" rowSpan="2">
									            <table cellSpacing="0" cellPadding="1" border="0">
										            <tr>
											            <td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Progress</td>
										            </tr>
									            </table>
								            </td>
								            <td vAlign="top" width="22" rowSpan="2"><IMG height="21" src="../images/tableheader.gif" width="22"></td>
								            <td width="100%"><IMG height="18" src="../images/clear.gif" width="1"></td>
							            </tr>
							            <tr>
								            <td width="100%" bgColor="#CCCCCC"><IMG height="3" src="../images/clear.gif" width="1"></td>
							            </tr>
							            <tr>
								            <td  bgColor="CCCCCC" colSpan="3"><IMG height="1" src="../images/clear.gif" width="1"></td>
							            </tr>
						            </table>
						            <!-- END TITLE AND TABLE HEADING TABLE -->
			                    </td>
			                </tr>
				            <tr>
					            <td class="style1" valign="top">
						            <P><asp:image id="imgProgress" runat="server" ImageUrl="~/images/ajax-loader.gif" 
                                            Height="37px" Width="50px"></asp:image></P>
					            </td>
					            <td class="WritableBG" align="center">
						            <p><asp:label id="lblFileDefName" runat="server"></asp:label></p>
						            <p><asp:label id="lblJobStatus" runat="server"></asp:label></p>
						            <P>
							            <asp:hyperlink id="hlExit" runat="server" ToolTip="Go to file definitions page and cancel file processing"
								            ImageUrl="../images/qms_cancel_btn.gif"></asp:hyperlink>
							            <asp:HyperLink id="hlDownload" runat="server" Visible="False" ToolTip="Right-click and select Save As to download exported data"
								            ImageUrl="../images/qms_download_btn.gif">Download File</asp:HyperLink></P>
						            <P>
							            <asp:Literal id="ltOpenInExcel" runat="server"></asp:Literal></P>
					            </td>
				            </tr>
			            </table>
			           </td>
			     </tr>
			 </table>
		</form>
	</body>
</HTML>
