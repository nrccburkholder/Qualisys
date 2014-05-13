<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="WhatsNew.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_Public_WhatsNew" %>
<%@ Register Src="../../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="../UserControls/SideNav.ascx" TagName="SideNav" TagPrefix="uc2" %>
<%@ Register Src="../UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<div style="float:left;width:165px;margin-right:15px;">
    <nrc:MenuBox ID="HistoryMenu" runat="server"  BackgroundImageUrl="~/img/MenuBox/background.gif" BottomImageUrl="~/img/MenuBox/bottom.gif" BottomLeftImageUrl="~/img/MenuBox/bottomleft.gif" BottomRightImageUrl="~/img/MenuBox/bottomright.gif" LeftImageUrl="~/img/MenuBox/left.gif" RightImageUrl="~/img/MenuBox/right.gif" TopImageUrl="~/img/MenuBox/top.gif" TopLeftImageUrl="~/img/MenuBox/topleft.gif" TopRightImageUrl="~/img/MenuBox/topright.gif" ContentCssClass="MenuBox" MenuItemCssClass="MenuBoxItem" Width="165px">
        <nrc:MenuBoxTitle ID="HistoryTitleItem" runat="server" Text="News Archives" />
    </nrc:MenuBox>
</div>
<div style="float:left;width:550px;">
    <uc3:BreadCrumbs id="BreadCrumbs1" runat="server" />
    <uc1:PageLogo ID="PageLogo1" runat="server" Title="News" />
    <asp:Literal ID="litNews" runat="server"></asp:Literal>
</div>
</asp:Content>
