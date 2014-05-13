'********************************************************************************
' Concrete SqlProvider Class
'********************************************************************************
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common
Imports NRC.Framework.Data


Friend Class CommentProvider
	Inherits QualiSys.Scanning.Library.CommentProvider

    Private ReadOnly Property Db() As Database
        Get
            Return QualiSysDatabaseHelper.Db
        End Get
    End Property

	
#Region " Comment Procs "

    Private Function PopulateComment(ByVal rdr As SafeDataReader) As Comment

        Dim newObject As Comment = Comment.NewComment
        Dim privateInterface As IComment = newObject

        newObject.BeginPopulate()
        privateInterface.DataLoadCmntId = rdr.GetInteger("DataLoadCmnt_ID")
        newObject.LithoCodeId = rdr.GetInteger("DL_LithoCode_ID")
        If rdr.IsDBNull("DL_Error_ID") Then
            newObject.ErrorId = TransferErrorCodes.None
        Else
            newObject.ErrorId = rdr.GetEnum(Of TransferErrorCodes)("DL_Error_ID")
        End If
        newObject.CmntNumber = rdr.GetInteger("CmntNumber")
        newObject.CmntText = rdr.GetString("cmntText")
        newObject.Submitted = rdr.GetBoolean("bitSubmitted")
        newObject.EndPopulate()

        Return newObject

    End Function
	
    Public Overrides Function SelectComment(ByVal dataLoadCmntId As Integer) As Comment

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectComment, dataLoadCmntId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            If Not rdr.Read Then
                Return Nothing
            Else
                Return PopulateComment(rdr)
            End If
        End Using

    End Function

    Public Overrides Function SelectCommentsByLithoCodeId(ByVal lithoCodeId As Integer) As CommentCollection

        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.SelectCommentsByLithoCodeId, lithoCodeId)
        Using rdr As New SafeDataReader(QualiSysDatabaseHelper.ExecuteReader(cmd))
            Return QualiSysDatabaseHelper.PopulateCollection(Of CommentCollection, Comment)(rdr, AddressOf PopulateComment)
        End Using

    End Function

    Public Overrides Function InsertComment(ByVal instance As Comment) As Integer

        Const kChunkSize As Integer = 6000
        Dim cmntChunk1 As String = String.Empty
        Dim cmntChunk2 As String = String.Empty

        'Determine the appropriate ErrorID
        Dim errorID As Object = DBNull.Value
        If instance.ErrorId <> TransferErrorCodes.None Then
            errorID = instance.ErrorId
        End If

        'Split the comment text into two 6000 character strings
        cmntChunk1 = instance.CmntText.Substring(0, CInt(IIf(instance.CmntText.Length >= kChunkSize, kChunkSize, instance.CmntText.Length)))
        If instance.CmntText.Length > 6000 Then
            cmntChunk2 = instance.CmntText.Substring(kChunkSize, instance.CmntText.Length - kChunkSize)
        End If

        'Insert the comment
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.InsertComment, instance.LithoCodeId, errorID, instance.CmntNumber, cmntChunk1, cmntChunk2, instance.Submitted)
        Return QualiSysDatabaseHelper.ExecuteInteger(cmd)

    End Function

    Public Overrides Sub UpdateComment(ByVal instance As Comment)

        Const kChunkSize As Integer = 6000
        Dim cmntChunk1 As String = String.Empty
        Dim cmntChunk2 As String = String.Empty

        'Determine the appropriate ErrorID
        Dim errorID As Object = DBNull.Value
        If instance.ErrorId <> TransferErrorCodes.None Then
            errorID = instance.ErrorId
        End If

        'Split the comment text into two 6000 character strings
        cmntChunk1 = instance.CmntText.Substring(0, CInt(IIf(instance.CmntText.Length >= kChunkSize, kChunkSize, instance.CmntText.Length)))
        If instance.CmntText.Length > 6000 Then
            cmntChunk2 = instance.CmntText.Substring(kChunkSize, instance.CmntText.Length - kChunkSize)
        End If

        'Update the comment
        Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.UpdateComment, instance.DataLoadCmntId, instance.LithoCodeId, errorID, instance.CmntNumber, cmntChunk1, cmntChunk2, instance.Submitted)
        QualiSysDatabaseHelper.ExecuteNonQuery(cmd)

    End Sub

    Public Overrides Sub DeleteComment(ByVal instance As Comment)

        If instance IsNot Nothing Then
            Dim cmd As DbCommand = Db.GetStoredProcCommand(SP.DeleteComment, instance.DataLoadCmntId)
            QualiSysDatabaseHelper.ExecuteNonQuery(cmd)
        End If

    End Sub

#End Region

End Class
