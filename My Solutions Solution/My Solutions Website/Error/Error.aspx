<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="Error.aspx.vb" Inherits="Nrc.MySolutions.Error_Error" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<div style="float:left;width:730px;">
    <span class="PageTitle">My Solutions Support</span>
    <p>This web site is experiencing a temporary problem.  Try using the browser's <strong>back</strong> button or the <strong>Return to Previous Page</strong> link below to choose a different option on that page.</p>
    <p>We apologize for the inconvenience. </p>
    
    <div><img alt="" src="../img/BackNav.gif" style="vertical-align:middle;" /><a href="Javascript:history.back();">Return to Previous Page</a></div>
    <div id="StackTraceDiv" runat="server" class="StackTracePanel" style="margin-top: 20px;" visible="false">
        <div id="ShowDetailsDiv">
            <a href="javascript:ToggleVisible('StackDetails');ToggleVisible('ShowDetailsDiv');">Show Details</a>
        </div>
        <div id="StackDetails" style="display: none;">
            <asp:Literal ID="StackTraceLiteral" runat="server"></asp:Literal>
        </div>
    </div>
</div>
</asp:Content>
