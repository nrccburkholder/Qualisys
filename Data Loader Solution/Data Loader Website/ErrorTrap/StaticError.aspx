<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="StaticError.aspx.vb" Inherits="NRC.DataLoader._Error" %>
<%@ Register Src="~/UserControls/ucPageLogo.ascx" TagPrefix ="uc" TagName = "PageLogo1" %>
<%@ Register Src="~/UserControls/ucHeader.ascx" TagName="PageHeader1" TagPrefix="uc" %>
<%@ Register Src="~/UserControls/ucFooter.ascx" TagName="PageFooter1" TagPrefix="uc" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>NRC Picker</title>
        <link href="css/Styles.css" rel="stylesheet" type="text/css" />
        	<link href="css/EReports.css" type="text/css" rel="stylesheet" />
      <script src="<%= ResolveClientUrl("~/ErrorTrap/_Scripts/toggle.js") %>" type="text/javascript"></script>
      
</head>
<body>
    <form id="form1" runat="server">
        <table>
            <tr>
            <td style="width: 762px">
                <uc:PageHeader1 ID="PageHeader" runat="server" />
                <br />
            </td>
            </tr>          
        </table>
<table style="width: 762px"><tr><td style="width: 762px">
    <span class="PageTitle" style="width: 762px">Data Loader Support</span>
    <p>This web site is experiencing a temporary problem.  Try using the browser's <strong>back</strong> button 
	or the <strong>Return to Previous Page</strong> link below to choose a different option on that page.</p>
    <p>We apologize for the inconvenience. </p>
    
    <div><img alt="" src="img/BackNav.gif" style="vertical-align:middle;" />
	<a href="Javascript:history.back();">Return to Previous Page</a></div>
    <div id="StackTraceDiv" runat="server" class="StackTracePanel" style="margin-top: 20px;" visible="false">
        <div id="ShowDetailsDiv">
            <a href="javascript:ToggleVisible('StackDetails');ToggleVisible('ShowDetailsDiv');">Show Details</a>
        </div>
        <div id="StackDetails" style="display: none;">
            <asp:Literal ID="StackTraceLiteral" runat="server"></asp:Literal>
        </div>
    
</div>
</td>
</tr>
<tr>
            <td width="100%" colspan="1">
            <uc:PageFooter1 ID="PageFooter1" runat="server"></uc:PageFooter1>
            </td>
</tr>
</table>
    </form>
</body>
</html>
