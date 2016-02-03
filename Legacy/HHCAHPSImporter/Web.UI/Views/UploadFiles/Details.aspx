<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<HHCAHPSImporter.ImportProcessor.DAL.Generated.UploadedFileLogView>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Details
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Details</h2>

    <fieldset>
        <legend>Fields</legend>
        
        <table>
            <tr>
                <td>UploadFile_id</td><td><%: Model.UploadFile_id %></td>
            </tr>
            <tr>
                <td>UploadState</td><td><%: ((HHCAHPSImporter.ImportProcessor.DAL.UploadState)Model.UploadFileState_id).ToString()%></td>
            </tr>
            <tr>
                <td>OrigFile_Nm</td><td><%: Model.OrigFile_Nm %></td>
            </tr>
            <tr>
                <td>File_Nm</td><td><%: Model.File_Nm %></td>
            </tr>
            <tr>
                <td>FileSize</td><td><%: Model.FileSize %></td>
            </tr>
            <tr>
                <td>UploadAction_id</td><td><%: ((HHCAHPSImporter.ImportProcessor.DAL.UploadAction)Model.UploadAction_id).ToString() %></td>
            </tr>
            <tr>
                <td>Mod Date</td>
                <td>
                    <%: String.Format("{0:g}", Model.DateUploadFileStateChange) %>
                </td>
            </tr>
        </table>
        
    </fieldset>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

