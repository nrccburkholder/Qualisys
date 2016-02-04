Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders
Imports System.Collections.ObjectModel

Public Interface IUpdateMapping
    Property UpdateMappingID() As Integer
End Interface

Public Class UpdateMapping
    Inherits BusinessBase(Of UpdateMapping)
    Implements IUpdateMapping

#Region " Private Fields "

    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mUpdateMappingID As Integer
    Private mUpdateTypeID As Integer
    Private mOldEventID As Integer
    Private mNewEventID As Integer
    Private mOrder As Integer
    Private mEventType As EventTypesEnum

#End Region

#Region " Public Properties "

    Public Property UpdateMappingID() As Integer Implements IUpdateMapping.UpdateMappingID
        Get
            Return mUpdateMappingID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mUpdateMappingID Then
                mUpdateMappingID = value
                PropertyHasChanged("UpdateMappingID")
            End If
        End Set
    End Property

    Public Property UpdateTypeID() As Integer
        Get
            Return mUpdateTypeID
        End Get
        Set(ByVal value As Integer)
            If Not value = mUpdateTypeID Then
                mUpdateTypeID = value
                PropertyHasChanged("UpdateTypeID")
            End If
        End Set
    End Property

    Public Property OldEventID() As Integer
        Get
            Return mOldEventID
        End Get
        Set(ByVal value As Integer)
            If Not value = mOldEventID Then
                mOldEventID = value
                PropertyHasChanged("OldEventID")
            End If
        End Set
    End Property

    Public Property NewEventID() As Integer
        Get
            Return mNewEventID
        End Get
        Set(ByVal value As Integer)
            If Not value = mNewEventID Then
                mNewEventID = value
                PropertyHasChanged("NewEventID")
            End If
        End Set
    End Property

    Public Property Order() As Integer
        Get
            Return mOrder
        End Get
        Set(ByVal value As Integer)
            If Not value = mOrder Then
                mOrder = value
                PropertyHasChanged("Order")
            End If
        End Set
    End Property

    Public Property EventType() As EventTypesEnum
        Get
            Return mEventType
        End Get
        Set(ByVal value As EventTypesEnum)
            If Not value = mEventType Then
                mEventType = value
                PropertyHasChanged("EventType")
            End If
        End Set
    End Property

    Public ReadOnly Property CompleteString() As String
        Get
            Dim ret As String = String.Empty

            Select Case mEventType
                Case EventTypesEnum.Incomplete
                    Return "Incomplete"
                Case EventTypesEnum.Complete
                    Return "Complete"
                Case EventTypesEnum.Both
                    Return "Both"
                Case Else
                    Return "Undefined"
            End Select
        End Get
    End Property
#End Region

#Region " Constructors "

    Private Sub New()

        Me.CreateNew()

    End Sub
#End Region

#Region " Factory Methods "

    Public Shared Function NewUpdateMapping() As UpdateMapping

        Return New UpdateMapping

    End Function

    Private Shared Function GetByUpdateTypeID(ByVal updateTypeID As Integer) As UpdateMappingCollection

        Return UpdateMappingProvider.Instance.SelectByUpdateTypeID(updateTypeID)

    End Function

    Public Shared Function GetByUpdateTypeIDEventType(ByVal updateTypeID As Integer, ByVal eventType As EventTypesEnum) As UpdateMappingCollection

        Dim allMappings As UpdateMappingCollection = GetByUpdateTypeID(updateTypeID)

        If eventType = EventTypesEnum.Both Then
            Return allMappings
        Else
            Dim mappings As New UpdateMappingCollection

            For Each mapping As UpdateMapping In allMappings
                If mapping.EventType = eventType Then
                    mappings.Add(mapping)
                End If
            Next

            Return mappings
        End If

    End Function
#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mUpdateMappingID
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

    Public Shared Function GetEventTypes() As Collection(Of ListItem(Of EventTypesEnum))

        Dim eventTypes As New Collection(Of ListItem(Of EventTypesEnum))

        eventTypes.Add(New ListItem(Of EventTypesEnum)("Both", EventTypesEnum.Both))
        eventTypes.Add(New ListItem(Of EventTypesEnum)("Complete", EventTypesEnum.Complete))
        eventTypes.Add(New ListItem(Of EventTypesEnum)("Incomplete", EventTypesEnum.Incomplete))

        Return eventTypes

    End Function
#End Region

End Class
