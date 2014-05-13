Imports NRC.Framework.BusinessLogic

Public Interface IDataFileState

    Property Id() As Integer

End Interface

<Serializable()> _
Public Class DataFileState
	Inherits BusinessBase(Of DataFileState)
	Implements IDataFileState

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mId As Integer
    Private mDataFileId As Integer
    Private mStateId As Integer
    Private mdatOccurred As Date
    Private mStateParameter As String = String.Empty

#End Region

#Region " Public Properties "

    Public Property Id() As Integer Implements IDataFileState.Id
        Get
            Return mId
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mId Then
                mId = value
                PropertyHasChanged("Id")
            End If
        End Set
    End Property

    Public Property DataFileId() As Integer
        Get
            Return mDataFileId
        End Get
        Set(ByVal value As Integer)
            If Not value = mDataFileId Then
                mDataFileId = value
                PropertyHasChanged("DataFileId")
            End If
        End Set
    End Property

    Public Property StateId() As Integer
        Get
            Return mStateId
        End Get
        Set(ByVal value As Integer)
            If Not value = mStateId Then
                mStateId = value
                PropertyHasChanged("StateId")
            End If
        End Set
    End Property

    Public Property datOccurred() As Date
        Get
            Return mdatOccurred
        End Get
        Set(ByVal value As Date)
            If Not value = mdatOccurred Then
                mdatOccurred = value
                PropertyHasChanged("datOccurred")
            End If
        End Set
    End Property

    Public Property StateParameter() As String
        Get
            Return mStateParameter
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mStateParameter Then
                mStateParameter = value
                PropertyHasChanged("StateParameter")
            End If
        End Set
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Public Shared Function NewDataFileState() As DataFileState

        Return New DataFileState

    End Function

    Public Shared Function [Get](ByVal id As Integer) As DataFileState

        Return DataFileStateProvider.Instance.SelectDataFileState(id)

    End Function

    Public Shared Function GetAll() As DataFileStateCollection

        Return DataFileStateProvider.Instance.SelectAllDataFileStates()

    End Function

    Public Shared Function GetByDataFileId(ByVal dataFileId As Integer) As DataFileStateCollection

        Return DataFileStateProvider.Instance.SelectDataFileStatesByDataFileId(dataFileId)

    End Function

    Public Shared Function GetByStateId(ByVal stateId As Integer) As DataFileStateCollection

        Return DataFileStateProvider.Instance.SelectDataFileStatesByStateId(stateId)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mId
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

        Id = DataFileStateProvider.Instance.InsertDataFileState(Me)

    End Sub

    Protected Overrides Sub Update()

        DataFileStateProvider.Instance.UpdateDataFileState(Me)

    End Sub

    Protected Overrides Sub DeleteImmediate()

        DataFileStateProvider.Instance.DeleteDataFileState(Me)

    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class


