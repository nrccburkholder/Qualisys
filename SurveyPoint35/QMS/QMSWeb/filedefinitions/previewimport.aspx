<%@ Page Language="vb" AutoEventWireup="false" Codebehind="previewimport.aspx.vb" Inherits="QMSWeb.frmPreviewImport"%>
<%@ Register TagPrefix="uc1" TagName="ucQMSHeader" Src="../includes/ucQMSHeader.ascx" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>SurveyPoint</title>
		<meta content="Microsoft Visual Studio.NET 7.0" name="GENERATOR">
		<meta content="Visual Basic 7.0" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="../Styles.css" type="text/css" rel="stylesheet">
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
		<uc1:ucqmsheader id="UcQMSHeader1" runat="server"></uc1:ucqmsheader>
			<table border="0" cellpadding="0" cellspacing="0" align="center">
			    <tr><td>&nbsp;</td></tr>
			    <tr>
			        <td>
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
								            <td class="pagetitle" noWrap><!-- PAGE TITLE --> &nbsp;Preview Import</td>
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
			        <td class="WritableBG">
			            <asp:label id="lblImportStatus" runat="server"></asp:label>
			        </td>
			    </tr>
			    <tr>
			        <td style="background-color:#f0f0f0">
			        <div style="height:500px;overflow:scroll">
			        <asp:datagrid id="dgPreview" runat="server" width="100%" AllowPaging="True" PageSize="500">					
					<AlternatingItemStyle VerticalAlign="Top"></AlternatingItemStyle>
					<ItemStyle VerticalAlign="Top" />	
					<PagerStyle Position="TopAndBottom" Mode="NumericPages"></PagerStyle>														
				    </asp:datagrid>
				    </div>
				    </td>
			    </tr>
			    <tr>
			        <td class="writablebg">
			            <asp:linkbutton id="lbImport" runat="server" ToolTip="Commits data import">Commit Import</asp:linkbutton>&nbsp;
				        <asp:HyperLink id="hlCancel" runat="server" NavigateUrl="filedefinitions.aspx" ToolTip="Go to file definitions page without committing import">Cancel Import</asp:HyperLink>
			        </td>
			    </tr>
			</table>						
		</form>
	</body>
</HTML>
