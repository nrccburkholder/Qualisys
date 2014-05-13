<DebuggerDisplay("({Value}) {Label}")> _
Public Class Response

#Region " Private Fields "
    Private mLabel As String
    Private mValue As Integer
    Private mIsMissing As Boolean
    Private mOrder As Integer
    Private mIsDirty As Boolean
#End Region

#Region " Public Properties "
    ''' <summary>
    ''' The label for the response
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property Label() As String
        Get
            Return mLabel
        End Get
        Set(ByVal value As String)
            mLabel = value
            mIsDirty = True
        End Set
    End Property

    ''' <summary>
    ''' The numeric value for the response
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property Value() As Integer
        Get
            Return mValue
        End Get
        Set(ByVal value As Integer)
            mValue = value
            mIsDirty = True
        End Set
    End Property

    ''' <summary>
    ''' Indicates whether the response should be treated like a missing value when doing statistical analysis
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property IsMissing() As Boolean
        Get
            Return mIsMissing
        End Get
        Set(ByVal value As Boolean)
            mIsMissing = value
            mIsDirty = True
        End Set
    End Property

    ''' <summary>
    ''' Provides the integer order of the response
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks>The order value is needed to help identify which response is the best and which is the worst.</remarks>
    Public Property Order() As Integer
        Get
            Return mOrder
        End Get
        Set(ByVal value As Integer)
            mOrder = value
            mIsDirty = True
        End Set
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
    ''' Gets all responses for a scale
    ''' </summary>
    ''' <param name="scaleid"></param>
    ''' <param name="surveyId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetResponses(ByVal scaleid As Integer, ByVal surveyId As Integer) As System.Collections.ObjectModel.Collection(Of Response)
        Return DataProvider.Instance.SelectResponsesbySurveyIdandScaleId(surveyId, scaleid)
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
