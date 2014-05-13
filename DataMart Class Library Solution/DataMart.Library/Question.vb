''' <summary>
''' Represents a DataMart Question
''' </summary>
''' <remarks></remarks>
<DebuggerDisplay("({Id}) {Reportlabel}")> _
Public Class Question

#Region " Private Fields "
    Private mID As Integer
    Private mReportlabel As String
    Private mFullLabel As String
    Private mScale As Scale
    Private mSurveyId As Integer
    Private mIsDirty As Boolean
    Private mIsMeanable As Boolean
    Private mMultipleResponse As Boolean
#End Region

#Region " Constructors "
    ''' <summary>
    ''' Default constructor
    ''' </summary>
    Public Sub New()
    End Sub
#End Region

#Region " Public Properties "
    ''' <summary>
    ''' Returns true if this is a multiple response question
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property MultipleResponse() As Boolean
        Get
            Return mMultipleResponse
        End Get
        Set(ByVal value As Boolean)
            mMultipleResponse = value
        End Set
    End Property

    ''' <summary>
    ''' Returns the database column name for this question (Q008180, Q012323, etc.)
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property ColumnName() As String
        Get
            Return "Q" & mID.ToString.PadLeft(6, Char.Parse("0"))
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

    ''' <summary>
    ''' Returns the Scaleid of the scale used on this Question
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public ReadOnly Property Scaleid() As Integer
        Get
            Return mScale.Id
        End Get
    End Property

    ''' <summary>
    ''' Returns True if calculating mean scores is appropriate for this question
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property IsMeanable() As Boolean
        Get
            Return mIsMeanable
        End Get
        Set(ByVal value As Boolean)
            mIsMeanable = value
        End Set
    End Property

    ''' <summary>
    ''' Returns the Survey Id that this Question is associated with
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
        End Set
    End Property

    ''' <summary>
    ''' Returns the Question Core Number
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property Id() As Integer
        Get
            Return mID
        End Get
        Friend Set(ByVal value As Integer)
            If mID <> value Then
                mID = value
                mIsDirty = True
            End If
        End Set
    End Property

    ''' <summary>
    ''' Displays the abbreviated Label used in Reporting Applications
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property ReportLabel() As String
        Get
            Return mReportlabel
        End Get
        Set(ByVal value As String)
            mReportlabel = value
            mIsDirty = True
        End Set
    End Property

    ''' <summary>
    ''' Displays the full label that displays on the printed survey
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property FullLabel() As String
        Get
            Return mFullLabel
        End Get
        Set(ByVal value As String)
            mFullLabel = value
            mIsDirty = True
        End Set
    End Property

    ''' <summary>
    ''' Returns the Scale object associated with this question
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Property Scale() As Scale
        Get
            Return mScale
        End Get
        Set(ByVal value As Scale)
            mScale = value
            mIsDirty = True
        End Set
    End Property
#End Region

#Region " DB CRUD Methods "
    ''' <summary>
    ''' Returns a collection of Questions for a specific survey
    ''' </summary>
    ''' <param name="surveyId"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetQuestionsbySurveyId(ByVal surveyId As Integer) As System.Collections.ObjectModel.Collection(Of Question)
        Return DataProvider.Instance.SelectQuestionsbySurveyId(surveyId)
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
