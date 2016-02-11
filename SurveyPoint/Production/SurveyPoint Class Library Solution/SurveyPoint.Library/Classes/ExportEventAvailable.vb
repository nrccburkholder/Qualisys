Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders
Imports Nrc.Framework.BusinessLogic.Validation

Public Interface IExportEventAvailable
    Property EventID() As Integer
End Interface

''' <summary>Object Class For All Events That Are Available (which are all events)</summary>
''' <CreatedBy>Steve Kennedy</CreatedBy>
''' <RevisionList><list type="table"><listheader><term>Date - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>

<Serializable()> _
Public Class ExportEventAvailable
    Inherits BusinessBase(Of ExportEventAvailable)
    Implements IExportEventAvailable

#Region " Private Fields "

    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mEventID As Integer
    Private mName As String = String.Empty

#End Region

#Region " Public Properties "
    Public Property EventID() As Integer Implements IExportEventAvailable.EventID
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
    


#End Region

#Region " Constructors "
    Private Sub New()
        Me.CreateNew()
    End Sub
#End Region

#Region " Factory Methods "
    Public Shared Function NewExportEvent() As ExportEventAvailable
        Return New ExportEventAvailable
    End Function


    Public Shared Function GetAll() As ExportEventAvailableCollection
        Return ExportEventAvailableProvider.Instance.SelectAllExportEvents()
    End Function


    Public Shared Function [Get](ByVal eventID As Integer) As ExportEventAvailable
        Return ExportEventAvailableProvider.Instance.Get(eventID)
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


#End Region

#Region " Public Methods "


#End Region

End Class
