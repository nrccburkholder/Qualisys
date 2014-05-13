<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ucFooter.ascx.vb" Inherits="NRC.DataLoader.ucFooter1" %>
<table border="0" cellpadding="0" cellspacing="0" width="760">
    <tr>
        <td style="height: 10px" class="nrcDarkGreen">
            <img alt="" border="0" height="10" src="../Img/NrcPicker/ghost.gif" /></td>
    </tr>
    <tr>
        <td align="right" class="nrcDarkGreen">
            <img alt="" border="0" height="8" src="../Img/NrcPicker/ghost.gif" /></td>
    </tr>
    <tr>
        <td>
        </td>
    </tr>
    <tr>
        <td style="height: 5px">
            <img alt="" border="0" height="5" src="../Img/NrcPicker/ghost.gif" />
        </td>
    </tr>
    <tr>
        <td width="100%">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td style="height: 19px">
                        <img hspace="0" src="../Img/NrcPicker/ghost.gif" vspace="0" width="3" />
                    </td>
                    <td align="left" style="height: 19px">
                        <span class="nrcFooterText"><a href="javascript: void window.open('http://www.nrcpicker.com/Pages/PrivacyPolicy.aspx', 'pwin', 'toolbar=false,status=false,scrollbars=1,width=570,height=500,resizable=1')">
                            PRIVACY POLICY</a>
                            </span>
                            </td>
                   <!--< <td align="right" class="nrcFooterText">
						img alt="" src="../Img/footer_arrow.gif" border="0"> <a href="javascript: void newWin('iTandC.aspx', 'pwin', 'toolbar=false,status=false,scrollbars=1,width=570,height=500,resizable=1')">
							TERMS &amp; CONDITIONS</a>
                         </span>
					</td>-->
                    <td align="right" class="nrcFooterText" style="height: 19px">
                        <span class="nrcFooterText">©
                            <asp:Label ID="datCopyRight" runat="server"></asp:Label>
                            NRC PICKER, a Division of National Research Corporation</span>&nbsp;   
                    </td>
                </tr>
                <tr><td colspan = "3" align = "right">
                <span id="UcFooter1_lblVersion" style="color:Gainsboro;font-size:XX-Small;">
                v<asp:label ID = "DataLoaderVersionNumber" runat = "server" >
                </asp:label>
                </span>
                </td></tr>
            </table>
        </td>
    </tr>
    <tr>
        <td width="100%">
            <img alt="" border="0" height="10" src="../Img/NrcPicker/ghost.gif" /></td>
    </tr>
</table>
