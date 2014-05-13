Imports Nrc.Qualisys.QualisysDataEntry.Library.DbHelper

''' -----------------------------------------------------------------------------
''' Project	 : QDEClasses
''' Class	 : QDEClasses.Batch
''' 
''' -----------------------------------------------------------------------------
''' <summary>
''' Represents a group of forms that will be data entered and finalized together.
''' </summary>
''' <remarks>
''' </remarks>
''' <history>
''' 	[JCamp]	8/5/2004	Created
''' </history>
''' -----------------------------------------------------------------------------
Public Class Batch

#Region " Private Members "
    Private Shared mDefaultFinalFolder As String = ""

    'DB Fields
    Private mBatchID As Integer
    Private mBatchName As String
    Private mDateEntered As DateTime
    Private mBatchType As BatchOriginType
    Private mEnteredBy As String
    Private mDateFinalized As DateTime
    Private mFinalizedBy As String
#End Region

#Region " Enumerations "
    Public Enum BatchOriginType
        ManuallyAdded = 1
        LoadedFromFile = 2
    End Enum

#End Region

#Region " Public Properties "
    '''<summary>The batch ID for the batch.</summary>
    Public ReadOnly Property BatchID() As Integer
        Get
            Return mBatchID
        End Get
    End Property

    '''<summary>The name of the batch.</summary>
    Public ReadOnly Property BatchName() As String
        Get
            Return mBatchName
        End Get
    End Property

    '''<summary>The batch type.</summary>
    Public ReadOnly Property BatchType() As BatchOriginType
        Get
            Return mBatchType
        End Get
    End Property

    '''<summary>The default folder location for finalized files as defined in QualPro_Params.</summary>
    Public Shared ReadOnly Property DefaultFinalizeFolder() As String
        Get
            If mDefaultFinalFolder.Length = 0 Then
                mDefaultFinalFolder = ExecuteScalar(Of String)("SP_QDE_SelectFinalizeFolder")
            End If

            Return mDefaultFinalFolder
        End Get
    End Property

    '''<summary>The name of the file that will store the finalized data for the batch.</summary>
    Public ReadOnly Property FinalizedFileName() As String
        Get
            Return mBatchName.Replace(" ", "_").Replace(":", "_") & ".vstr"
        End Get
    End Property
#End Region

#Region " Constructors "
    Public Sub New()
    End Sub
    Private Sub New(ByVal dbData As DataRow)
        mBatchID = CType(dbData("Batch_id"), Integer)
        mBatchName = dbData("strBatchName").ToString
        If IsDBNull(dbData("datEntered")) Then
            mDateEntered = DateTime.MinValue
        Else
            mDateEntered = CType(dbData("datEntered"), Date)
        End If
        mEnteredBy = dbData("strEnteredBy").ToString
        If IsDBNull(dbData("datFinalized")) Then
            mDateFinalized = DateTime.MinValue
        Else
            mDateFinalized = CType(dbData("datFinalized"), Date)
        End If
        mFinalizedBy = dbData("strFinalizedBy").ToString
        mBatchType = CType(dbData("BatchType_id"), Batch.BatchOriginType)
    End Sub
#End Region

#Region " Public Methods "

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Creates a text file containing all the comment data for this batch.
    ''' </summary>
    ''' <param name="filePath">The path of the file that should be created.</param>
    ''' <param name="userName">The user who is doing the finalization.</param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	8/5/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub FinalizeBatch(ByVal filePath As String, ByVal userName As String)
        Dim tblForms As DataTable = QDEForm.GetFormList(mBatchID)
        Dim row As DataRow
        Dim form As QDEForm
        Dim finalString As String

        'Open the stream
        Using writer As New IO.StreamWriter(filePath, False)
            'For each form, write the form finalized string
            For Each row In tblForms.Rows
                form = QDEForm.LoadFromDB(CType(row("Form_id"), Integer))

                finalString = form.GetFinalizeString
                If Not finalString Is Nothing AndAlso Not finalString = "" Then
                    writer.WriteLine(form.GetFinalizeString)
                End If
            Next

            'Now flag the batch as finalized
            MarkAsFinalized(userName)
        End Using
    End Sub

#Region " CRUD Database Methods "
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Creates a new batch in the QDEBatch table.
    ''' </summary>
    ''' <param name="userName">The user creating the batch</param>
    ''' <param name="batchType">The type of batch being created</param>
    ''' <returns>The new Batch object that was just created</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	8/5/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function InsertNewBatch(ByVal userName As String, ByVal batchType As BatchOriginType) As Batch
        Dim tbl As DataTable
        tbl = ExecuteDataset("SP_QDE_InsertBatch", userName, batchType).Tables(0)

        Dim b As New Batch(tbl.Rows(0))
        Return b
    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Loads as Batch object for the specified Batch_id from the database 
    ''' </summary>
    ''' <param name="batchID">The ID of the Batch object to load</param>
    ''' <returns>The Batch object retrived from the database.</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	8/5/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function LoadFromDB(ByVal batchID As Integer) As Batch
        Dim tbl As DataTable
        tbl = ExecuteDataset("SP_QDE_SelectBatchData", batchID).Tables(0)

        Dim b As New Batch(tbl.Rows(0))
        Return b
    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Assigns a litho to be a part of this batch.
    ''' </summary>
    ''' <param name="strLitho">The litho code to assign to this batch</param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	8/5/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Function AssignLitho(ByVal strLitho As String) As Boolean
        Return ExecuteScalar(Of Boolean)("SP_QDE_AssignLithoToBatch", strLitho, mBatchID)
    End Function


    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Returns a datatable listing all the batches and templates that have 
    ''' work to be done in the specified stage.
    ''' </summary>
    ''' <param name="stage">The stage of work to be returned.</param>
    ''' <returns>A datatable listing the templates that have work.</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	8/4/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function GetBatchWorkList(ByVal stage As QDEForm.WorkStage, ByVal userName As String) As DataTable
        Dim ds As DataSet = ExecuteDataset("SP_QDE_SelectBatchWork", stage, userName)
        If ds.Tables.Count = 0 Then
            Return Nothing
        Else
            Return ds.Tables(0)
        End If

    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Updates all comment records in this batch, setting the bitIgnore flag to true if
    ''' the comment is blank.
    ''' </summary>
    ''' <param name="templateName">The template name of the forms that should be updated</param>
    ''' <remarks>
    ''' This is used after forms a added to a batch from an imported file.  All the comments that
    ''' were not a part of that file will be marked with a bitIgnore flag so the data entry
    ''' operators will not see them.
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	8/5/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub UpdateBatchIgnoreFlags(ByVal templateName As String, ByVal isAfterKeying As Boolean)
        If templateName.Length > 0 Then
            ExecuteNonQuery("SP_QDE_UpdateBatchIgnoreFlags", mBatchID, templateName, isAfterKeying)
        Else
            ExecuteNonQuery("SP_QDE_UpdateBatchIgnoreFlags", mBatchID, DBNull.Value, isAfterKeying)
        End If
    End Sub


    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Overload of UpdateBatchIgnoreFlags that assumes no template name and thus
    ''' will update all comment records for a batch regardless of template name.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	8/10/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub UpdateBatchIgnoreFlags(ByVal isAfterKeying As Boolean)
        UpdateBatchIgnoreFlags("", isAfterKeying)
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Returns a datatable listing all Batch_IDs that are ready for finalization.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	8/5/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function GetBatchesToFinalize() As DataTable
        Return ExecuteDataset("SP_QDE_SelectFinalizationList").Tables(0)
    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Updates the QDEBatch table and sets the finalized date and the user name.
    ''' </summary>
    ''' <param name="userName">The user doing the finalization.</param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	8/5/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Private Sub MarkAsFinalized(ByVal userName As String)
        ExecuteNonQuery("SP_QDE_UpdateBatchFinalizedDate", mBatchID, userName)
    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Returns a dataset with the current system totals of "work to be done" for all batches.
    ''' </summary>
    ''' <returns>DataTable object.</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	8/10/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function GetSystemStats() As DataTable
        Return ExecuteDataset("SP_QDE_CurrentCounts").Tables(0)
    End Function

    Public Shared Sub DeleteBatch(ByVal batchId As Integer)
        ExecuteNonQuery("SP_QDE_RollBackBatch", batchId)
    End Sub

#End Region

#End Region

End Class
