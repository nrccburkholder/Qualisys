Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders
Imports Nrc.Framework.BusinessLogic.Validation

Public Interface IExportEventSelected
    Property EventID() As Integer
End Interface

''' <summary>Object Class For All Events That Are Selected (both Included and Excluded events)</summary>
''' <CreatedBy>Steve Kennedy</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>


<Serializable()> _
Public Class ExportEventSelected
    Inherits BusinessBase(Of ExportEventSelected)
    Implements IExportEventSelected

#Region " Private Fields "
    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mEventID As Integer
    Private mName As String = String.Empty
    Private mDescription As String = String.Empty
    Private mEventTypeID As Integer
    Private mFinalCode As Byte
    Private mUserCreated As Byte
    Private mDefaultNonContact As Integer
    Private mIsIncluded As Integer 'Steve Kennedy - defines whether this event should be in the Included list or Excluded list.
#End Region

#Region " Public Properties "
    Public Property EventID() As Integer Implements IExportEventSelected.EventID
        Get
            Return mEventID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mEventID Then
                mEventID = value
                PropertyHasChanged("EventID")
            End If
        End Set
    End Property
    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mName Then
                mName = value
                PropertyHasChanged("Name")
            End If
        End Set
    End Property
    Protected Property Description() As String
        Get
            Return mDescription
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mDescription Then
                mDescription = value
                PropertyHasChanged("Description")
            End If
        End Set
    End Property
    Protected Property EventTypeID() As Integer
        Get
            Return mEventTypeID
        End Get
        Set(ByVal value As Integer)
            If Not value = mEventTypeID Then
                mEventTypeID = value
                PropertyHasChanged("EventTypeID")
            End If
        End Set
    End Property
    Protected Property FinalCode() As Byte
        Get
            Return mFinalCode
        End Get
        Set(ByVal value As Byte)
            If Not value = mFinalCode Then
                mFinalCode = value
                PropertyHasChanged("FinalCode")
            End If
        End Set
    End Property
    Protected Property UserCreated() As Byte
        Get
            Return mUserCreated
        End Get
        Set(ByVal value As Byte)
            If Not value = mUserCreated Then
                mUserCreated = value
                PropertyHasChanged("UserCreated")
            End If
        End Set
    End Property
    Protected Property DefaultNonContact() As Integer
        Get
            Return mDefaultNonContact
        End Get
        Set(ByVal value As Integer)
            If Not value = mDefaultNonContact Then
                mDefaultNonContact = value
                PropertyHasChanged("DefaultNonContact")
            End If
        End Set
    End Property

    ''' <summary>Defines whether this event should be in the Included list or Excluded list</summary>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Property IsIncluded() As Integer
        Get
            Return mIsIncluded
        End Get
        Set(ByVal value As Integer)
            If Not value = mIsIncluded Then
                mIsIncluded = value
                PropertyHasChanged("IsIncluded")
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
    Public Shared Function NewExportEvent() As ExportEventSelected
        Return New ExportEventSelected
    End Function

    Public Shared Function GetIncludedEvents(ByVal ExportGroupID As Integer) As ExportEventSelectedCollection
        Return ExportEventSelectedProvider.Instance.GetIncludedExportEvents(ExportGroupID)
    End Function

    Public Shared Function GetExcludedEvents(ByVal ExportGroupID As Integer) As ExportEventSelectedCollection
        Return ExportEventSelectedProvider.Instance.GetExcludedExportEvents(ExportGroupID)
    End Function

    Public Shared Function [Get](ByVal eventID As Integer) As ExportEventSelected
        Return ExportEventSelectedProvider.Instance.Get(eventID)
    End Function
#End Region

#Region " Basic Overrides "
    Protected Overrides Function GetIdValue() As Object
        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mEventID
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
    Public Overrides Sub Save()
        'MyBase.Save()
        Throw New NotImplementedException("Cannot save.  Business object doesn't represent a table of view")
    End Sub

#End Region

#Region " Public Methods "

#End Region

End Class
