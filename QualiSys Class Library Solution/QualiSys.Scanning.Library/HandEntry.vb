Imports NRC.Framework.BusinessLogic

Public Interface IHandEntry

    Property HandEntryId() As Integer
    Property FieldName() As String

End Interface

<Serializable()> _
Public Class HandEntry
	Inherits BusinessBase(Of HandEntry)
	Implements IHandEntry

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mHandEntryId As Integer
    Private mLithoCodeId As Integer
    Private mErrorId As TransferErrorCodes
    Private mQstnCore As Integer
    Private mItemNumber As Integer
    Private mLineNumber As Integer
    Private mHandEntryText As String = String.Empty
    Private mFieldName As String

#End Region

#Region " Public Properties "

    Public Property HandEntryId() As Integer Implements IHandEntry.HandEntryId
        Get
            Return mHandEntryId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mHandEntryId Then
                mHandEntryId = value
                PropertyHasChanged("HandEntryId")
            End If
        End Set
    End Property

    Public Property LithoCodeId() As Integer
        Get
            Return mLithoCodeId
        End Get
        Set(ByVal value As Integer)
            If Not value = mLithoCodeId Then
                mLithoCodeId = value
                PropertyHasChanged("LithoCodeId")
            End If
        End Set
    End Property

    Public Property ErrorId() As TransferErrorCodes
        Get
            Return mErrorId
        End Get
        Set(ByVal value As TransferErrorCodes)
            If Not value = mErrorId Then
                mErrorId = value
                PropertyHasChanged("ErrorId")
            End If
        End Set
    End Property

    Public Property QstnCore() As Integer
        Get
            Return mQstnCore
        End Get
        Set(ByVal value As Integer)
            If Not value = mQstnCore Then
                mQstnCore = value
                PropertyHasChanged("QstnCore")
            End If
        End Set
    End Property

    Public Property ItemNumber() As Integer
        Get
            Return mItemNumber
        End Get
        Set(ByVal value As Integer)
            If Not value = mItemNumber Then
                mItemNumber = value
                PropertyHasChanged("ItemNumber")
            End If
        End Set
    End Property

    Public Property LineNumber() As Integer
        Get
            Return mLineNumber
        End Get
        Set(ByVal value As Integer)
            If Not value = mLineNumber Then
                mLineNumber = value
                PropertyHasChanged("LineNumber")
            End If
        End Set
    End Property

    Public Property HandEntryText() As String
        Get
            Return mHandEntryText
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mHandEntryText Then
                mHandEntryText = value
                PropertyHasChanged("HandEntryText")
            End If
        End Set
    End Property

    Public Property FieldName() As String Implements IHandEntry.FieldName
        Get
            Return mFieldName
        End Get
        Private Set(ByVal value As String)
            mFieldName = value
        End Set
    End Property
#End Region

#Region " Readonly Properties "

    Public ReadOnly Property SetClause() As String
        Get
            If mHandEntryText.Length = 0 Then
                Return String.Format("{0} = NULL", mFieldName)
            Else
                Return String.Format("{0} = '{1}'", mFieldName, mHandEntryText)
            End If
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewHandEntry() As HandEntry

        Return New HandEntry

    End Function

    Public Shared Function [Get](ByVal handEntryId As Integer) As HandEntry

        Return HandEntryProvider.Instance.SelectHandEntry(handEntryId)

    End Function

    Public Shared Function GetByLithoCodeId(ByVal lithoCodeId As Integer) As HandEntryCollection

        Return HandEntryProvider.Instance.SelectHandEntriesByLithoCodeId(lithoCodeId)

    End Function

    Public Shared Function GetItemNumberFromResponseValue(ByVal lithoCode As String, ByVal qstnCore As Integer, ByVal itemVal As Integer) As Integer

        Return HandEntryProvider.Instance.SelectHandEntryItemNumberFromResponseValue(lithoCode, qstnCore, itemVal)

    End Function
#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mHandEntryId
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

        HandEntryId = HandEntryProvider.Instance.InsertHandEntry(Me)

    End Sub

    Protected Overrides Sub Update()

        HandEntryProvider.Instance.UpdateHandEntry(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        HandEntryProvider.Instance.DeleteHandEntry(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


