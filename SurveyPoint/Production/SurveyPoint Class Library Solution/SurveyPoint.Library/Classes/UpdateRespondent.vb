Imports Nrc.Framework.BusinessLogic
Imports Nrc.SurveyPoint.Library.DataProviders

Public Interface IUpdateRespondent
    Property RespondentID() As Integer
End Interface

Public Class UpdateRespondent
    Inherits BusinessBase(Of UpdateRespondent)
    Implements IUpdateRespondent

#Region " Private Fields "

    <NotUndoable()> Private mInstanceGuid As Guid = Guid.NewGuid
    Private mRespondentID As Integer
    Private mFirstName As String = String.Empty
    Private mLastName As String = String.Empty
    Private mOldEventCode As Integer
    Private mNewEventCode As Integer
    Private mStatus As RespondentStatusTypes = RespondentStatusTypes.CanUpdate

#End Region

#Region " Public Properties "

    Public Property RespondentID() As Integer Implements IUpdateRespondent.RespondentID
        Get
            Return mRespondentID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mRespondentID Then
                mRespondentID = value
                PropertyHasChanged("RespondentID")
            End If
        End Set
    End Property

    Public Property FirstName() As String
        Get
            Return mFirstName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mFirstName Then
                mFirstName = value
                PropertyHasChanged("FirstName")
            End If
        End Set
    End Property

    Public Property LastName() As String
        Get
            Return mLastName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mLastName Then
                mLastName = value
                PropertyHasChanged("LastName")
            End If
        End Set
    End Property

    Public Property Status() As RespondentStatusTypes
        Get
            Return mStatus
        End Get
        Set(ByVal value As RespondentStatusTypes)
            If Not value = mStatus Then
                mStatus = value
                PropertyHasChanged("Status")
            End If
        End Set
    End Property

    Public ReadOnly Property StatusString() As String
        Get
            Select Case mStatus
                Case RespondentStatusTypes.CanUpdate
                    Return "Ready to Update"

                Case RespondentStatusTypes.AlreadyProcessed
                    Return "Respondent Already Processed, No Action Taken"

                Case RespondentStatusTypes.StartCodesMissing
                    Return "Respondent Missing Necessary BatchingCodes, No Action Taken"

                Case RespondentStatusTypes.Updated
                    Return String.Format("Event Code {0} Converted To {1}", mOldEventCode.ToString, mNewEventCode.ToString)

                Case RespondentStatusTypes.NotUpdated
                    Return "Existing Event Code Does Not Match Any Old Event Codes"

                Case RespondentStatusTypes.InsertedMissingCode
                    Return "Added Event Code 3010"

                Case RespondentStatusTypes.InsertedMissingCodeUpdated
                    Return String.Format("Added Event Code 3010{0}Event Code {1} Converted To {2}", vbCrLf, mOldEventCode.ToString, mNewEventCode.ToString)

                Case RespondentStatusTypes.InsertedMissingCodeNotUpdated
                    Return String.Format("Added Event Code 3010{0}Existing Event Code Does Not Match Any Old Event Codes", vbCrLf)

                Case Else
                    Return String.Empty

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

    Public Shared Function NewUpdateRespondent() As UpdateRespondent

        Return New UpdateRespondent

    End Function

    Public Shared Function NewUpdateRespondent(ByVal respID As Integer) As UpdateRespondent

        Dim resp As New UpdateRespondent
        resp.RespondentID = respID
        Return resp

    End Function

    Public Shared Function [Get](ByVal respID As Integer) As UpdateRespondent

        Return UpdateRespondentProvider.Instance.Select(respID)

    End Function

    Public Shared Function GetByAlreadyUpdated(ByVal respondentIDs As String) As UpdateRespondentCollection

        Return UpdateRespondentProvider.Instance.SelectByAlreadyUpdated(respondentIDs)

    End Function

    Public Shared Function GetByMissingStartCodes(ByVal respondentIDs As String, ByVal importDate As Date) As UpdateRespondentCollection

        Return UpdateRespondentProvider.Instance.SelectByMissingStartCodes(respondentIDs, importDate)

    End Function

    Public Shared Function UpdateMissingEventCodes(ByVal respondentIDs As String) As UpdateRespondentCollection

        Return UpdateRespondentProvider.Instance.UpdateMissingEventCodes(respondentIDs)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If Me.IsNew Then
            Return mInstanceGuid
        Else
            Return mRespondentID
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

    Public Function UpdateMapping(ByVal oldEventCode As Integer, ByVal newEventCode As Integer) As Boolean

        Dim qtyUpdated As Integer = UpdateRespondentProvider.Instance.UpdateMapping(mRespondentID, oldEventCode, newEventCode)
        If qtyUpdated > 0 Then
            mOldEventCode = oldEventCode
            mNewEventCode = newEventCode
        End If

        Return (qtyUpdated > 0)

    End Function

    Public Sub PopulateName()

        Dim resp As UpdateRespondent = UpdateRespondent.Get(mRespondentID)
        FirstName = resp.FirstName
        LastName = resp.LastName

    End Sub

#End Region

End Class



