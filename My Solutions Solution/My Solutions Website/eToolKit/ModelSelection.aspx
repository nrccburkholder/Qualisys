<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="ModelSelection.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_ModelSelection" EnableEventValidation="false" %>
<%@ Register Src="../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="UserControls/SideNav.ascx" TagName="SideNav" TagPrefix="uc2" %>
<%@ Register Src="UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<div style="float:left;width:165px;margin-right:5px;"><uc2:SideNav ID="SideNav1" runat="server" ShowSelectionTree="true" ShowToolbox="false" ShowSupportMenu="true" /></div>
<div style="float:left;width:560px;">
    <uc3:BreadCrumbs id="BreadCrumbs1" runat="server" />
    <uc1:PageLogo ID="PageLogo1" runat="server" Title="Improvement Model" />
    <div id="PageContents">
        <div id="OrgChartDiv" style="margin-left:30px;"><asp:Literal ID="ltlOrgChart" runat="server"></asp:Literal></div>        
        <br />
        <div id="TipDiv" style="color:#7c7c7c;"><hr /><asp:Label ID="lblTip" runat="server" Text=""></asp:Label></div>
    </div>
</div>
</asp:Content>
