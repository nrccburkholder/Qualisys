<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="ResearchInquiry.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_ResearchInquiry" %>
<%@ Register Src="../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="UserControls/SideNav.ascx" TagName="SideNav" TagPrefix="uc2" %>
<%@ Register Src="UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<div style="float:left;width:165px;margin-right:15px;"><uc2:SideNav ID="SideNav1" runat="server" ShowSelectionTree="false" ShowToolbox="false" ShowSupportMenu="true" /></div>
<div style="float:left;width:550px;">
    <uc3:BreadCrumbs id="BreadCrumbs1" runat="server" />
    <uc1:PageLogo ID="PageLogo1" runat="server" Title="Research Inquiry" />
    <div id="ResearchInquiryDiv" runat="server">
        <div>
            <p>
                Research inquiry is intended to support your improvement
                    efforts by providing you with the ability to submit a custom research
                request that will expand upon the current information and resources provided as part of
                    the program.
                    
                    <p />
                    
                    Please complete the following form to submit your research
                    inquiry. You will be contacted within
                    five working days of your research inquiry submission.
                    
                    <p />
            <br />
            <img id="Step1Image" src="../img/stp1_grn.gif" style="vertical-align:middle; margin-right:5px;" alt="" /><span class="SectionHeader">Your Contact Information</span></p>
            </div>
        <table id="FormTable" cellspacing="1" cellpadding="1" border="0">
            <tr>
                <td class="InputPrompt">First Name:</td>
                <td><asp:TextBox ID="txtFName" runat="server" Width="150px"></asp:TextBox></td>
                <td valign="middle" class="InputPrompt" colspan="2" style="width: 276px">
                    Last Name: &nbsp;&nbsp;
                    <asp:TextBox ID="txtLName" runat="server" Width="168px"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="InputPrompt"></td>
                <td><asp:RequiredFieldValidator ID="vldFname" runat="server" ControlToValidate="txtFName" ErrorMessage="Enter your first name." Display="Dynamic" Width="145px"></asp:RequiredFieldValidator></td>
                <td colspan="2" style="width: 276px">
                    <asp:RequiredFieldValidator ID="vldLname" runat="server" ControlToValidate="txtLName" ErrorMessage="Enter your last name." Display="Dynamic"></asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td class="InputPrompt">Title:</td>
                <td colspan="3"><asp:TextBox ID="txtTitle" runat="server" Width="405px"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="InputPrompt"></td>
                <td colspan="3"><asp:RequiredFieldValidator ID="vldTitle" runat="server" ControlToValidate="txtTitle" ErrorMessage="Enter your title." Display="Dynamic"></asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td class="InputPrompt">Organization:</td>
                <td colspan="3"><asp:TextBox ID="txtOrganization" runat="server" Width="405px"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="InputPrompt">
                </td>
                <td colspan="3">
                    <asp:RequiredFieldValidator ID="vldOrganization" runat="server" ControlToValidate="txtOrganization"
                        Display="Dynamic" ErrorMessage="Enter your organization."></asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td class="InputPrompt" style="height: 18px">
                    Phone:</td>
                <td colspan="3" style="height: 18px">
                    <asp:TextBox ID="txtPhone" runat="server" Width="405px"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="InputPrompt">
                </td>
                <td colspan="3">
                    <asp:RequiredFieldValidator ID="vldPhone" runat="server" ControlToValidate="txtPhone"
                        Display="Dynamic" ErrorMessage="Enter phone number."></asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td class="InputPrompt">Email Address:</td>
                <td colspan="3"><asp:TextBox ID="txtEmail" runat="server" Width="405px"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="InputPrompt"></td>
                <td colspan="3">
                    <asp:RequiredFieldValidator ID="vldEmailAddress" runat="server" ErrorMessage="Enter an email address" ControlToValidate="txtEmail" Display="Dynamic"></asp:RequiredFieldValidator><asp:RegularExpressionValidator ID="vldEmailAddressFormat" runat="server"
                        ControlToValidate="txtEmail" ErrorMessage="Enter a valid email address" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td class="InputPrompt" colspan="4">
                
                <table>
                <tr>
                <td>Preferred Method of Contact:
                </td>
                <td>
                   <asp:RadioButtonList ID="rdbContactMethod" runat="server" RepeatDirection="Horizontal">
                        <asp:ListItem>Phone</asp:ListItem>
                        <asp:ListItem>Email</asp:ListItem>
                    </asp:RadioButtonList>
                    <asp:RequiredFieldValidator ID="vldContactMethod" runat="server" ControlToValidate="rdbContactMethod" ErrorMessage="Select a valid method." Display="Dynamic"></asp:RequiredFieldValidator>
                </td>
                </tr>
                </table>
                
                </td>
            </tr>
        </table>
        <br />
        <div><img id="Img1" src="../img/stp2_grn.gif" style="vertical-align:middle; margin-right:5px;" alt="" /><span class="SectionHeader">Complete
            The Following&nbsp;<br />
        </span></div>
        <table id="Table1" cellspacing="1" cellpadding="1" border="0">
            <tr>
                <td class="InputPrompt" style="height: 34px"> Question Referenced:</td>
                <td colspan="3" style="width: 326px; height: 34px">
                    <asp:DropDownList ID="ddlQuestionReferenced" runat="server" Width="388px">
                        <asp:ListItem>During this hospital stay, how often did the hospital staff do everything they could to help you with your pain? </asp:ListItem>
                    </asp:DropDownList></td>
            </tr>
            <tr>
                <td class="InputPrompt" colspan="4" style="height: 26px">
                    <div runat="server" id="divFullQuestionDisplay" style="display: none; width: 473px; height: 50px; font-weight: bold; color: navy; border-right: black 1px solid; border-top: black 1px solid; border-left: black 1px solid; border-bottom: black 1px solid; background-color: ivory; padding-right: 5px; padding-left: 5px; margin-left: 10px; padding-top: 5px;">
                    </div>
                </td>
            </tr>
            <tr>
                <td class="InputPrompt" colspan="4" style="height: 26px">
                    Problem Statement<br />
                    <span style="font-family: Arial"><span style="font-size: 7pt">Please describe the issue
                        or problem that you have encountered leading to this request.<span style="mso-spacerun: yes">&nbsp;
                        </span>
                        <o:p></o:p>
                    </span></span>
                </td>
            </tr>
            <tr>
                <td valign="top" class="InputPrompt" colspan="4">
                    <asp:TextBox ID="txtProblemStatement" runat="server" Height="300px" TextMode="MultiLine"
                        Width="512px"></asp:TextBox></td>
            </tr>
            <tr>
                <td class="InputPrompt" colspan="4" valign="top">
                </td>
            </tr>
            <tr>
                <td class="InputPrompt" colspan="4" style="height: 14px" valign="top">
                    Background<br />
                    <span style="font-family: Arial"><span style="font-size: 7pt">Please describe the efforts you have taken or are currently taking to address the problem listed above.<span style="mso-spacerun: yes">&nbsp;
                        </span>
                        <o:p></o:p>
                    </span></span>
                </td>
            </tr>
            <tr>
                <td class="InputPrompt" colspan="4" style="height: 14px" valign="top">
                    <span style="font-size: 10pt; font-family: Arial">
                        <asp:TextBox ID="txtBackground" runat="server" Height="300px" TextMode="MultiLine"
                            Width="512px"></asp:TextBox></span></td>
            </tr>
            <tr>
                <td valign="top" class="InputPrompt"></td>
                <td colspan="3" style="width: 326px"><asp:Button ID="SubmitButton" runat="server" Text="Submit Question" CssClass="NextButton"></asp:Button></td>
            </tr>
        </table>
    </div>
    <div id="ConfirmationDiv" runat="server" visible="false">
        <p>
            <span>
                Thank you.&nbsp; We have received your research inquiry submission.&nbsp; You will
                be contacted by our research team within five working days.&nbsp; In the meantime,
                if you have any questions or additional information the research team can be reached
                at 800-388-4264</span></p>
        <p>
<br />
            
        <asp:HyperLink Runat="server" ID="btnReturn"> Finish</asp:HyperLink>
        </p>
    </div>
</div>
</asp:Content>