<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="Login.aspx.vb" Inherits="Nrc.MySolutions.Login" title="My Solutions Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<div id="LoginPanel" style="display:none;padding-bottom:5px; position:relative;width: 250px; margin-left: auto; margin-right: auto; margin-top: 150px; margin-bottom:150px; border: Solid 1px Lightgrey">
    <table>
        <tr><td>Username:</td><td><asp:TextBox runat="server" ID="UsernameTextbox"></asp:TextBox></td></tr>
        <tr><td>Password:</td><td><asp:TextBox runat="server" ID="PasswordTextbox" TextMode="Password"></asp:TextBox></td></tr>
    </table>
   
    <div style="float:right;margin-right:10px;"><asp:Button runat="server" ID="LoginButton" Text="Login" /></div>
</div>
<div style="padding-bottom:5px; position:relative;width: 250px; margin-left: auto; margin-right: auto; margin-top: 150px; margin-bottom:150px;">
   <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="1">
        <asp:View ID="LoggedInView" runat="server">You are logged in but you may not have access too all the apps you want...</asp:View>
        <asp:View ID="LoggedOutView" runat="server">
            <asp:Login ID="Login1" runat="server" BackColor="#F7F7DE" BorderColor="#CCCC99" BorderStyle="Solid" BorderWidth="1px" Font-Names="Verdana" Font-Size="10pt">
                <TitleTextStyle BackColor="#6B696B" Font-Bold="True" ForeColor="#FFFFFF" />
            </asp:Login>
        </asp:View>
    </asp:MultiView>
</div>
</asp:Content>
