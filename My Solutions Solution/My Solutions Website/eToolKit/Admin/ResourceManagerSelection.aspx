<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="ResourceManagerSelection.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_Admin_ResourceManagerSelection" ValidateRequest="false" %>

<%@ Register Src="../UserControls/ResultsPerPage.ascx" TagName="ResultsPerPage" TagPrefix="uc2" %>
<%@ Register Src="../../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="../UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>
<%@ Register TagPrefix="FTB" Namespace="FreeTextBoxControls" Assembly="FreeTextBox" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<div style="float:left;width:730px;">
    <uc3:BreadCrumbs id="BreadCrumbs1" runat="server" />
    <uc1:PageLogo ID="PageLogo1" runat="server" Title="Member Resource Manager" />
    <div class="Content" style="font-size: 10px;">
        <asp:Panel ID="PanelSearch" runat="server" DefaultButton="SearchButton">
            <table id="Table1">
                <tr>
                    <td align="right" valign="middle">
                        <asp:Label ID="Label1" runat="server" Text="Enter Search Criteria"></asp:Label>
                    </td>
                    <td align="center" valign="middle">
                        <asp:TextBox ID="SearchTextBox" runat="server"></asp:TextBox>
                    </td>
                    <td align="left" valign="middle">
                        <asp:Button ID="SearchButton" runat="server" Text="Search" />
                    </td>
                </tr>
                <tr>
                    <td align="center" valign="middle">
                    </td> 
                    <td align="center" valign="middle">
                    </td>
                    <td align="center" valign="middle">
                        <asp:LinkButton ID="AddLinkButton" runat="server" CausesValidation="False">Add New Resource</asp:LinkButton></td>
                </tr>
            </table>
        </asp:Panel>
        <asp:GridView ID="ResourceGridView" runat="server" AutoGenerateColumns="False" AllowPaging="True" Width="100%" CellPadding="3" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" DataKeyNames="Id">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="ID" SortExpression="Id">
                </asp:BoundField>
                <asp:ButtonField DataTextField="Title" HeaderText="Name" CommandName="EditSelect" SortExpression="Title">
                    <ItemStyle Width="100%" />
                </asp:ButtonField>
                <asp:BoundField DataField="Author" HeaderText="Author" SortExpression="Author">
                </asp:BoundField>
                <asp:BoundField HeaderText="Type" DataField="ResourceType" SortExpression="ResourceType" />
                <asp:BoundField DataFormatString="{0:d}" HeaderText="Modified" DataField="DateModified" HtmlEncode="False" SortExpression="DateModified" >
                    <ItemStyle HorizontalAlign="Right" />
                </asp:BoundField>
            </Columns>
            <FooterStyle BackColor="White" ForeColor="#000066" />
            <RowStyle ForeColor="#000066" />
            <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
            <HeaderStyle BackColor="#636563" Font-Bold="True" ForeColor="White" CssClass="ModelManagerGridHeader" />
            <EmptyDataRowStyle BorderStyle="None" />
            <EmptyDataTemplate>
                <div style="padding: 30px; text-align: center; background-color: #F9F9F9;">There are no resources for the search text.</div>
            </EmptyDataTemplate>
            <AlternatingRowStyle BackColor="#F7F7F7" />
        </asp:GridView>
        <uc2:ResultsPerPage id="ResultsPerPage1" runat="server">
        </uc2:ResultsPerPage>
    </div>
</div>
</asp:Content>
