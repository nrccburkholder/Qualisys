Imports NRC.Framework.BusinessLogic
Imports System.IO
Imports Nrc.Framework.BusinessLogic.Configuration

Public Interface IQSIDataBatch

    Property BatchId() As Integer
    Property BatchName() As String

End Interface

<Serializable()> _
Public Class QSIDataBatch
	Inherits BusinessBase(Of QSIDataBatch)
	Implements IQSIDataBatch

#Region " Private Members "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mBatchId As Integer
    Private mBatchName As String = String.Empty
    Private mLocked As Boolean
    Private mDateEntered As Date
    Private mEnteredBy As String = String.Empty
    Private mDateFinalized As Date
    Private mFinalizedBy As String = String.Empty

    Private mForms As QSIDataFormCollection

#End Region

#Region " Public Properties "

    Public Property BatchId() As Integer Implements IQSIDataBatch.BatchId
        Get
            Return mBatchId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mBatchId Then
                mBatchId = value
                PropertyHasChanged("BatchId")
            End If
        End Set
    End Property

    Public Property BatchName() As String Implements IQSIDataBatch.BatchName
        Get
            Return mBatchName
        End Get
        Private Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mBatchName Then
                mBatchName = value
                PropertyHasChanged("BatchName")
            End If
        End Set
    End Property

    Public Property Locked() As Boolean
        Get
            Return mLocked
        End Get
        Set(ByVal value As Boolean)
            If Not value = mLocked Then
                mLocked = value
                PropertyHasChanged("Locked")
            End If
        End Set
    End Property

    Public Property DateEntered() As Date
        Get
            Return mDateEntered
        End Get
        Set(ByVal value As Date)
            If Not value = mDateEntered Then
                mDateEntered = value
                PropertyHasChanged("DateEntered")
            End If
        End Set
    End Property

    Public Property EnteredBy() As String
        Get
            Return mEnteredBy
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mEnteredBy Then
                mEnteredBy = value
                PropertyHasChanged("EnteredBy")
            End If
        End Set
    End Property

    Public Property DateFinalized() As Date
        Get
            Return mDateFinalized
        End Get
        Set(ByVal value As Date)
            If Not value = mDateFinalized Then
                mDateFinalized = value
                PropertyHasChanged("DateFinalized")
            End If
        End Set
    End Property

    Public Property FinalizedBy() As String
        Get
            Return mFinalizedBy
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFinalizedBy Then
                mFinalizedBy = value
                PropertyHasChanged("FinalizedBy")
            End If
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property Forms() As QSIDataFormCollection
        Get
            If mForms Is Nothing Then
                mForms = QSIDataForm.GetByBatchId(mBatchId)
            End If

            Return mForms
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub
#End Region

#Region " Factory Methods "

    Public Shared Function NewQSIDataBatch() As QSIDataBatch

        Return New QSIDataBatch

    End Function

    Public Shared Function [Get](ByVal batchId As Integer) As QSIDataBatch

        Return QSIDataBatchProvider.Instance.SelectQSIDataBatch(batchId)

    End Function

    Public Shared Function GetAll() As QSIDataBatchCollection

        Return QSIDataBatchProvider.Instance.SelectAllQSIDataBatches()

    End Function

    Public Shared Function IsBatchComplete(ByVal batchId As Integer) As Boolean

        Return QSIDataBatchProvider.Instance.IsQSIDataBatchComplete(batchId)

    End Function
#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mBatchId
        End If
    End Function

#End Region

#Region " Validation "

    Protected Overrides Sub AddBusinessRules()

        'Add validation rules here...

    End Sub

#End Region

#Region " Data Access "

    Protected Overrides Sub CreateNew()

        'Set default values here

        'Optionally finish by validating default values
        ValidationRules.CheckRules()

    End Sub

    Protected Overrides Sub Insert()

        'Create the new batch
        BatchId = QSIDataBatchProvider.Instance.InsertQSIDataBatch(Me)

        'Get the batch name
        Dim batch As QSIDataBatch = QSIDataBatch.Get(BatchId)
        BatchName = batch.BatchName

    End Sub

    Protected Overrides Sub Update()

        QSIDataBatchProvider.Instance.UpdateQSIDataBatch(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        QSIDataBatchProvider.Instance.DeleteQSIDataBatch(Me)

    End Sub

#End Region

#Region " Public Methods "

    Public Sub DeleteBatch()

        QSIDataBatchProvider.Instance.DeleteQSIDataBatch(Me)

    End Sub

    Public Sub FinalizeBatch(ByVal userName As String)

        'TODO: Write the code to do the finalization
        Dim strFile As FileInfo = Nothing
        Dim strStream As StreamWriter = Nothing

        Try
            'Get a FileInfo for the STR file name
            strFile = New FileInfo(Path.Combine(AppConfig.Params("QSIDataEntryFinalFolder").StringValue, mBatchName.Replace(" ", "_").Replace(":", "_") & ".str"))

            'Create the STR file
            strStream = strFile.CreateText

            'Loop through all of the forms (LithoCodes) in the batch and output the finalization line
            For Each form As QSIDataForm In Forms
                strStream.WriteLine(form.FinalizeForm)
            Next

            'Close the STR file
            strStream.Flush()
            strStream.Close()

            'Mark batch as finalized
            FinalizedBy = userName
            DateFinalized = Date.Now
            Save()

        Catch ex As Exception
            'We have encountered an error so attempt to clean it up
            If strFile IsNot Nothing AndAlso strFile.Exists Then
                If strStream IsNot Nothing Then
                    strStream.Close()
                End If

                strFile.Delete()
            End If

            'Recast the error
            Throw ex

        End Try

    End Sub

#End Region

End Class


