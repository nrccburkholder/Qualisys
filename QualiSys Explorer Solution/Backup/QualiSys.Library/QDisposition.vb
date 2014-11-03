Imports Nrc.QualiSys.Library.DataProvider

''' <summary>
''' Represents a disposition that a respondant can specify when they make 
''' a request through the Survey Preferences Application or call a 1-800 number.
''' </summary>
<Serializable()> _
Public Class QDisposition
    Implements IComparable

#Region " Private Members "

#Region " Persisted Fields "

    Private mName As String
    Private mId As Integer
    Private mActionId As DispositionAction

#End Region

#End Region

#Region " Public Properties "

#Region " Persisted Properties "

    ''' <summary>
    ''' The name of this disposition
    ''' </summary>
    Public Property Name() As String
        Get
            Return mName
        End Get
        Friend Set(ByVal value As String)
            mName = value
        End Set
    End Property

    ''' <summary>
    ''' The disposition ID
    ''' </summary>
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    ''' <summary>
    ''' The action to be taken when this disposition is selected
    ''' </summary>
    Public Property Action() As DispositionAction
        Get
            Return mActionId
        End Get
        Friend Set(ByVal value As DispositionAction)
            mActionId = value
        End Set
    End Property

    ''' <summary>
    ''' The category that this disposition's action fall under.
    ''' </summary>
    Public ReadOnly Property ActionCategory() As String
        Get
            Return GetCategory(Me.Action)
        End Get
    End Property

    Private ReadOnly Property CategoryOrder() As Integer
        Get
            Return GetCategoryOrder(Me.Action)
        End Get
    End Property

#End Region

#End Region

#Region " Constructors "

    ''' <summary>
    ''' Default constructor.
    ''' </summary>
    Public Sub New()

    End Sub

#End Region

#Region " Private Methods "

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Converts an ActionId to a category string
    ''' </summary>
    ''' <param name="action"></param>
    ''' <returns></returns>
    ''' <remarks>This is just a hard-coded list of values.
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	12/10/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Private Shared Function GetCategory(ByVal action As DispositionAction) As String

        Select Case action
            Case DispositionAction.Tocl, DispositionAction.CancelMailings
                Return "My Participation"

            Case DispositionAction.Regenerate, DispositionAction.RegenerateNewLang
                Return "Survey Request"

            Case DispositionAction.ChangeOfAddress
                Return "Change of Address"

            Case DispositionAction.ContactTeam
                Return "Contact"

            Case Else
                Throw New ArgumentOutOfRangeException("action")

        End Select

    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Converts an actionId to a category order
    ''' </summary>
    ''' <param name="action"></param>
    ''' <returns></returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	12/10/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Private Shared Function GetCategoryOrder(ByVal action As DispositionAction) As Integer

        Select Case action
            Case DispositionAction.Tocl, DispositionAction.CancelMailings
                Return 1

            Case DispositionAction.Regenerate, DispositionAction.RegenerateNewLang
                Return 2

            Case DispositionAction.ChangeOfAddress
                Return 3

            Case DispositionAction.ContactTeam
                Return 4

        End Select

    End Function

#End Region

#Region " DB CRUD Methods "

    Public Shared Function [Get](ByVal dispositionId As Integer) As QDisposition

        Return QDispositionProvider.Instance.Select(dispositionId)

    End Function

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Returns a collection of available dispositions for this mailing.
    ''' </summary>
    ''' <param name="surveyId">The QualiSys Survey_id</param>
    ''' <returns>A DispositionCollection containing all the dispositions</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	09/22/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Shared Function GetDispositionsBySurvey(ByVal surveyId As Integer) As QDispositionCollection

        Dim list As QDispositionCollection = QDispositionProvider.Instance.SelectBySurveyId(surveyId)
        list.Sort()
        Return list

    End Function
#End Region

#Region " Public Methods "

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Implementation of IComparable.CompareTo so that these objects can be sorted
    ''' in Category,DispositionId order
    ''' </summary>
    ''' <param name="obj">The object that will be compared to this one</param>
    ''' <returns>
    ''' 1 if this is "greater than" obj
    ''' 0 if the two objects are equal
    ''' -1 if this is "less than" obj
    ''' </returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	12/10/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Function CompareTo(ByVal obj As Object) As Integer Implements System.IComparable.CompareTo

        If obj Is Nothing Then
            Throw New ArgumentNullException("obj")
        End If

        'Throw an exception if we are trying to compare to an object other than disposition
        If Not GetType(QDisposition) Is obj.GetType Then
            Throw New ArgumentException("Disposition objects can only be compared to Disposition objects.")
        End If
        Dim dispo As QDisposition = DirectCast(obj, QDisposition)

        'If MY category is greater then the other return 1
        If Me.CategoryOrder > dispo.CategoryOrder Then
            Return 1
        ElseIf Me.CategoryOrder = dispo.CategoryOrder Then
            'If MY category is the same as the other then check which dispositionId is greater
            If Me.mId > dispo.mId Then
                Return 1
            Else
                Return -1
            End If
        Else    'If MY category is less then the other return -1
            Return -1
        End If

    End Function

    Public Overrides Function Equals(ByVal obj As Object) As Boolean

        Dim dispo As QDisposition = TryCast(obj, QDisposition)
        If dispo Is Nothing Then
            Return False
        End If

        Return Me.mId = dispo.mId

    End Function

    Public Overrides Function GetHashCode() As Integer

        Return mId

    End Function

    Public Overloads Shared Operator =(ByVal objA As QDisposition, ByVal objB As QDisposition) As Boolean

        If objA Is Nothing Then
            Throw New ArgumentNullException("objA")
        End If
        Return objA.Equals(objB)

    End Operator

    Public Overloads Shared Operator <>(ByVal objA As QDisposition, ByVal objB As QDisposition) As Boolean

        If objA Is Nothing Then
            Throw New ArgumentNullException("objA")
        End If
        Return Not objA.Equals(objB)

    End Operator

    Public Overloads Shared Operator >(ByVal objA As QDisposition, ByVal objB As QDisposition) As Boolean

        If objA Is Nothing Then
            Throw New ArgumentNullException("objA")
        End If
        Return (objA.CompareTo(objB) > 0)

    End Operator

    Public Overloads Shared Operator <(ByVal objA As QDisposition, ByVal objB As QDisposition) As Boolean

        If objA Is Nothing Then
            Throw New ArgumentNullException("objA")
        End If
        Return (objA.CompareTo(objB) < 0)

    End Operator

#End Region

End Class

