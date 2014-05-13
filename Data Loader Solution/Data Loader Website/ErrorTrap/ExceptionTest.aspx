<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ExceptionTest.aspx.vb" Inherits="NRC.DataLoader.ExceptionTest" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    Enter error and click throw to test <br />
    <asp:TextBox runat = "server" ID = "ErrorToSend" /> <br />
    <asp:button text = "Throw" runat = "server" ID = "thrower" />
    </div>
    </form>
</body>
</html>
