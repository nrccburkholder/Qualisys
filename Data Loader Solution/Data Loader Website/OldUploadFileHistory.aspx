<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="UploadFileHistory.aspx.vb" Inherits="NRC.DataLoader.UploadFileHistory" %>

<%@ Register TagPrefix ="uc" TagName = "PageLogo1" Src="~/UserControls/ucPageLogo.ascx" %>
<%@ Register TagPrefix ="uc" TagName ="PageHeader1" Src ="~/UserControls/ucHeader.ascx" %>
<%@ Register TagPrefix ="uc" TagName ="PageFooter1" Src="~/UserControls/ucFooter.ascx"%>
<%@ Register Src="~/UserControls/ucSecurity.ascx" TagName="SecurityControl1" TagPrefix="uc" %>
<%@ Register Assembly="DevExpress.Web.ASPxGridView.v7.3, Version=7.3.10.0, Culture=neutral, PublicKeyToken=9b171c9fd64da1d1"
    Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dxwgv" %>
<%@ Register Assembly="DevExpress.Web.ASPxEditors.v7.3, Version=7.3.10.0, Culture=neutral, PublicKeyToken=9b171c9fd64da1d1"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dxe" %>
<%@ Register Assembly="DevExpress.Web.ASPxGrid.v6.3, Version=6.3.2.0, Culture=neutral, PublicKeyToken=79868b8147b5eae4"
    Namespace="DevExpress.Web.ASPxGrid" TagPrefix="dxwg" %>
<%@ Register Assembly="DevExpress.Web.ASPxDataControls.v6.3, Version=6.3.2.0, Culture=neutral, PublicKeyToken=79868b8147b5eae4"
    Namespace="DevExpress.Web.ASPxDataControls" TagPrefix="dxwdc" %>
<%@ Register Assembly="DevExpress.Web.v7.3, Version=7.3.10.0, Culture=neutral, PublicKeyToken=9b171c9fd64da1d1"
    Namespace="DevExpress.Web.ASPxClasses.ASPxDataWebControl" TagPrefix="dxwda" %>
<%@ Register Assembly="DevExpress.Data.v7.3, Version=7.3.10.0, Culture=neutral, PublicKeyToken=9b171c9fd64da1d1"
    Namespace="DevExpress.Data" TagPrefix="dxwdf" %>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>NRC Data Loader - Upload File History</title>
    <link href="css/Styles.css" rel="stylesheet" type="text/css" />
	<link href="css/EReports.css" type="text/css" rel="stylesheet" />
	<link href="css/FileTypeInfo.css" type="text/css" rel="stylesheet" />
	<script language="javascript" type="text/javascript">
	function swapImg (obj) {
	if (obj.src.indexOf('_on') >= 0){
		obj.src = obj.src.replace('_on','_off');
	}
	else if (obj.src.indexOf('_off') >=0){
		obj.src = obj.src.replace('_off','_on');
	}
}
	
	</script>
</head>
<body>
    <form id="form1" runat="server">
    <table style="width: 762px">
    <tr>
    <td style="width: 763px">
        <uc:PageHeader1 ID="PageHeader" runat="server" />
        <br />
    </td>
    </tr>
    <tr>
    <td style="width: 763px">
    <div>          
        <!--
                <dxwgv:GridViewDataCheckColumn FieldName="IsNew" ReadOnly="True" VisibleIndex="7">
                </dxwgv:GridViewDataCheckColumn>
                <dxwgv:GridViewDataCheckColumn FieldName="IsDeleted" ReadOnly="True" VisibleIndex="8">
                </dxwgv:GridViewDataCheckColumn>
                <dxwgv:GridViewDataCheckColumn FieldName="IsDirty" ReadOnly="True" VisibleIndex="9">
                </dxwgv:GridViewDataCheckColumn>
                <dxwgv:GridViewDataCheckColumn FieldName="IsSavable" ReadOnly="True" VisibleIndex="10">
                </dxwgv:GridViewDataCheckColumn>
                <dxwgv:GridViewDataCheckColumn FieldName="IsValid" ReadOnly="True" VisibleIndex="11">
                </dxwgv:GridViewDataCheckColumn>               
                 <dxwgv:GridViewDataTextColumn FieldName="UploadFilePagesDisplayText" ReadOnly="True"
                    VisibleIndex="5">
                -->
                <div align = "right"><asp:linkbutton runat = "server" ID = "return" Text = "Click Here To Return To Upload Page" style =" text-decoration:underline;color:#318991" /></div>
                <dxwgv:ASPxGridView ID="ASPxGridView1" runat="server" AutoGenerateColumns="False"
             CssFilePath="~/App_Themes/Glass/{0}/styles.css" CssPostfix="Glass" Width="100%" >
            <Settings ShowGroupPanel="True" />
            <Columns>
                <dxwgv:GridViewDataTextColumn FieldName="UploadFile_id" ReadOnly="True" VisibleIndex="0" Caption = "File ID">
                </dxwgv:GridViewDataTextColumn>
                <dxwgv:GridViewDataDateColumn FieldName="datOccurred" VisibleIndex="1" Caption = "Upload Date">
                </dxwgv:GridViewDataDateColumn>
                <dxwgv:GridViewDataTextColumn FieldName="Uploader" VisibleIndex="5" Caption = "Member Name">
                </dxwgv:GridViewDataTextColumn>
                <dxwgv:GridViewDataTextColumn FieldName="UploadAction_nm" VisibleIndex="2" Caption = "File Type">
                </dxwgv:GridViewDataTextColumn>
                <dxwgv:GridViewDataTextColumn FieldName="OrigFile_Nm" VisibleIndex="3" Caption = "File Name">
                </dxwgv:GridViewDataTextColumn>
                <dxwgv:GridViewDataTextColumn FieldName="Packages" VisibleIndex="7" Caption = "Packages/&lt;br /&gt;Measurement &lt;br /&gt;Services  Manager">
                </dxwgv:GridViewDataTextColumn>
                <dxwgv:GridViewDataTextColumn FieldName="UploadState_nm" VisibleIndex="6" Caption = "Upload Status">
                </dxwgv:GridViewDataTextColumn>
                <dxwgv:GridViewDataTextColumn FieldName="UserNotes" VisibleIndex="4" Caption = "Notes" Width = "200px">
                    <CellStyle Wrap="True">
                    </CellStyle>
                </dxwgv:GridViewDataTextColumn>
            </Columns>
            <Images ImageFolder="~/App_Themes/Glass/{0}/">
                <CollapsedButton Height="12px"
                    Width="11px" />
                <DetailCollapsedButton Height="9px"
                    Width="9px" />
                <PopupEditFormWindowClose Height="17px" Width="17px" />
            </Images>
            <Styles CssFilePath="~/App_Themes/Glass/{0}/styles.css" CssPostfix="Glass">
                <Header ImageSpacing="5px" SortingImageSpacing="5px">
                </Header>
            </Styles>
            <SettingsPager NumericButtonCount="100" PageSize="100">
                <AllButton Visible="True">
                </AllButton>
            </SettingsPager>
        </dxwgv:ASPxGridView>
        <div align = "right"><asp:linkbutton runat = "server" ID = "return1" Text = "Click Here To Return To Upload Page" style =" text-decoration:underline;color:#318991;" /></div>
    </div>
     </tr>

    </table>
    
        <div>
    <table>
        <tr>
            <td width="100%" colspan="1">
            <uc:PageFooter1 ID="PageFooter1" runat="server"></uc:PageFooter1>
            </td>
        </tr>
    </table>
    </div>
            <uc:SecurityControl1 ID="SecurityControl1" runat="server"></uc:SecurityControl1>   
    </form>
</body>
</html>
