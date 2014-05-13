Imports Nrc.Framework.BusinessLogic

Public Interface IUploadState
    Property UploadStateId() As Integer
End Interface

''' <summary>UploadState Class maps to a row in UploadStates table and is designed
''' to keep all possible upload states values.</summary>
''' <CreateBy>Arman Mnatsakanyan</CreateBy>
''' <RevisionList><list type="table">
''' <listheader>
''' <term>Date Modified - Modified By</term>
''' <description>Description</description></listheader>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item></list></RevisionList>
<Serializable()> _
Public Class UploadState
    Inherits BusinessBase(Of UploadState)
    Implements IUploadState

    ''' <summary>Just to keep the state strings organized and to benefit the
    ''' intellisense support for available upload states</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Public Class AvailableStates
        Public Const UploadQueued As String = "UploadQueued"
        Public Const Uploading As String = "Uploading"
        Public Const Uploaded As String = "Uploaded"
        Public Const UploadAbandoned As String = "UploadAbandoned"
    End Class
#Region " Private Fields "
        <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
        Private mUploadStateId As Integer
        Private mUploadStateName As String = String.Empty
#End Region

#Region " Public Properties "
    ''' <summary>Maps UploadState_id in UploadStates Table</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property UploadStateId() As Integer Implements IUploadState.UploadStateId
            Get
                Return mUploadStateId
            End Get
            Private Set(ByVal value As Integer)
                If Not value = mUploadStateId Then
                    mUploadStateId = value
                    PropertyHasChanged("UploadStateId")
                End If
            End Set
        End Property
    ''' <summary>Maps UploadState_nm in UploadStates Table</summary>
    ''' <value></value>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Property UploadStateName() As String
            Get
                Return mUploadStateName
            End Get
            Set(ByVal value As String)
                If value Is Nothing Then value = String.Empty
                If Not value = mUploadStateName Then
                    mUploadStateName = value
                    PropertyHasChanged("UploadStateName")
                End If
            End Set
        End Property

#End Region

#Region " Constructors "
        Private Sub New()
            Me.CreateNew()
        End Sub
#End Region

#Region " Factory Methods "
        Public Shared Function NewUploadState() As UploadState
            Return New UploadState
        End Function

        Public Shared Function [Get](ByVal uploadStateId As Integer) As UploadState
            Return UploadStatesProvider.Instance.SelectUploadState(uploadStateId)
        End Function

        Public Shared Function GetAll() As UploadStateCollection
            Return UploadStatesProvider.Instance.SelectAllUploadStates()
        End Function
        Public Shared Function GetByName(ByVal name As String) As UploadState
            Return UploadStatesProvider.Instance.SelectUploadStateByName(name)
        End Function
#End Region

#Region " Basic Overrides "
        Protected Overrides Function GetIdValue() As Object
            If Me.IsNew Then
                Return mInstanceGuid
            Else
                Return mUploadStateId
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
            'UploadStateId = UploadStatesProvider.Instance.InsertUploadState(Me)
            Throw New NotImplementedException()
        End Sub

        Protected Overrides Sub Update()
            'UploadStatesProvider.Instance.UpdateUploadState(Me)
            Throw New NotImplementedException()
        End Sub

        Protected Overrides Sub DeleteImmediate()
            'UploadStatesProvider.Instance.DeleteUploadState(mUploadStateId)
            Throw New NotImplementedException()
        End Sub

#End Region

#Region " Public Methods "

#End Region

    End Class



