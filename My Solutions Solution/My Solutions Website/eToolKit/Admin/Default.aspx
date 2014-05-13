<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="Default.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_Admin_Default" %>
<%@ Register Src="../../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="../UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<div style="float:left;width:730px;">
    <uc3:BreadCrumbs id="BreadCrumbs1" runat="server" />
    <uc1:PageLogo ID="PageLogo1" runat="server" Title="Administration" />
    <ul>
        <li><a href="ContentManager.aspx">Home Page Content Manager</a> - Manage eToolKit Home Page content.</li>
        <li><a href="QuestionManager.aspx">Question Manager</a> - Manage eToolKit Questions.</li>
        <li><a href="ThemeManager.aspx">Question/Theme Manager</a> - Manage eToolKit Service Types, Views, and Themes.</li>
        <li><a href="ResourceManagerSelection.aspx">Member Resource Manager</a> - Manage eToolKit Member Resources.</li>
    </ul>
    
</div>
</asp:Content>
