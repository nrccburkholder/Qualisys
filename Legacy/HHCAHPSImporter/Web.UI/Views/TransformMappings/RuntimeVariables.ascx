<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

    <div class="runtimeVariablesHead"><h3 style="margin-bottom:0px">Runtime Variables</h3></div>
    <div class="runtimeVariablesBody">
        <table>
        <tr>
            <td><b>ContractedLanguages</b></td><td>An array of the contracted languages for the client.</td>
            <td>
<pre class="prettyprint linenums:1 lang-vb">
If ContractedLanguages.Contains("E") Then 
    return "English!" 
End If
</pre>
            </td>
        </tr>
        <tr>
            <td><b>MacroValue</b></td>
            <td>A dictionary containing name/value pairs.<br />
            Valid entries: DATAFILE_ID, ClientId, StudyId, SurveyId</td>
            <td>
<pre class="prettyprint linenums:1 lang-vb">
If MacroValue("ClientId").Equals("123") Then
    return "The client id was 123"
End If
</pre>
            </td>
        </tr>
        <tr>
            <td><b>sourceFieldValue</b></td><td>If the SourceFieldName column is populates, the sourceFieldValue will contain the value from the source field.</td>
            <td>
<pre class="prettyprint linenums:1 lang-vb">
If sourceFieldValue.Equals("test 123") Then 
    return "test 123"
End If
</pre>
            </td>
        </tr>
        <tr>
            <td><b>row</b></td><td>A dictionary containing name/value pairs for each column in the record.</td>
            <td>
<pre class="prettyprint linenums:1 lang-vb">
If row("Patient First Name").Equals("John") Then 
    return "First name is john!"
End If
</pre>
            </td>
        </tr>
        </table>
    </div>