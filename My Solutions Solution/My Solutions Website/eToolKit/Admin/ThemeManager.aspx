<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/NrcPicker.master" CodeBehind="ThemeManager.aspx.vb" Inherits="Nrc.MySolutions.eToolKit_Admin_ThemeManager" %>
<%@ Register Src="../UserControls/ServiceTypeEditor.ascx" TagName="ServiceTypeEditor" TagPrefix="uc6" %>
<%@ Register Src="../UserControls/ViewEditor.ascx" TagName="ViewEditor" TagPrefix="uc5" %>
<%@ Register Src="../UserControls/ThemeEditor.ascx" TagName="ThemeEditor" TagPrefix="uc4" %>
<%@ Register Src="../UserControls/ThemeQuestionEditor.ascx" TagName="ThemeQuestionEditor" TagPrefix="uc2" %>
<%@ Register Src="../../UserControls/BreadCrumbs.ascx" TagName="BreadCrumbs" TagPrefix="uc3" %>
<%@ Register Src="../UserControls/PageLogo.ascx" TagName="PageLogo" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
<script type="text/javascript">
    function ChangeCheckBoxState(id, checkState)
    {
        var cb = document.getElementById(id);
        if (cb != null && cb.disabled == false){
            cb.checked = checkState;
        }
    }

    function ChangeAllCheckBoxStates(arrayList, checkState)
    {
        // Toggles through all of the checkboxes defined in the CheckBoxIDs array
        // and updates their value to the checkState input parameter
        if (arrayList != null)
        {
            for (var i = 0; i < arrayList.length; i++)
                ChangeCheckBoxState(arrayList[i], checkState);
        }
    }
</script>
<uc3:BreadCrumbs id="BreadCrumbs1" runat="server" />
<uc1:PageLogo ID="PageLogo1" runat="server" Title="Question/Theme Manager" />
<div style="float:left;width:200px;margin-right:5px;">
    <nrc:MenuBox ID="TreeMenu" runat="server" BackgroundImageUrl="~/img/MenuBox/background.gif" BottomImageUrl="~/img/MenuBox/bottom.gif" BottomLeftImageUrl="~/img/MenuBox/bottomleft.gif" BottomRightImageUrl="~/img/MenuBox/bottomright.gif" LeftImageUrl="~/img/MenuBox/left.gif" RightImageUrl="~/img/MenuBox/right.gif" TopImageUrl="~/img/MenuBox/top.gif" TopLeftImageUrl="~/img/MenuBox/topleft.gif" TopRightImageUrl="~/img/MenuBox/topright.gif" ContentCssClass="MenuBox" MenuItemCssClass="MenuBoxItem">
        <asp:TreeView ID="ModelTreeView" runat="server" ExpandDepth="1" NodeIndent="5" Width="165px" OnSelectedNodeChanged="ModelTreeView_SelectedNodeChanged">
            <ParentNodeStyle Font-Bold="False" />
            <SelectedNodeStyle CssClass="ModelManagerNodeSelected" />
            <NodeStyle CssClass="ModelManagerNode" />
            <Nodes>
                <asp:TreeNode Text="Inpatient Med/Surg" Value="Inpatient" ToolTip="Inpatient Med/Surg">
                    <asp:TreeNode Text="Department View" Value="Department View" ToolTip="Department View">
                        <asp:TreeNode Text="Nursing" Value="Nursing" ToolTip="Nursing"></asp:TreeNode>
                        <asp:TreeNode Text="Admissions" Value="Admissions" ToolTip="Admissions"></asp:TreeNode>
                        <asp:TreeNode Text="Doctors" Value="Doctors" ToolTip="Doctors"></asp:TreeNode>
                        <asp:TreeNode Text="Emergency" Value="Emergency" ToolTip="Emergency"></asp:TreeNode>
                    </asp:TreeNode>
                    <asp:TreeNode Text="Dimension View" Value="Dimension View" ToolTip="Dimension View">
                        <asp:TreeNode Text="Coordination of Care" Value="Coordination of Care" ToolTip="Coordination of Care"></asp:TreeNode>
                        <asp:TreeNode Text="Continuity and Transition" Value="Continuity and Transition" ToolTip="Continuity and Transition"></asp:TreeNode>
                        <asp:TreeNode Text="Information and Education" Value="Information and Education" ToolTip="Information and Education"></asp:TreeNode>
                        <asp:TreeNode Text="Respect for Patients" Value="Respect for Patients" ToolTip="Respect for Patients"></asp:TreeNode>
                    </asp:TreeNode>
                    <asp:TreeNode Text="HCAHPS Composite View" Value="HCAHPS Composite View" ToolTip="HCAHPS Composite View">
                        <asp:TreeNode Text="Cleanliness/Quiet of Environment" Value="Cleanliness/Quiet of Environment" ToolTip="Cleanliness/Quiet of Environment">
                        </asp:TreeNode>
                        <asp:TreeNode Text="Communication about medicine" Value="Communication about medicine" ToolTip="Communication about medicine">
                        </asp:TreeNode>
                        <asp:TreeNode Text="Communication with Doctors" Value="Communication with Doctors" ToolTip="Communication with Doctors"></asp:TreeNode>
                        <asp:TreeNode Text="Communication with Nurses" Value="Communication with Nurses" ToolTip="Communication with Nurses"></asp:TreeNode>
                    </asp:TreeNode>
                </asp:TreeNode>
                <asp:TreeNode Text="Inpatient OB" Value="Inpatient OB" ToolTip="Inpatient OB">
                    <asp:TreeNode Text="Department View" Value="Department View" ToolTip="Department View"></asp:TreeNode>
                    <asp:TreeNode Text="Dimension View" Value="Dimension View" ToolTip="Dimension View"></asp:TreeNode>
                </asp:TreeNode>
                <asp:TreeNode Text="Pediatrics" Value="Pediatrics" ToolTip="Pediatrics">
                    <asp:TreeNode Text="Department View" Value="Department View" ToolTip="Department View"></asp:TreeNode>
                    <asp:TreeNode Text="Dimension View" Value="Dimension View" ToolTip="Dimension View"></asp:TreeNode>
                </asp:TreeNode>
            </Nodes>
        </asp:TreeView>
    </nrc:MenuBox>
</div>
<div style="float:left;width:525px; font-size: 10px;">
    <uc6:ServiceTypeEditor id="ServiceTypeEditor1" runat="server" />
    <uc5:ViewEditor ID="ViewEditor1" runat="server" Visible="false" />
    <uc4:ThemeEditor ID="ThemeEditor1" runat="server" Visible="false"/>
    <uc2:ThemeQuestionEditor ID="ThemeQuestionEditor1" runat="server" Visible="false" />
</div>
</asp:Content>
