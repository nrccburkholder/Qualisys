<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.Generated.UploadedFileLogView>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Index
</asp:Content>

<asp:Content ID="Content0" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            prettyPrint();

            // $(".abandonded-target").ezpz_tooltip();

            //hide the all of the element with class msg_body
            $(".errorBody").hide();

            //toggle the componenet with class msg_body
            $(".errorHead").click(function () {
                $(this).next(".errorBody").slideToggle(600);
            });

        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 
    <h2>Data Files</h2>

    <% Html.RenderPartial("DateSearch"); %>
    <table>
        <tr>
            <th>
            </th>
            <th>
                Client
            </th>
            <th>
                StudyId
            </th>
            <th>
                SurveyId
            </th>
            <th>
                Transform Name
            </th>            
            <th>
                UFileId
            </th>
            <th>
                DFileId
            </th>
            <th>
                DataFile Name
            </th>
            <th>
                Upload State
            </th>
            <th>
                Datafile State
            </th>
            <th>
                Datafile ModDate
            </th>
        </tr>

    <% foreach (var item in Model) { %>
  
        <tr>
            <td>
                <a href='file://<%: NRC.Picker.Depricated.OCSHHCAHPS.Web.UI.Models.Utils.GetDataFileDirectory(item) %>'>
                    <span id="Span2" style="float:left" class="ui-icon ui-icon-folder-open" ></span>
                </a>
            </td>
            <td>
                <%: string.Format("{0} ({1})", item.ClientName, item.Client_ID) %>
            </td>
            <td>
                <%: item.Study_ID %>
            </td>
            <td>
                <%: item.Survey_ID %>
            </td>
            <td>
                <%: item.PervasiveMapName %>
            </td>
            <td>
                <%: Html.ActionLink(item.UploadFile_id.ToString(), 
                    "../UploadFiles/Details", new { uploadFile_Id = item.UploadFile_id })
                %> 
            </td>
            <td>
                <%: item.DataFile_id %>
            </td>
            <td>
                    <%: item.DataFileName %>
            </td>
            <td>
                <% if (item.UploadFileState_id == (int)NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.UploadState.UploadedAbandoned )
                   { %>
                <div class="errorHead" id='<%: string.Format("abandonded-target-u{0}", item.UploadFile_id) %>'><%: ((NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.UploadState)item.UploadFileState_id).ToString()%></div>
                <div class="errorBody" id='<%: string.Format("abandonded-content-u{0}", item.UploadFile_id) %>'>
                    <ul id="simplelist">
                        <% foreach (var m in item.UploadStateParam.Split(new char[] { '\r', '\n' }).Where(t => t.Length > 0).ToList())
                           { %>
                        <li><%: m %></li>
                        <% } %>
                    </ul>
                </div>
                <%}
                   else
                   { %>
                <%: ((NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.UploadState)item.UploadFileState_id).ToString()%>
                <% } %>
            </td>
            <td>
                <% if (item.DataFileState_id == (int)NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.DataFileState.Abandoned)
                   { %>
                <div class="errorHead" id='<%: string.Format("abandonded-target-d{0}", item.DataFile_id) %>'><%: ((NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.DataFileState)item.DataFileState_id).ToString()%></div>
                <div class="errorBody" id='<%: string.Format("abandonded-content-d{0}", item.DataFile_id) %>' >
                    <ul id="simplelist">
                        <% foreach (var m in item.DataFileStateParam.Split(new char[] { '\r', '\n' }).Where(t => t.Length > 0).ToList())
                           { %>
                        <li><%: m %></li>
                        <% } %>
                    </ul>
                </div>
                <% }
                   else
                   { %>
                <%: ((NRC.Picker.Depricated.OCSHHCAHPS.ImportProcessor.DAL.DataFileState)item.DataFileState_id).ToString()%>
                <% } %>
            </td>
            <td>
                <%: String.Format("{0:g}", item.DatApplied) %>
            </td>
        </tr>
    
    <% } %>

    </table>
</asp:Content>

