<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ResultsPerPage.ascx.vb" Inherits="Nrc.MySolutions.ResultsPerPage" %>
<strong>Results Per Page: </strong>
<asp:DropDownList ID="ComboPageSize" runat="server" AutoPostBack="True">
    <asp:ListItem Selected="True">10</asp:ListItem>
    <asp:ListItem>15</asp:ListItem>
    <asp:ListItem>30</asp:ListItem>
    <asp:ListItem>50</asp:ListItem>
    <asp:ListItem Value="-1">All</asp:ListItem>
</asp:DropDownList>
