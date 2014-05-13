<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="Default.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_Help_Default" %>
<%@ Register Src="../../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="../UserControls/SideNav.ascx" TagName="SideNav" TagPrefix="uc2" %>
<%@ Register Src="../UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<div style="float:left;width:165px;margin-right:5px;"><uc2:SideNav ID="SideNav1" runat="server" ShowSelectionTree="false" ShowToolbox="false" ShowSupportMenu="true" ShowControlChartGuide="true" /></div>
<div style="float:left;width:560px;">
    <uc3:BreadCrumbs id="BreadCrumbs1" runat="server" />
    <uc1:PageLogo ID="PageLogo1" runat="server" Title="Help" />
    <div>
        <table id="tblContent" cellspacing="2" cellpadding="3" width="100%" border="0">
            <tr>
                <td colspan="2" valign="top">Nearly all Internet-based reporting systems can display data. Some also provide 
				        interactive access to results. However,&nbsp;NRC+Picker's newest innovation, 
				        the eToolKit, is a unique, web-based program specifically designed to help 
				        caregivers improve patient experiences of care, as well as their survey 
				        results.
                </td>
            </tr>
            <tr>
                <td>
                    <br />
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td valign="top">
                    Accessible by any web browser, the eToolKit allows users to drill into the results by service line to 
			        department and unit levels. This level of specificity is essential for service 
			        quality improvement.
                </td>
                <td valign="top">
                    <img alt="" src="../img/ScreenShot1.jpg" /></td>
            </tr>
            <tr>
                <td>
                    <br />
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top">
                        The program begins by providing an overview of the results for each of 
				        the Picker Institute's Eight Dimensions of Patient-Centered 
				        Care.  Intuitive point and click navigation displays each question, the 
				        score and selected benchmarks.
                </td>
            </tr>
            <tr>
                <td>
                    <br />
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td valign="top">
                        By "clicking" on a question, the program provides background information and explains why it is 
				        important. This module is intended to educate the staff regarding service 
				        issues "through the eyes" of patients and their families.
                </td>
                <td valign="top">
                    <img alt="" src="../img/ScreenShot2.jpg" /></td>
            </tr>
            <tr>
                <td valign="top">
                    <br />
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td valign="top">
                        By selecting "Quick Check" from the menu, employees are provided a list of specific behaviors that 
				        are often leading indicators of low and high scores. These "checks" can readily 
				        identify actions that will lead to immediate improvement in scores and service 
				        pitfalls to avoid.
                </td>
                <td valign="top">
                    <img alt="" src="../img/ScreenShot3.jpg" /></td>
            </tr>
            <tr>
                <td>
                    <br/>
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td valign="top">
                        By selecting "What is Recommended?" staff is provided a list of best demonstrated practices that 
				        can be used to improve the scores for the selected question. These 
				        recommendations have been developed over a period of 10 years by clients 
				        using NRC+Picker family of surveys.
                </td>
                <td valign="top">
                    <img alt="" src="../img/ScreenShot4.jpg" /></td>
            </tr>
            <tr>
                <td>
                    <br/>
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td valign="top">
                        And for greater comprehension and improvement, information regarding additional resources is 
				        provided. These are ideal sources for departments or units that wish to develop 
				        focused service quality improvement programs and ensure their scores are 
				        sustained or improved.
                </td>
                <td valign="top">
                    <img alt="" src="../img/ScreenShot5.jpg" /></td>
            </tr>
            <tr>
                <td>
                    <br/>
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td colspan="2" valign="top">
                    In summary, the eToolKit provides the following benefits:
                    <ul>
                        <li>Ease of use; </li>
                        <li>Accessible with Internet Explorer 5.5 and Netscape 6.2 or greater web browser; </li>
                        <li>Educates staff about service quality issues important to the patient and their family; </li>
                        <li>Indicates the behaviors that are the leading causes of low and high scores; </li>
                        <li>Offers best demonstrated practices for improving the patients' experiences of care; and </li>
                        <li>Provides educational resources for sustained improvement.</li>
                    </ul>
                </td>
            </tr>
        </table>
    </div>
</div>
</asp:Content>
