<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master"
    Codebehind="QuestionSelection.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_QuestionSelection"
    EnableEventValidation="false" %>

<%@ Register Src="UserControls/ResultsPerPage.ascx" TagName="ResultsPerPage" TagPrefix="uc4" %>

<%@ Register Src="../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="UserControls/SideNav.ascx" TagName="SideNav" TagPrefix="uc2" %>
<%@ Register Src="UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <div style="float: left; width: 165px; margin-right: 5px;">
        <uc2:SideNav ID="SideNav1" runat="server" ShowSelectionTree="true" ShowToolbox="false" 
            ShowSupportMenu="true" ShowMemberResources="true" ShowActionPlans="true"  ShowViewSelection="true" />
    </div>
    <div style="float: left; width: 560px;">
        <uc3:BreadCrumbs ID="BreadCrumbs1" runat="server" />
        <uc1:PageLogo ID="PageLogo1" runat="server" Title="Question Search" />
        <div id="PageContents">
        
            <asp:Panel ID="PanelSearch" runat="server" DefaultButton="ButtonSearch">
                <asp:TextBox ID="TextSearch" runat="server" ></asp:TextBox>       
                <asp:Button ID="ButtonSearch" runat="server" Text="Search" />
                    </asp:Panel>
            <p>Please enter your search terms in the box above.  If you would like to search for an exact phrase, please enclose that phrase in quotes.</p>
                    
            <asp:GridView id="QuestionSelectionList" runat="server" ShowHeader="False" AutoGenerateColumns="False" Width="100%" CellPadding="0" AllowSorting="False" AllowPaging="true" PageSize="10" BackColor="White" BorderStyle="None" GridLines="None">
	            <Columns>
		            <asp:TemplateField>
			            <ItemTemplate>
				            <table border="0" width="100%" cellpadding="0" cellspacing="0">
					            <tr>
						            <td colspan="4"><img src="../img/ghost.gif" width="8" height="5" alt="" /></td>
					            </tr>
					            <tr>
						            <td valign="top"><%#GetIcon(CType(Eval("Code"), Integer))%></td>
						            <td style="width:100%; vertical-align: top;"><asp:LinkButton ID="LinkButton1" runat="server" CssClass="QuestionLink" OnCommand="LinkButtonClicked" 
						            CommandArgument='<%# String.Format("{0}|{1}|{2}", Eval("Dimension_id"), Eval("strDimension_nm"), Eval("QstnCore"))%>' 
						            ToolTip='<%# CType(Eval("APBLabel"), String).Trim() %>'><%#Eval("strQuestionText")%></asp:LinkButton>
						            </td>
						            <td><img src="../img/ghost.gif" width="5" height="1" alt="" /></td>
						            <td valign="top"><%#BuildChart(CType(Eval("QuestionScore"), Double), CType(Eval("NormScore"), Double), CType(Eval("BenchMarkScore"), Double))%></td>
					            </tr>
					            <tr>
						            <td colspan="4"><img src="../img/ghost.gif" width="8" height="5" alt="" /></td>
					            </tr>
					            <tr>
						            <td colspan="4" style="background-color:#cccccc"><img src="../img/ghost.gif" width="8" height="1" alt="" /></td>
					            </tr>
				            </table>
			            </ItemTemplate>
		            </asp:TemplateField>
	            </Columns>
                <EmptyDataTemplate>
                    <div style="padding: 30px; background-color: #F9F9F9;">No search results available.<br />Please try your search again with different criteria.</div>
                </EmptyDataTemplate>
            </asp:GridView>
            <uc4:ResultsPerPage id="ResultsPerPage1" runat="server">
            </uc4:ResultsPerPage>
            <asp:Literal id="ltlLegend" runat="server"></asp:Literal>
        </div>
    </div>
</asp:Content>
