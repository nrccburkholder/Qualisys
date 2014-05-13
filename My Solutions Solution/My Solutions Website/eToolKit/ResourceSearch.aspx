<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master"
    Codebehind="ResourceSearch.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_ResourceSearch"
    EnableEventValidation="false" %>

<%@ Register Src="UserControls/ResultsPerPage.ascx" TagName="ResultsPerPage" TagPrefix="uc4" %>

<%@ Register Src="../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="UserControls/SideNav.ascx" TagName="SideNav" TagPrefix="uc2" %>
<%@ Register Src="UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <div style="float: left; width: 165px; margin-right: 5px;">
        <uc2:SideNav ID="SideNav1" runat="server" ShowSelectionTree="false" ShowToolbox="false"
            ShowSupportMenu="true" ShowMemberResources="true" ShowActionPlans="true" />
    </div>
    <div style="float: left; width: 560px;">
        <uc3:BreadCrumbs ID="BreadCrumbs1" runat="server" />
        <uc1:PageLogo ID="PageLogo1" runat="server" Title="Member Resources Search" />
        <div id="PageContents">
            <asp:Panel ID="PanelSearch" runat="server" DefaultButton="ButtonSearch">
                <asp:TextBox ID="TextSearch" runat="server"></asp:TextBox>       
                <asp:Button ID="ButtonSearch" runat="server" Text="Search" />
            </asp:Panel>
            <p>Please enter your search terms in the box above.  If you would like to search for an exact phrase, please enclose that phrase in quotes.</p>
            <asp:GridView style="width: 560px;" ID="MemberResourcesSearchList" runat="server" AllowPaging="True" AutoGenerateColumns="False" GridLines="None" ShowFooter="True" ShowHeader="False">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <table style="width: 560px;">
                                <tr>
                                    <td>
                                        <div class="SectionHeader" style="margin-top: .5em;"><a href='<%# Nrc.MySolutions.ResourceManager.GetMemberResourcePath(Me, Eval("id")) %>' target="_blank"><%#Eval("Title")%></a></div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <strong>Author: <%# Eval("Author") %></strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <!-- "Abstract" description -->
                                        <%#Eval("AbstractHtml")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Repeater ID="Repeater1" runat="server" DataSource='<%# Eval("AllTags") %>'>
                                            <ItemTemplate><asp:LinkButton ID="LinkButton1" runat="server" CommandName="Showtag" CommandArgument='<%# Eval("Description") %>' OnCommand="Repeater1_ItemCommand"><%# Eval("Description") %></asp:LinkButton></ItemTemplate>
                                            <SeparatorTemplate>, </SeparatorTemplate>
                                        </asp:Repeater>
                                    </td>
                                </tr>
                            </table>
                        </ItemTemplate>
                        <ItemStyle Width="560px" />
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div style="padding: 30px; background-color: #F9F9F9;">No search results available.<br />Please try your search again with different criteria.</div>
                </EmptyDataTemplate>
            </asp:GridView>
            <uc4:ResultsPerPage id="ResultsPerPage1" runat="server">
            </uc4:ResultsPerPage>
        </div>
    </div>
</asp:Content>
