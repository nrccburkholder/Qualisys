<%@ Page Language="VB" AutoEventWireup ="false" CodeBehind ="SignIn.aspx.vb" Inherits="NRC.DataLoader.SignIn" 
 MasterPageFile ="~/MasterPage.Master" EnableEventValidation ="false"  %>
 <%@ Register TagPrefix="NrcAuth" Namespace="NRC.NRCAuthLib" Assembly="NRC.NRCAuthLib" %>
 <asp:Content ContentPlaceHolderID = "ContentPlaceHolder1" runat =server ID = "Content1">
         <table id="tblFrame" cellspacing="0" cellpadding="0" width="760" border="0">
            <tr>
                <td valign="top" align="center" width="100%">
                    <asp:LoginView ID="LoginView1" runat="server">
                        <AnonymousTemplate>
                            <NrcAuth:LoginControl ID="LoginControl2" runat="server" ApplicationName="Data Loader"
                                BackColor="#f7f6f3" BorderColor="#E6E2D8" BorderStyle="Solid"  BorderWidth="1px" 
                                CreateUserText=" " PasswordRecoveryUrl="/MyAccount/PasswordRecover.aspx" DestinationPageUrl="~/default.aspx"
                                FailureText="Your sign in attempt was not successful. Please try again." ForeColor="#333333"
                                InstructionText="Please enter your user name and password." LoginHelpUrl="/MyAccount/Public/SignInHelp.aspx"
                                NotificationPageUrl="/MyAccount/LoginNotification.aspx" PasswordRecoveryText=" I forgot my password..." SubmitButtonImageUrl="~/img/SignIn.gif"
                                SubmitButtonPosition="Right" SubmitButtonText="Sign In" SubmitButtonType="Image"
                                TitleText="Data Loader Login" Width="250px">
                                <TitleTextStyle Font-Bold="True" ForeColor="#FFFFFF"  BackColor="#318991"></TitleTextStyle>
                                <SubmitButtonStyle BorderStyle="Solid" BorderWidth="1px" ForeColor="#284775" BorderColor="#CCCCCC"
                                    BackColor="#FFFBFF"></SubmitButtonStyle>
                                <FailureTextStyle ForeColor="Red"></FailureTextStyle>
                                <LabelStyle Font-Size="XX-Small" Font-Names="Verdana" Font-Bold="True"></LabelStyle>
                                <HyperLinkStyle Font-Size="XX-Small" ForeColor="#017663"></HyperLinkStyle>
                                <InstructionTextStyle Font-Size="XX-Small" Font-Italic="True"></InstructionTextStyle>
                            </NrcAuth:LoginControl>
                        </AnonymousTemplate>
                    </asp:LoginView>
                </td>  
            </tr>
            <tr>
                <td style="text-align:center"> 
                    <br>
				    <asp:Literal id="ltlVerisign" runat="server"></asp:Literal><br>
				    <asp:Literal id="ltlScanAlert" runat="server"></asp:Literal><br>
				    <br>
                </td>
            </tr>
         </table>
 </asp:Content>
