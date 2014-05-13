<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="QuestionScores.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_QuestionScores" %>
<%@ Register Src="../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="UserControls/SideNav.ascx" TagName="SideNav" TagPrefix="uc2" %>
<%@ Register Src="UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<div style="float:left;width:165px;margin-right:5px;"><uc2:SideNav ID="SideNav1" runat="server" ShowSelectionTree="true" ShowToolbox="true" ShowSupportMenu="true" ShowViewSelection="true" ShowDimensionSelection="true" /></div>
<div style="float:left;width:560px;">
    <uc3:BreadCrumbs id="BreadCrumbs1" runat="server" />
    <uc1:PageLogo ID="PageLogo1" runat="server" Title="Question Results" />
    <div id="PageContents">
    
        <asp:Panel ID="PanelSearch" runat="server" DefaultButton="ButtonSearch">
            <asp:TextBox ID="TextSearch" runat="server" ></asp:TextBox>       
            <asp:Button ID="ButtonSearch" runat="server" Text="Search" />
        </asp:Panel>
        <p>Please enter your search terms in the box above.  If you would like to search for an exact phrase, please enclose that phrase in quotes.</p>
    
        <asp:datagrid id="dgResults" runat="server" ShowHeader="False" AutoGenerateColumns="False" Width="100%" CellPadding="0" AllowSorting="False" AllowPaging="False" BackColor="White" BorderStyle="None" PageSize="20" GridLines="None">
	        <Columns>
		        <asp:TemplateColumn>
			        <ItemTemplate>
				        <table border="0" width="100%" cellpadding="0" cellspacing="0">
					        <tr>
						        <td colspan="4"><img src="../img/ghost.gif" width="8" height="5" alt="" /></td>
					        </tr>
					        <tr>
						        <td valign="top"><%#GetIcon(CType(DataBinder.Eval(Container.DataItem, "Code"), Integer))%></td>
						        <td style="width:100%; vertical-align: top;"><asp:LinkButton ID="LinkButton1" runat="server" CssClass="QuestionLink" OnCommand="LinkButtonClicked" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "QstnCore")%>' ToolTip='<%# CType(DataBinder.Eval(Container.DataItem, "APBLabel"), String).Trim() %>'><%# DataBinder.Eval(Container.DataItem, "strQuestionText")%></asp:LinkButton>
						        </td>
						        <td><img src="../img/ghost.gif" width="5" height="1" alt="" /></td>
						        <td valign="top"><%#BuildChart(CType(DataBinder.Eval(Container.DataItem, "QuestionScore"), Double), CType(DataBinder.Eval(Container.DataItem, "NormScore"), Double), CType(DataBinder.Eval(Container.DataItem, "BenchMarkScore"), Double))%></td>
					        </tr>
					        <tr>
						        <td colspan="4"><img src="../img/ghost.gif" width="8" height="5" alt="" /></td>
					        </tr>
					        <tr>
						        <td colspan="4" style="background-color:#cccccc"><img src="../img/ghost.gif" width="8" height="1" alt="" /></td>
					        </tr>
				        </table>
			        </ItemTemplate>
		        </asp:TemplateColumn>
	        </Columns>
        </asp:datagrid>
        <asp:literal id="ltlResults" runat="server" Visible="False"></asp:literal>
        <asp:Literal id="ltlLegend" runat="server"></asp:Literal>
    </div>
</div>
</asp:Content>
