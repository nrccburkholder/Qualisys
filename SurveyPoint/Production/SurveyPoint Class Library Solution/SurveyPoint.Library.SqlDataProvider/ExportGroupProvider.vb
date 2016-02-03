'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Nrc.Framework.Data
Imports Nrc.Framework.BusinessLogic
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports System.ComponentModel

''' <summary>Implments the Export Group objects DAL method for SQL Server</summary>
''' <CreatedBy>Tony Piccoli</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
Friend Class ExportGroupProvider
    Inherits Nrc.SurveyPoint.Library.DataProviders.ExportGroupProvider

    ''' <summary>Retrieve a copy of the Ent Services DB Object</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property


#Region " SPU_ExportGroup Procs "

    ''' <summary>Loads an export group object from the data store and marks the object
    ''' as old.</summary>
    ''' <param name="rdr"></param>
    ''' <returns>ExportGroup</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080414 - Tony Piccoli</term>
    ''' <description>Added new field removeHTMLAndEncoding.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Function PopulateExportGroup(ByVal rdr As SafeDataReader) As ExportGroup
        Dim newObject As ExportGroup = ExportGroup.NewExportGroup
        Dim privateInterface As IExportGroup = newObject
        newObject.BeginPopulate()        
        privateInterface.ExportGroupID = rdr.GetInteger("ExportGroupID")
        If rdr.IsDBNull("RemoveHTMLAndEncoding") Then
            newObject.RemoveHTMLAndEncoding = False
        Else        
            newObject.RemoveHTMLAndEncoding = CBool(rdr.Item("RemoveHTMLAndEncoding").ToString)
        End If
        newObject.Name = rdr.GetString("Name")
        newObject.RerunCodeStartDate = rdr.GetNullableDate("RerunCodeStartDate")
        newObject.RerunCodeEndDate = rdr.GetNullableDate("RerunCodeEndDate")
        newObject.QuestionFileName = rdr.GetString("QuestionFileName")
        newObject.ResultFileName = rdr.GetString("AnswerFileName")
        newObject.MiscChar1 = rdr.GetString("MiscChar1")
        newObject.MiscChar1Name = rdr.GetString("MiscChar1Name")
        newObject.MiscChar2 = rdr.GetString("MiscChar2")
        newObject.MiscChar2Name = rdr.GetString("MiscChar2Name")
        newObject.MiscChar3 = rdr.GetString("MiscChar3")
        newObject.MiscChar3Name = rdr.GetString("MiscChar3Name")
        newObject.MiscChar4 = rdr.GetString("MiscChar4")
        newObject.MiscChar4Name = rdr.GetString("MiscChar4Name")
        newObject.MiscChar5 = rdr.GetString("MiscChar5")
        newObject.MiscChar5Name = rdr.GetString("MiscChar5Name")
        newObject.MiscChar6 = rdr.GetString("MiscChar6")
        newObject.MiscChar6Name = rdr.GetString("MiscChar6Name")
        newObject.MiscNum1 = rdr.GetNullableDecimal("MiscNum1")
        newObject.MiscNum1Name = rdr.GetString("MiscNum1Name")
        newObject.MiscNum2 = rdr.GetNullableDecimal("MiscNum2")
        newObject.MiscNum2Name = rdr.GetString("MiscNum2Name")
        newObject.MiscNum3 = rdr.GetNullableDecimal("MiscNum3")
        newObject.MiscNum3Name = rdr.GetString("MiscNum3Name")
        newObject.MiscDate1 = rdr.GetNullableDate("MiscDate1")
        newObject.MiscDate1Name = rdr.GetString("MiscDate1Name")
        newObject.MiscDate2 = rdr.GetNullableDate("MiscDate2")
        newObject.MiscDate2Name = rdr.GetString("MiscDate2Name")
        newObject.MiscDate3 = rdr.GetNullableDate("MiscDate3")
        newObject.MiscDate3Name = rdr.GetString("MiscDate3Name")
        newObject.ExportFileLayout = ExportFileLayout.Get(rdr.GetInteger("FileLayoutID"))
        newObject.ExportGroupExtensionCollection = PopulateExportGroupExtensionCollection(newObject)
        newObject.EndPopulate()
        Return newObject
    End Function

    ''' <summary>This method populates the ExportGroupExtension collection from the fields of the export group.</summary>
    ''' <param name="NewObject"></param>
    ''' <returns></returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function PopulateExportGroupExtensionCollection(ByVal NewObject As ExportGroup) As ExportGroupExtensionCollection
        Dim newExportGroupExtensionCollection As ExportGroupExtensionCollection = New ExportGroupExtensionCollection

        Dim MiscChar1Extension As ExportGroupExtension = ExportGroupExtension.NewExportGroupExtension(NewObject, "MiscChar1", NewObject.MiscChar1Name, NewObject.MiscChar1)
        newExportGroupExtensionCollection.Add(MiscChar1Extension)

        Dim MiscChar2Extension As ExportGroupExtension = ExportGroupExtension.NewExportGroupExtension(NewObject, "MiscChar2", NewObject.MiscChar2Name, NewObject.MiscChar2)
        newExportGroupExtensionCollection.Add(MiscChar2Extension)

        Dim MiscChar3Extension As ExportGroupExtension = ExportGroupExtension.NewExportGroupExtension(NewObject, "MiscChar3", NewObject.MiscChar3Name, NewObject.MiscChar3)
        newExportGroupExtensionCollection.Add(MiscChar3Extension)

        Dim MiscChar4Extension As ExportGroupExtension = ExportGroupExtension.NewExportGroupExtension(NewObject, "MiscChar4", NewObject.MiscChar4Name, NewObject.MiscChar4)
        newExportGroupExtensionCollection.Add(MiscChar4Extension)

        Dim MiscChar5Extension As ExportGroupExtension = ExportGroupExtension.NewExportGroupExtension(NewObject, "MiscChar5", NewObject.MiscChar5Name, NewObject.MiscChar5)
        newExportGroupExtensionCollection.Add(MiscChar5Extension)

        Dim MiscChar6Extension As ExportGroupExtension = ExportGroupExtension.NewExportGroupExtension(NewObject, "MiscChar6", NewObject.MiscChar6Name, NewObject.MiscChar6)
        newExportGroupExtensionCollection.Add(MiscChar6Extension)

        Dim MiscNum1Extension As ExportGroupExtension = ExportGroupExtension.NewExportGroupExtension(NewObject, "MiscNum1", NewObject.MiscNum1Name, NewObject.MiscNum1.ToString)
        newExportGroupExtensionCollection.Add(MiscNum1Extension)

        Dim MiscNum2Extension As ExportGroupExtension = ExportGroupExtension.NewExportGroupExtension(NewObject, "MiscNum2", NewObject.MiscNum2Name, NewObject.MiscNum2.ToString)
        newExportGroupExtensionCollection.Add(MiscNum2Extension)

        Dim MiscNum3Extension As ExportGroupExtension = ExportGroupExtension.NewExportGroupExtension(NewObject, "MiscNum3", NewObject.MiscNum3Name, NewObject.MiscNum3.ToString)
        newExportGroupExtensionCollection.Add(MiscNum3Extension)

        Dim MiscDate1Extension As ExportGroupExtension = ExportGroupExtension.NewExportGroupExtension(NewObject, "MiscDate1", NewObject.MiscDate1Name, NewObject.MiscDate1.ToString)
        newExportGroupExtensionCollection.Add(MiscDate1Extension)

        Dim MiscDate2Extension As ExportGroupExtension = ExportGroupExtension.NewExportGroupExtension(NewObject, "MiscDate2", NewObject.MiscDate2Name, NewObject.MiscDate2.ToString)
        newExportGroupExtensionCollection.Add(MiscDate2Extension)

        Dim MiscDate3Extension As ExportGroupExtension = ExportGroupExtension.NewExportGroupExtension(NewObject, "MiscDate3", NewObject.MiscDate3Name, NewObject.MiscDate3.ToString)
        newExportGroupExtensionCollection.Add(MiscDate3Extension)

        Return newExportGroupExtensionCollection
    End Function

    ''' <summary>Returns a bool value on whether or not an export group exists.</summary>
    ''' <param name="rdr"></param>
    ''' <returns>Boolean</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function ReturnBoolean(ByVal rdr As SafeDataReader) As Boolean
        Return CBool(rdr.GetValue("ExportExists").ToString)
    End Function
    ''' <summary>Returns and Export Group ID</summary>
    ''' <param name="rdr"></param>
    ''' <returns>Integer</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function ReturnInteger(ByVal rdr As SafeDataReader) As Integer
        Return rdr.GetInteger("ExportID")
    End Function

    ''' <summary>Creates and executes a stored proc to copy an existing export group.</summary>
    ''' <param name="oldExportID"></param>
    ''' <param name="newExportGroupName"></param>
    ''' <returns>The ID of the new export group.</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function CopyExport(ByVal oldExportID As Integer, ByVal newExportGroupName As String) As Integer
        Dim retval As Integer = 0        
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CopyExport, oldExportID, newExportGroupName)
        retval = Convert.ToInt32(ExecuteScalar(cmd))
        Return retval
    End Function
    ''' <summary>Runs a stored proc to see if an export group exists in the data store.</summary>
    ''' <param name="exportGroupName"></param>
    ''' <returns>Boolean</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function CheckExportGroupByName(ByVal exportGroupName As String, ByVal exportGroupId As Integer) As Boolean
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CheckExportGroupByName, exportGroupName, exportGroupId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return True
            Else
                Return ReturnBoolean(rdr)
            End If
        End Using
    End Function

    ''' <summary>Calls a stored proc to get data to populate an export group by export ID</summary>
    ''' <param name="exportGroupID"></param>
    ''' <returns>ExportGroup</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function SelectExportGroup(ByVal exportGroupID As Integer) As ExportGroup
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectExportGroup, exportGroupID)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateExportGroup(rdr)
            End If
        End Using
    End Function

    ''' <summary>Calls a stored proc to get data to populate a collection of export group objects</summary>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function SelectAllExportGroups() As ExportGroupCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllExportGroups)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of ExportGroupCollection, ExportGroup)(rdr, AddressOf PopulateExportGroup)
        End Using
    End Function

    ''' <summary>Call a stored proc to insert a new export group into the data
    ''' store.</summary>
    ''' <param name="instance"></param>
    ''' <returns>The new export group ID</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080414 - Tony Piccoli</term>
    ''' <description>Added removeHTMLAndEncoding to procedure (new
    ''' field)</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Overrides Function InsertExportGroup(ByVal instance As ExportGroup) As Integer
        Dim retval As Integer = 0
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertExportGroup, instance.Name, instance.ExportFileLayout.FileLayoutID, _
            SafeDataReader.ToDBValue(instance.RerunCodeStartDate), SafeDataReader.ToDBValue(instance.RerunCodeEndDate), _
            instance.QuestionFileName, instance.ResultFileName, instance.MiscChar1, _
            instance.MiscChar1Name, instance.MiscChar2, instance.MiscChar2Name, instance.MiscChar3, _
            instance.MiscChar3Name, instance.MiscChar4, instance.MiscChar4Name, instance.MiscChar5, _
            instance.MiscChar5Name, instance.MiscChar6, instance.MiscChar6Name, instance.MiscNum1, _
            instance.MiscNum1Name, instance.MiscNum2, instance.MiscNum2Name, instance.MiscNum3, _
            instance.MiscNum3Name, SafeDataReader.ToDBValue(instance.MiscDate1), instance.MiscDate1Name, _
            SafeDataReader.ToDBValue(instance.MiscDate2), instance.MiscDate2Name, _
            SafeDataReader.ToDBValue(instance.MiscDate3), instance.MiscDate3Name, instance.RemoveHTMLAndEncoding, instance.ExportSelectedSurvey.SurveyID)        
        retval = Convert.ToInt32(ExecuteScalar(cmd))
        Return retval
    End Function

    ''' <summary>Calls a stored proc to update an existing export group</summary>
    ''' <param name="instance"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080414 - Tony Piccoli</term>
    ''' <description>added new field (removeHTMLAndEncoding) to procedure
    ''' call.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Overrides Sub UpdateExportGroup(ByVal instance As ExportGroup)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateExportGroup, instance.ExportGroupID, instance.Name, instance.ExportFileLayout.FileLayoutID, _
            SafeDataReader.ToDBValue(instance.RerunCodeStartDate), SafeDataReader.ToDBValue(instance.RerunCodeEndDate), _
            instance.QuestionFileName, instance.ResultFileName, _
            instance.MiscChar1, instance.MiscChar1Name, instance.MiscChar2, instance.MiscChar2Name, _
            instance.MiscChar3, instance.MiscChar3Name, instance.MiscChar4, instance.MiscChar4Name, _
            instance.MiscChar5, instance.MiscChar5Name, instance.MiscChar6, instance.MiscChar6Name, _
            instance.MiscNum1, instance.MiscNum1Name, instance.MiscNum2, instance.MiscNum2Name, _
            instance.MiscNum3, instance.MiscNum3Name, SafeDataReader.ToDBValue(instance.MiscDate1), _
            instance.MiscDate1Name, SafeDataReader.ToDBValue(instance.MiscDate2), instance.MiscDate2Name, _
            SafeDataReader.ToDBValue(instance.MiscDate3), instance.MiscDate3Name, instance.RemoveHTMLAndEncoding, instance.ExportSelectedSurvey.SurveyID)        
        ExecuteNonQuery(cmd)
    End Sub

    ''' <summary>Deletes an existing export group by export group id</summary>
    ''' <param name="exportGroupID"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub DeleteExportGroup(ByVal exportGroupID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteExportGroup, exportGroupID)
        ExecuteNonQuery(cmd)
    End Sub
    ''' <summary>Calls stored proc that deletes and existing export group and all of its child relations.</summary>
    ''' <param name="exportGroupID"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub DeleteExportGroupAll(ByVal exportGroupID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteExportGroupAll, exportGroupID)        
        ExecuteNonQuery(cmd)
    End Sub
    ''' <summary>Calls stored proc to delete all child relations of an export group.</summary>
    ''' <param name="exportGroupID"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Sub DeleteExportGroupChildren(ByVal exportGroupID As Integer)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteExportGroupChildren, exportGroupID)
        ExecuteNonQuery(cmd)
    End Sub

    ''' <summary>You should not be able to save or run an export if one is currently running.  This method check if a export is currently running.</summary>
    ''' <returns>True if an export is running, false if not.</returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function CheckForRunningExport() As Boolean
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.CheckForRunningexport)
        Dim retVal As Boolean = CBool(ExecuteInteger(cmd))
        Return retVal
    End Function
#End Region


End Class
