<DebuggerDisplay("({Id}) {SurveyId}")> _
Public Class Scale

#Region " Private Fields "
    Private mId As Integer
    Private mSurveyId As Integer
    Private mMaxScaleOrder As Integer
    Private mResponses As New System.Collections.ObjectModel.Collection(Of Response)
    Private mIsDirty As Boolean
#End Region

#Region " Public Properties "
    ''' <summary>
    ''' Id for this scale
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            If mId <> value Then
                mId = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' Each scale has an ordering of its responses.  The max scale order is the largest order that exists for this scale
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property MaxScaleOrder() As Integer
        Get
            Return mMaxScaleOrder
        End Get
        Set(ByVal value As Integer)
            mMaxScaleOrder = value
            mIsDirty = True
        End Set
    End Property

    ''' <summary>
    ''' ID for the survey that this scale belongs to
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Set(ByVal value As Integer)
            mSurveyId = value
            mIsDirty = True
        End Set
    End Property

    ''' <summary>
    ''' Collection of the responses that are part of this scale
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property Responses() As System.Collections.ObjectModel.Collection(Of Response)
        Get
            Return mResponses
        End Get
    End Property

    ''' <summary>
    ''' Returns true if the object has been modified since it was retrieved from the data store.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property IsDirty() As Boolean
        Get
            Return mIsDirty
        End Get
        Set(ByVal value As Boolean)
            mIsDirty = value
        End Set
    End Property
#End Region

#Region " CRUD Methods "
    ''' <summary>
    ''' Gets a scale object for the specified ID and survey ID
    ''' </summary>
    ''' <param name="scaleId"></param>
    ''' <param name="surveyId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetScale(ByVal scaleId As Integer, ByVal surveyId As Integer) As Scale
        Return DataProvider.Instance.SelectScalebySurveyIdandScaleId(surveyId, scaleId)
    End Function
#End Region

#Region " Public Methods "
    ''' <summary>
    ''' Resets the flag to indicate that the object is not different from the copy in the data store
    ''' </summary>
    ''' <remarks></remarks>     
    Public Sub ResetDirtyFlag()
        Me.mIsDirty = False
    End Sub
#End Region

End Class
