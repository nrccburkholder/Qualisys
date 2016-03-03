'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class DataFileProvider
    Inherits QualiSys.Pervasive.Library.DataFileProvider

    Private ReadOnly Property Db() As Database
        Get
            Return DatabaseHelper.Db
        End Get
    End Property


#Region " DataFile Procs "

    Private Function PopulateDataFile(ByVal rdr As SafeDataReader) As DataFile
        Dim newObject As DataFile = DataFile.NewDataFile
        Dim privateInterface As IDataFile = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("DataFile_id")
        newObject.ClientId = rdr.GetInteger("Client_ID")
        newObject.StudyId = rdr.GetInteger("Study_ID")
        newObject.SurveyId = rdr.GetInteger("Survey_ID")
        newObject.FileTypeId = rdr.GetInteger("FileType_id")
        newObject.PervasiveMapName = rdr.GetString("PervasiveMapName")
        newObject.FileLocation = rdr.GetString("strFileLocation")
        newObject.FileName = rdr.GetString("strFile_nm")
        newObject.FileSize = rdr.GetInteger("intFileSize")
        newObject.Records = rdr.GetInteger("intRecords")
        newObject.datReceived = rdr.GetDate("datReceived")
        newObject.datBegin = rdr.GetDate("datBegin")
        newObject.datEnd = rdr.GetDate("datEnd")
        newObject.Loaded = rdr.GetInteger("intLoaded")
        newObject.datMinDate = rdr.GetDate("datMinDate")
        newObject.datMaxDate = rdr.GetDate("datMaxDate")
        newObject.datDeleted = rdr.GetDate("datDeleted")
        newObject.DataSetId = rdr.GetInteger("DataSet_id")
        newObject.AssocDataFiles = rdr.GetString("AssocDataFiles")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectDataFile(ByVal id As Integer) As DataFile
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectDataFile, id)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateDataFile(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllDataFiles() As DataFileCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllDataFiles)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of DataFileCollection, DataFile)(rdr, AddressOf PopulateDataFile)
        End Using
    End Function

    Public Overrides Function InsertDataFile(ByVal instance As DataFile) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertDataFile, instance.ClientId, instance.StudyId, instance.SurveyId, instance.FileTypeId, instance.PervasiveMapName, instance.FileLocation, instance.FileName, instance.FileSize, instance.Records, SafeDataReader.ToDBValue(instance.datReceived), SafeDataReader.ToDBValue(instance.datBegin), SafeDataReader.ToDBValue(instance.datEnd), instance.Loaded, SafeDataReader.ToDBValue(instance.datMinDate), SafeDataReader.ToDBValue(instance.datMaxDate), SafeDataReader.ToDBValue(instance.datDeleted), instance.DataSetId, instance.AssocDataFiles)
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateDataFile(ByVal instance As DataFile)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateDataFile, instance.Id, instance.ClientId, instance.StudyId, instance.SurveyId, instance.FileTypeId, instance.PervasiveMapName, instance.FileLocation, instance.FileName, instance.FileSize, instance.Records, SafeDataReader.ToDBValue(instance.datReceived), SafeDataReader.ToDBValue(instance.datBegin), SafeDataReader.ToDBValue(instance.datEnd), instance.Loaded, SafeDataReader.ToDBValue(instance.datMinDate), SafeDataReader.ToDBValue(instance.datMaxDate), SafeDataReader.ToDBValue(instance.datDeleted), instance.DataSetId, instance.AssocDataFiles)
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteDataFile(ByVal instance As DataFile)
        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteDataFile, instance.Id)
            ExecuteNonQuery(cmd)
        End If
    End Sub

    Public Overrides Sub Apply(ByVal instance As DataFile)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ApplyDataFile, instance.Id, 0)
        ExecuteNonQuery(cmd)
    End Sub

    'Returns True if valid; False if invalid
    Public Overrides Function Validate(ByVal instance As DataFile) As Boolean
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.ValidateDataFile, instance.Id, 0, Date.Now)
        Return ExecuteBoolean(cmd)
    End Function
#End Region

End Class
