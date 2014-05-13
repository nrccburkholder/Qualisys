<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="ContactUs.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_ContactUs" %>
<%@ Register Src="../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="UserControls/SideNav.ascx" TagName="SideNav" TagPrefix="uc2" %>
<%@ Register Src="UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<div style="float:left;width:165px;margin-right:15px;"><uc2:SideNav ID="SideNav1" runat="server" ShowSelectionTree="false" ShowToolbox="false" ShowSupportMenu="true" /></div>
<div style="float:left;width:550px;">
    <uc3:BreadCrumbs id="BreadCrumbs1" runat="server" />
    <uc1:PageLogo ID="PageLogo1" runat="server" Title="Contact Us" />
    <div id="FeedbackDiv" runat="server">
        <p>Welcome to the NRC+Picker Help and Support page.  Tell us about any wishes for features you would like to see in future versions of our products and any bugs you may find in the software.  We use your feedback to improve our products and services. Your comments, suggestions, and ideas for improvements are very important to us.  We appreciate you taking the time to send us your feedback.</p>
        <h5>Contact NRC+Picker by Phone</h5>
        <p>If you would rather contact NRC+Picker by phone:</p>
        <p>
            Phone: 1-800-388-4264
            <br />
            Fax: 1-402-475-9061
        </p>
        <h5>Contact NRC+Picker Online</h5>
        <p>If you would like to contact NRC+Picker for more information by E-mail, E-mail us at <a href="mailto:TechSupport@NRCPicker.com">TechSupport@NRCPicker.com</a> or you can contact NRC+Picker for more information by completing the following questions.</p>
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="ContactForm" />
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="You must enter an email address" ControlToValidate="txtEmail" ValidationGroup="ContactForm" Display="None" SetFocusOnError="True"></asp:RequiredFieldValidator>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="You must enter your name" ControlToValidate="txtName" ValidationGroup="ContactForm" Display="None" SetFocusOnError="True"></asp:RequiredFieldValidator>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="You must enter your organization" ControlToValidate="txtOrganization" ValidationGroup="ContactForm" Display="None" SetFocusOnError="True"></asp:RequiredFieldValidator>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtDescription"
            Display="None" ErrorMessage="You must enter a description" SetFocusOnError="True"
            ValidationGroup="ContactForm"></asp:RequiredFieldValidator>
        <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="ddlFeature"
            Display="None" ErrorMessage="You must select a feature" Operator="NotEqual" SetFocusOnError="True"
            ValidationGroup="ContactForm" ValueToCompare="-Please Select-"></asp:CompareValidator>
        <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToValidate="ddlType"
            Display="None" ErrorMessage="You must select the type of feedback " Operator="NotEqual"
            SetFocusOnError="True" ValidationGroup="ContactForm" ValueToCompare="-Please Select-"></asp:CompareValidator>
        <table id="ContactForm" cellspacing="1" cellpadding="2" border="0">
            <tr>
                <td class="InputPrompt">E-mail:</td>
                <td class="InputField"><asp:TextBox ID="txtEmail" runat="server" Columns="30"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="InputPrompt">Name:</td>
                <td class="InputField"><asp:TextBox ID="txtName" runat="server" Columns="30"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="InputPrompt">Organization:</td>
                <td class="InputField"><asp:TextBox ID="txtOrganization" runat="server" Columns="50"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="InputPrompt">Feature:</td>
                <td class="InputField">
                    <asp:DropDownList ID="ddlFeature" runat="server">
                        <asp:ListItem Value="-Please Select-">-Please Select-</asp:ListItem>
                        <asp:ListItem Value="Question Results">Question Results</asp:ListItem>
                        <asp:ListItem Value="Question Importance">Question Importance</asp:ListItem>
                        <asp:ListItem Value="Quick Check">Quick Check</asp:ListItem>
                        <asp:ListItem Value="What is Recommended">What is Recommended</asp:ListItem>
                        <asp:ListItem Value="Resources">Resources</asp:ListItem>
                        <asp:ListItem Value="Survey Comments">Survey Comments</asp:ListItem>
                        <asp:ListItem Value="Other">Other</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td class="InputPrompt">Feedback Type:</td>
                <td class="InputField">
                    <asp:DropDownList ID="ddlType" runat="server">
                        <asp:ListItem>-Please Select-</asp:ListItem>
                        <asp:ListItem Value="Bug Report">Bug Report</asp:ListItem>
                        <asp:ListItem Value="Compliment">Compliment</asp:ListItem>
                        <asp:ListItem Value="Feature Request">Feature Request</asp:ListItem>
                        <asp:ListItem Value="Question">Question</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td colspan="2">Please describe your request below. If you are reporting a bug, please include steps to reproduce the issue.</td>
            </tr>
            <tr>
                <td colspan="2"><asp:TextBox ID="txtDescription" runat="server" Columns="65" TextMode="MultiLine" Rows="5"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button ID="SubmitFeedbackButton" runat="server" Text="Submit Feedback" ValidationGroup="ContactForm" />
                </td>                    
            </tr>
        </table>
    </div>
    <div id="ThanksDiv" runat="server" visible="false">Thank you for your feedback.</div>
</div>
</asp:Content>
