Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel

Friend Class ExportScriptSelectedProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.ExportScriptSelectedProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property

#Region " TEMP_SPU_GetSelectedScript Procs "
    Public Overrides Function GetScriptByScriptID(ByVal scriptID As Integer) As ExportScriptSelected
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSelectedScriptByScriptID, scriptID)
        Dim newScript As ExportScriptSelected = Nothing
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            While rdr.Read
                newScript = PopulateExportScriptSelectedWithEmptyExtensions(rdr)
            End While
        End Using
        Return newScript
    End Function
    Public Overrides Function SelectSelectedExportScripts(ByVal group As ExportGroup, ByVal survey As ExportSurvey) As ExportScriptSelectedCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectSelectedScripts, group.ExportGroupID, survey.SurveyID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportScriptSelectedCollection, ExportScriptSelected)(rdr, AddressOf PopulateExportScriptSelected)
        End Using
    End Function
    Public Overrides Sub InsertScript(ByVal script As ExportScriptSelected, ByVal surveyID As Integer, ByVal exportGroupID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertScriptExtension, script.ScriptID, _
            exportGroupID, surveyID, script.MiscChar1, script.MiscChar1Name, script.MiscChar2, _
            script.MiscChar2Name, script.MiscChar3, script.MiscChar3Name, script.MiscChar4, _
            script.MiscChar4Name, script.MiscChar5, script.MiscChar5Name, script.MiscChar6, _
            script.MiscChar6Name, script.MiscNum1, script.MiscNum1Name, script.MiscNum2, _
            script.MiscNum2Name, script.MiscNum3, script.MiscNum3Name, script.MiscDate1, _
            script.MiscDate1Name, script.MiscDate2, script.MiscDate2Name, script.MiscDate3, _
            script.MiscDate3Name)
        ExecuteNonQuery(cmd)
    End Sub
    Private Function PopulateExportScriptSelectedWithEmptyExtensions(ByVal rdr As SafeDataReader) As ExportScriptSelected
        Dim newObject As ExportScriptSelected = ExportScriptSelected.NewExportScriptSelected
        Dim privateInterface As IExportScriptSelected = newObject
        newObject.BeginPopulate()
        privateInterface.ScriptID = rdr.GetInteger("ScriptID")
        newObject.SurveyID = rdr.GetInteger("SurveyID")
        newObject.ScriptTypeID = rdr.GetInteger("ScriptTypeID")
        newObject.Name = rdr.GetString("Name")
        newObject.Description = rdr.GetString("Name")
        newObject.CompletenessLevel = rdr.GetDecimal("CompletenessLevel")
        newObject.FollowSkips = CBool(rdr.GetByte("FollowSkips"))
        newObject.CalcCompleteness = CBool(rdr.GetByte("CalcCompleteness"))
        newObject.DefaultScript = CBool(rdr.GetByte("DefaultScript"))
        'newObject.ScriptExtensionID = rdr.GetInteger("ScriptExtensionID")
        'TODO:  Send in.
        'newObject.ExportGroupID = rdr.GetInteger("ExportGroupID")
        newObject.MiscChar1 = String.Empty
        'TODO DB fix
        newObject.MiscChar1Name = "" 'rdr.GetString("MiscChar1Name")
        newObject.MiscChar2 = String.Empty
        newObject.MiscChar2Name = String.Empty
        newObject.MiscChar3 = String.Empty
        'TODO DB fix
        newObject.MiscChar3Name = "" 'rdr.GetString("MiscChar3Name")
        newObject.MiscChar4 = String.Empty
        'TODO DB fix
        newObject.MiscChar4Name = "" 'rdr.GetString("MiscChar4Name")
        newObject.MiscChar5 = String.Empty
        newObject.MiscChar5Name = String.Empty
        newObject.MiscChar6 = String.Empty
        'TODO DB fix
        newObject.MiscChar6Name = "" 'rdr.GetString("MiscChar6Name")
        newObject.MiscDate1 = Nothing
        newObject.MiscDate1Name = String.Empty
        newObject.MiscDate2 = Nothing
        newObject.MiscDate2Name = String.Empty
        newObject.MiscDate3 = Nothing
        newObject.MiscDate3Name = String.Empty
        newObject.MiscNum1 = Nothing
        newObject.MiscNum1Name = String.Empty
        newObject.MiscNum2 = Nothing
        newObject.MiscNum2Name = String.Empty
        newObject.MiscNum3 = Nothing
        newObject.MiscNum3Name = String.Empty
        newObject.ExportScriptExtensionCollection = PopulateExportScriptExtensionCollection(newObject)
        Return newObject
    End Function
    Private Function PopulateExportScriptSelected(ByVal rdr As SafeDataReader) As ExportScriptSelected
        Dim newObject As ExportScriptSelected = ExportScriptSelected.NewExportScriptSelected
        Dim privateInterface As IExportScriptSelected = newObject
        newObject.BeginPopulate()
        privateInterface.ScriptID = rdr.GetInteger("ScriptID")
        newObject.SurveyID = rdr.GetInteger("SurveyID")
        newObject.ScriptTypeID = rdr.GetInteger("ScriptTypeID")
        newObject.Name = rdr.GetString("Name")
        newObject.Description = rdr.GetString("Name")
        newObject.CompletenessLevel = rdr.GetDecimal("CompletenessLevel")
        newObject.FollowSkips = CBool(rdr.GetByte("FollowSkips"))
        newObject.CalcCompleteness = CBool(rdr.GetByte("CalcCompleteness"))
        newObject.DefaultScript = CBool(rdr.GetByte("DefaultScript"))
        newObject.ScriptExtensionID = rdr.GetInteger("ScriptExtensionID")
        newObject.ExportGroupID = rdr.GetInteger("ExportGroupID")
        newObject.MiscChar1 = rdr.GetString("MiscChar1")
        'TODO DB fix
        newObject.MiscChar1Name = rdr.GetString("MiscChar1Name")
        newObject.MiscChar2 = rdr.GetString("MiscChar2")
        newObject.MiscChar2Name = rdr.GetString("MiscChar2Name")
        newObject.MiscChar3 = rdr.GetString("MiscChar3")
        'TODO DB fix
        newObject.MiscChar3Name = rdr.GetString("MiscChar3Name")
        newObject.MiscChar4 = rdr.GetString("MiscChar4")
        'TODO DB fix
        newObject.MiscChar4Name = rdr.GetString("MiscChar4Name")
        newObject.MiscChar5 = rdr.GetString("MiscChar5")
        newObject.MiscChar5Name = rdr.GetString("MiscChar5Name")
        newObject.MiscChar6 = rdr.GetString("MiscChar6")
        'TODO DB fix
        newObject.MiscChar6Name = rdr.GetString("MiscChar6Name")
        newObject.MiscDate1 = rdr.GetNullableDate("MiscDate1")
        newObject.MiscDate1Name = rdr.GetString("MiscDate1Name")
        newObject.MiscDate2 = rdr.GetNullableDate("MiscDate2")
        newObject.MiscDate2Name = rdr.GetString("MiscDate2Name")
        newObject.MiscDate3 = rdr.GetNullableDate("MiscDate3")
        newObject.MiscDate3Name = rdr.GetString("MiscDate3Name")
        newObject.MiscNum1 = rdr.GetNullableDecimal("MiscNum1")
        newObject.MiscNum1Name = rdr.GetString("MiscNum1Name")
        newObject.MiscNum2 = rdr.GetNullableDecimal("MiscNum2")
        newObject.MiscNum2Name = rdr.GetString("MiscNum2Name")
        newObject.MiscNum3 = rdr.GetNullableDecimal("MiscNum3")
        newObject.MiscNum3Name = rdr.GetString("MiscNum3Name")
        newObject.ExportScriptExtensionCollection = PopulateExportScriptExtensionCollection(newObject)
        newObject.EndPopulate()
        Return newObject
    End Function
#End Region

    ''' <summary>Populates the script extension object which are pivots of the script extension properties</summary>
    ''' <returns>ExportScriptExtensionCollection</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function PopulateExportScriptExtensionCollection(ByVal NewObject As ExportScriptSelected) As ExportScriptExtensionCollection
        Dim newExportScriptExtensionCollection As New ExportScriptExtensionCollection

        Dim MiscChar1Extension As ExportScriptExtension = ExportScriptExtension.NewExportScriptExtension(NewObject, "MiscChar1", NewObject.MiscChar1Name, NewObject.MiscChar1)
        newExportScriptExtensionCollection.Add(MiscChar1Extension)

        Dim MiscChar2Extension As ExportScriptExtension = ExportScriptExtension.NewExportScriptExtension(NewObject, "MiscChar2", NewObject.MiscChar2Name, NewObject.MiscChar2)
        newExportScriptExtensionCollection.Add(MiscChar2Extension)

        Dim MiscChar3Extension As ExportScriptExtension = ExportScriptExtension.NewExportScriptExtension(NewObject, "MiscChar3", NewObject.MiscChar3Name, NewObject.MiscChar3)
        newExportScriptExtensionCollection.Add(MiscChar3Extension)

        Dim MiscChar4Extension As ExportScriptExtension = ExportScriptExtension.NewExportScriptExtension(NewObject, "MiscChar4", NewObject.MiscChar4Name, NewObject.MiscChar4)
        newExportScriptExtensionCollection.Add(MiscChar4Extension)

        Dim MiscChar5Extension As ExportScriptExtension = ExportScriptExtension.NewExportScriptExtension(NewObject, "MiscChar5", NewObject.MiscChar5Name, NewObject.MiscChar5)
        newExportScriptExtensionCollection.Add(MiscChar5Extension)

        Dim MiscChar6Extension As ExportScriptExtension = ExportScriptExtension.NewExportScriptExtension(NewObject, "MiscChar6", NewObject.MiscChar6Name, NewObject.MiscChar6)
        newExportScriptExtensionCollection.Add(MiscChar6Extension)

        Dim MiscNum1Extension As ExportScriptExtension = ExportScriptExtension.NewExportScriptExtension(NewObject, "MiscNum1", NewObject.MiscNum1Name, NewObject.MiscNum1.ToString)
        newExportScriptExtensionCollection.Add(MiscNum1Extension)

        Dim MiscNum2Extension As ExportScriptExtension = ExportScriptExtension.NewExportScriptExtension(NewObject, "MiscNum2", NewObject.MiscNum2Name, NewObject.MiscNum2.ToString)
        newExportScriptExtensionCollection.Add(MiscNum2Extension)

        Dim MiscNum3Extension As ExportScriptExtension = ExportScriptExtension.NewExportScriptExtension(NewObject, "MiscNum3", NewObject.MiscNum3Name, NewObject.MiscNum3.ToString)
        newExportScriptExtensionCollection.Add(MiscNum3Extension)

        Dim MiscDate1Extension As ExportScriptExtension = ExportScriptExtension.NewExportScriptExtension(NewObject, "MiscDate1", NewObject.MiscDate1Name, NewObject.MiscDate1.ToString)
        newExportScriptExtensionCollection.Add(MiscDate1Extension)

        Dim MiscDate2Extension As ExportScriptExtension = ExportScriptExtension.NewExportScriptExtension(NewObject, "MiscDate2", NewObject.MiscDate2Name, NewObject.MiscDate2.ToString)
        newExportScriptExtensionCollection.Add(MiscDate2Extension)

        Dim MiscDate3Extension As ExportScriptExtension = ExportScriptExtension.NewExportScriptExtension(NewObject, "MiscDate3", NewObject.MiscDate3Name, NewObject.MiscDate3.ToString)
        newExportScriptExtensionCollection.Add(MiscDate3Extension)

        Return newExportScriptExtensionCollection
    End Function

End Class
