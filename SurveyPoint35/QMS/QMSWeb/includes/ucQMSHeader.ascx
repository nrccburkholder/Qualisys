<%@ Control Language="vb" AutoEventWireup="false" Codebehind="ucQMSHeader.ascx.vb" Inherits="QMSWeb.ucQMSHeader" TargetSchema="http://schemas.microsoft.com/intellisense/ie5" %>
<!-- Begin QMSMenu_CssStyles -->
<style type="text/css">
TABLE.SubMenus { BORDER-RIGHT: #990000 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #990000 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 10px; BACKGROUND: #f0f0f0; PADDING-BOTTOM: 2px; MARGIN: -2px 2px; BORDER-LEFT: #990000 1px solid; PADDING-TOP: 2px; BORDER-BOTTOM: #990000 1px solid; FONT-FAMILY: Arial }
.MenuRollover { BACKGROUND: #99ccff; CURSOR: hand; COLOR: #cc0000 }
</style>
<!-- End QMSMenu_CssStyles -->
<!-- Begin QMS_JavaScript -->
<script language="javascript">
igmenu_QMSMenu_Menu=["QMSMenu",1,1,"","","","",false,"300","100","NotSet","#f0f0f0","5","200","","",false];
igmenu_QMSMenu_Events = [["",0],["",0],["",0],["",0],["",0]];
</script>
<!-- End QMS_JavaScript -->
<asp:Literal id="ltMenuScriptSrc" runat="server"></asp:Literal>
<!-- BEGIN HEADER -->
<table cellSpacing="0" cellPadding="0" width="100%" border="0">
	<tr>
		<td width="241" rowSpan="2">
			<table cellSpacing="0" cellPadding="0" width="241" border="0">
				<tr>
					<td width="1" bgColor="#000099" rowSpan="3"><IMG height="1" src="<%=m_sImagesPath %>/clear.gif" width="1" ></td>
					<td><IMG height="39" src="<%=m_sImagesPath %>/surveytracker_header.gif" width="241"></td>
				</tr>
				<tr>
					<td bgColor="#000099" height="1"><IMG height="1" src="<%=m_sImagesPath %>/clear.gif" width="1"></td>
				</tr>
			</table>
		</td>
		<td bgColor="#000099" style="color:#ffffff;height:18px;text-align:right"><b>&nbsp;&nbsp;<%=CStr(Session("WelcomeText"))%>&nbsp;&nbsp;</b></td>
	</tr>
	<tr>
		<td width="100%">
		    <div style="display:<%=mstrHideMenusStyle %>">
			<table cellSpacing="0" cellPadding="0" width="100%" border="0">
				<tr>
					<td width="100%" background="<%=m_sImagesPath %>/header-bg.gif"><IMG height="22" src="<%=m_sImagesPath %>/clear.gif" width="4"></td>
					<td width="64"><A href="../default.aspx">
							<asp:HyperLink id="hlMenuHome" runat="server" ImageUrl="../images/home-button.gif" BorderWidth="0px"
								Height="22px" Width="64px" NavigateUrl="../default.aspx" EnableViewState="False">Home</asp:HyperLink></A></td>
					<!-- THESE CELLS/BUTTONS CAN BE DISPLAYED OR NOT DEPENDING UPON PERMISSIONS -->
					<td><asp:Literal ID="ltMainMenu" Runat="server"></asp:Literal></td>
					<td width="72">
						<asp:LinkButton id="lbSignOut" runat="server" CausesValidation="False" EnableViewState="False">
							<asp:Image runat="server" Width="72px" AlternateText="Sign Out" ID="imgSignOut" Height="22px"
								ImageUrl="../images/sign-out-button.gif" EnableViewState="False"></asp:Image>
						</asp:LinkButton></td>
				</tr>
			</table>
			</div>
			<%if mstrHideMenusStyle = "none" then %>
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			    <tr>
			        <td bgcolor="#000099" height="18px"><IMG height="18" src="<%=m_sImagesPath %>/clear.gif" /></td>
			    </tr>
			    <tr>
			        <td bgcolor="#c0c0c0" height="3px"><IMG height="3px" src="<%=m_sImagesPath %>/clear.gif" /></td>
			    </tr>
			    <tr>
			        <td bgcolor="#000099" height="1px"><IMG height="1px" src="<%=m_sImagesPath %>/clear.gif" /></td>
			    </tr>
			</table>
			<%end if %>
		</td>
	</tr>
</table>
<!-- Begin QMSMenu_HTML -->
<asp:Literal id="ltSubMenus" runat="server"></asp:Literal>
<input type="hidden" id="QMSMenu" name="QMSMenu">
<script language='javascript'> <!--
	igmenu_initMenu('QMSMenu');
	igmenu_menuState['QMSMenu'].MenuLoaded=true;

--> </script>
<!-- End QMSMenu_HTML -->
<!-- END HEADER -->
