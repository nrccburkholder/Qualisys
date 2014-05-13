<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="MoviePlayer.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_Movies_MoviePlayer" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
    <object id="MediaPlayer" width="736" height="500" classid="CLSID:22D6F312-B0F6-11D0-94AB-0080C74C7E95"
        standby="Loading Windows Media Player components..." type="application/x-oleobject">
        <param name="FileName" value="<%= MoviePath() %>" />
        <param name="autostart" value="true" />
        <param name="ShowControls" value="true" />
        <param name="ShowStatusBar" value="false" />
        <param name="ShowDisplay" value="false" />
        <embed type="application/x-mplayer2" src="<%= MoviePath() %>" name="MediaPlayer"
            width="756" height="500" showcontrols="1" showstatusbar="0" showdisplay="0" autostart="1"></embed>
    </object>
</asp:Content>
