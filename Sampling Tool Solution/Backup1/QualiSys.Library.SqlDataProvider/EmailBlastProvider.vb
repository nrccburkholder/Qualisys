'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class EmailBlastProvider
    Inherits QualiSys.Library.EmailBlastProvider

    Private ReadOnly Property Db() As Database
        Get
            Return Globals.Db
        End Get
    End Property


#Region " MM_EmailBlast Procs "

    Private Function PopulateEmailBlast(ByVal rdr As SafeDataReader) As EmailBlast
        Dim newObject As EmailBlast = EmailBlast.NewEmailBlast
        Dim privateInterface As IEmailBlast = newObject
        newObject.BeginPopulate()
        privateInterface.Id = rdr.GetInteger("MM_EmailBlast_ID")
        newObject.MAILINGSTEPId = rdr.GetInteger("MAILINGSTEP_ID")
        newObject.EmailBlastId = rdr.GetInteger("EmailBlast_ID")
        newObject.DaysFromStepGen = rdr.GetInteger("DaysFromStepGen")
        newObject.DateSent = rdr.GetNullableDate("DateSent")
        newObject.EndPopulate()

        Return newObject
    End Function

    Public Overrides Function SelectEmailBlast(ByVal id As Integer) As EmailBlast
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectEmailBlast, id)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateEmailBlast(rdr)
            End If
        End Using
    End Function

    Public Overrides Function SelectAllEmailBlasts() As EmailBlastCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectAllEmailBlasts)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of EmailBlastCollection, EmailBlast)(rdr, AddressOf PopulateEmailBlast)
        End Using
    End Function

    Public Overrides Function SelectEmailBlastsByMAILINGSTEPId(ByVal mAILINGSTEPId As Integer) As EmailBlastCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectEmailBlastsByMAILINGSTEPId, mAILINGSTEPId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of EmailBlastCollection, EmailBlast)(rdr, AddressOf PopulateEmailBlast)
        End Using
    End Function

    Public Overrides Function SelectEmailBlastsByEmailBlastId(ByVal emailBlastId As Integer) As EmailBlastCollection
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectEmailBlastsByEmailBlastId, emailBlastId)
        Using rdr As New SafeDataReader(ExecuteReader(cmd))
            Return PopulateCollection(Of EmailBlastCollection, EmailBlast)(rdr, AddressOf PopulateEmailBlast)
        End Using
    End Function

    Public Overrides Function InsertEmailBlast(ByVal instance As EmailBlast) As Integer
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertEmailBlast, instance.MAILINGSTEPId, instance.EmailBlastId, instance.DaysFromStepGen, SafeDataReader.ToDBValue(instance.DateSent))
        Return ExecuteInteger(cmd)
    End Function

    Public Overrides Sub UpdateEmailBlast(ByVal instance As EmailBlast)
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateEmailBlast, instance.Id, instance.MAILINGSTEPId, instance.EmailBlastId, instance.DaysFromStepGen, SafeDataReader.ToDBValue(instance.DateSent))
        ExecuteNonQuery(cmd)
    End Sub

    Public Overrides Sub DeleteEmailBlast(ByVal instance As EmailBlast)
        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteEmailBlast, instance.Id)
            ExecuteNonQuery(cmd)
        End If
    End Sub

#End Region


End Class
