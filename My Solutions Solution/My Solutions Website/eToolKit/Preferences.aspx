<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="Preferences.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_Preferences" %>
<%@ Register Src="../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="UserControls/SideNav.ascx" TagName="SideNav" TagPrefix="uc2" %>
<%@ Register Src="UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<div style="float:left;width:165px;margin-right:15px;"><uc2:SideNav ID="SideNav1" runat="server" ShowSelectionTree="false" ShowToolbox="false" ShowSupportMenu="true" /></div>
<div style="float:left;width:550px;">
    <uc3:BreadCrumbs id="BreadCrumbs1" runat="server" />
    <uc1:PageLogo ID="PageLogo1" runat="server" Title="Preferences" />
    <div>
        <p style="font-family: Verdana; font-size: 2;">Select from the choices below to set your user preferences. These preferences will be used to determine what calculations to use when viewing your results. Click on <strong>Save Preferences</strong> button below to save your selection.</p>
        <h5>Choose a comparison Dataset:</h5>
        <asp:RadioButtonList id="rbtCompDatasets" runat="server"></asp:RadioButtonList>
        <h5>Choose an Analysis Variable:</h5>
        <asp:RadioButtonList id="rbtAnalysis" runat="server" DataTextField="Name" DataValueField="Id">
            <asp:ListItem Value="1" Text="Problem Score"></asp:ListItem>
            <asp:ListItem Value="2" Text="Positive Score"></asp:ListItem>
		</asp:RadioButtonList><br />
		<h5>Content Email Notifications:</h5>
        <asp:RadioButtonList ID="rblCENot" runat="server" DataTextField="Label" DataValueField="Id">
        </asp:RadioButtonList>
        <br />
        <br />
		<br />
        <asp:Button ID="SaveButton" runat="server" Text="Save Preferences" CssClass="NextButton" />
    </div>
</div>
</asp:Content>