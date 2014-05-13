<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="DataSelection.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_DataSelection" %>

<%@ Register Src="../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="UserControls/SideNav.ascx" TagName="SideNav" TagPrefix="uc2" %>
<%@ Register Src="UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<div style="float:left;width:165px;margin-right:5px;"><uc2:SideNav ID="SideNav1" runat="server" ShowSelectionTree="false" ShowToolbox="false" ShowSupportMenu="true" /></div>
<div style="float:left;width:560px;">
    <uc3:BreadCrumbs id="BreadCrumbs1" runat="server" />
    <uc1:PageLogo ID="PageLogo1" runat="server" />
    <div id="PageContents">
        <div id="DateSelection">
            <table>
                <tr>
                    <td style="vertical-align:top;"><asp:Image ID="Step1Image" runat="server" ImageUrl="~/img/stp1_grn.gif" AlternateText="Step 1" /></td>
                    <td><span class="SectionHeader">Date Range Selection</span><br />To begin select a start date and an end date for the time period you are interested in viewing.</td>
                </tr>
            </table>
            <br />
            <table style="margin-left:40px;" cellspacing="10">
                <tr>
                    <td class="InputPrompt">Start Date:</td>
                    <td class="InputField">
                        <asp:DropDownList ID="StartMonth" runat="server">
                        </asp:DropDownList>&nbsp;<asp:DropDownList ID="StartYear" runat="server">
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td class="InputPrompt">End Date:</td>
                    <td class="InputField">
                        <asp:DropDownList ID="EndMonth" runat="server">
                        </asp:DropDownList>&nbsp;<asp:DropDownList ID="EndYear" runat="server">
                        </asp:DropDownList></td>
                </tr>
            </table>
        </div>
        <div id="ServiceTypeSelection" style="margin-top: 10px">
            <table>
                <tr>
                    <td style="vertical-align:top; height: 39px;"><asp:Image ID="Step2Image" runat="server" ImageUrl="~/img/stp2_grn.gif" AlternateText="Step 2"/></td>
                    <td style="height: 39px"><span class="SectionHeader">Service Type Selection</span><br />Select the Service Type from the list below.</td>
                </tr>
            </table>
            <br />
            <div class="InputField" style="margin-left:50px;"><asp:placeholder id="ServiceTypesPlaceHolder" runat="server"></asp:placeholder></div>
        </div>
        <div id="UnitSelection" style="margin-top: 20px">
            <table>
                <tr>
                    <td style="vertical-align:top;"><asp:Image ID="Step3Image" runat="server" ImageUrl="~/img/stp3_grn.gif" AlternateText="Step 3" /></td>
                    <td><span class="SectionHeader">Unit Selection</span><br />Select the unit from the unit selection tree below.<br /></td>
                </tr>
            </table>
            <br />
            <div id="UnitTreeDiv" class="InputField" style="margin-left:50px;">
                <nrc:TreeViewEx ID="UnitTree" runat="server" ExpandDepth="1" NodeIndent="10" ShowCheckBoxes="All">
                    <NodeStyle CssClass="UnitTreeNode" />
                    <HoverNodeStyle CssClass="UnitTreeNodeHover" />
                    <SelectedNodeStyle CssClass="UnitTreeNodeSelected" />
                </nrc:TreeViewEx>
            </div>
        </div>
        <div id="ViewSelection" style="margin-top: 20px">
            <table>
                <tr>
                    <td style="vertical-align:top;"><asp:Image ID="Step4Image" runat="server" ImageUrl="~/img/stp4_grn.gif" AlternateText="Step 4" /></td>
                    <td><span class="SectionHeader">View Selection</span><br />Select which view you would like to use for your questions.<br />Once you have made your selection click the <strong>Next</strong> button.</td>
                </tr>
            </table>
            <br />
            <div id="Div2" class="InputField" style="margin-left:50px;">
                <%--<asp:placeholder id="ViewTypesPlaceHolder" runat="server"></asp:placeholder>--%>
                <asp:RadioButtonList ID="ViewTypeList" runat="server" DataTextField="strDimension_nm" DataValueField="Dimension_id" >
                </asp:RadioButtonList>
            </div>
        </div>
        <br /><br />
        <div style="margin-left:40px;">
            <asp:CustomValidator ID="TreeSelectionValidator" runat="server" Display="Dynamic" EnableClientScript="False"><p>You must select a unit</p></asp:CustomValidator>
            <asp:CustomValidator ID="ViewSelectionValidator" runat="server" Display="Dynamic" EnableClientScript="False"><p>You must select a view</p></asp:CustomValidator>
        </div>
        <div id="LoadingDiv" style="margin-left:40px;display:none; color:#7c7c7c">Loading...</div>
        <div id="NextButtonDiv" style="margin-left:40px;"><asp:Button ID="NextButton" runat="server" Text="Next" CssClass="NextButton" /></div>
    </div>
</div>
    
</asp:Content>
