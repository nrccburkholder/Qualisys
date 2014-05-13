Imports nrc.Qualisys.QualisysDataEntry.Library.DbHelper
Imports System.Data.SqlClient

''' -----------------------------------------------------------------------------
''' Project	 : QDEClasses
''' Class	 : QDEClasses.Comment
''' 
''' -----------------------------------------------------------------------------
''' <summary>
''' Represents a respondant comment and a record in the QDEComment table.
''' </summary>
''' <remarks>
''' </remarks>
''' <history>
''' 	[JCamp]	7/30/2004	Created
''' </history>
''' -----------------------------------------------------------------------------
Public Class Comment

#Region " Private Members "
    'Database fields
    Private mCmntID As Integer
    Private mQstnCore As Integer
    Private mSampleUnitID As Integer
    Private mQuestionText As String
    Private mOriginalText As String     'Copy of the CommentText field
    Private mCommentText As String
    Private mOriginalTypeID As Integer
    Private mCommentTypeID As Integer
    Private mOriginalValenceID As Integer
    Private mCommentValenceID As Integer
    Private mDateKeyed As DateTime
    Private mKeyedBy As String
    Private mDateKeyVerified As DateTime
    Private mKeyVerifiedBy As String
    Private mDateCoded As DateTime
    Private mCodedBy As String
    Private mDateCodeVerified As DateTime
    Private mCodeVerifiedBy As String
    Private mDateHandEntered As DateTime
    Private mHandEnteredBy As String
    Private mDateHandEntryVerified As DateTime
    Private mHandEntryVerifiedBy As String

    'Child Code Records
    Private mCommentCodes As New SortedList
    Private mOriginalCodes As New SortedList

    'Cached data sets
    Private Shared mCommentTypes As DataTable
    Private Shared mCommentValences As DataTable
#End Region

#Region " Public Properties "

    ''' <summary>The comment question core.</summary>
    Public ReadOnly Property QstnCore() As Integer
        Get
            Return mQstnCore
        End Get
    End Property

    ''' <summary>The question text for the comment box.</summary>
    Public Property QuestionText() As String
        Get
            Return mQuestionText
        End Get
        Set(ByVal Value As String)
            mQuestionText = Value
        End Set
    End Property

    ''' <summary>The response text of the comment.</summary>
    Public Property CommentText() As String
        Get
            Return mCommentText
        End Get
        Set(ByVal Value As String)
            mCommentText = Value
        End Set
    End Property

    Public Property CommentTypeID() As Integer
        Get
            Return mCommentTypeID
        End Get
        Set(ByVal Value As Integer)
            mCommentTypeID = Value
        End Set
    End Property

    Public Property CommentValenceID() As Integer
        Get
            Return mCommentValenceID
        End Get
        Set(ByVal Value As Integer)
            mCommentValenceID = Value
        End Set
    End Property

    ''' <summary>The date the comment was keyed.</summary>
    Public Property DateKeyed() As DateTime
        Get
            Return mDateKeyed
        End Get
        Set(ByVal value As DateTime)
            mDateKeyed = value
        End Set
    End Property

    ''' <summary>The username of the person who keyed the comment.</summary>
    Public Property KeyedBy() As String
        Get
            Return mKeyedBy
        End Get
        Set(ByVal Value As String)
            mKeyedBy = Value
        End Set
    End Property

    ''' <summary>The date the comment was key verified.</summary>
    Public Property DateKeyVerified() As DateTime
        Get
            Return mDateKeyVerified
        End Get
        Set(ByVal value As DateTime)
            mDateKeyVerified = value
        End Set
    End Property

    ''' <summary>The username of the person key key verified the comment.</summary>
    Public Property KeyVerifiedBy() As String
        Get
            Return mKeyVerifiedBy
        End Get
        Set(ByVal Value As String)
            mKeyVerifiedBy = Value
        End Set
    End Property

    ''' <summary>The date the comment was coded.</summary>
    Public Property DateCoded() As DateTime
        Get
            Return mDateCoded
        End Get
        Set(ByVal value As DateTime)
            mDateCoded = value
        End Set
    End Property

    ''' <summary>The username of the person who coded the comment.</summary>
    Public Property CodedBy() As String
        Get
            Return mCodedBy
        End Get
        Set(ByVal Value As String)
            mCodedBy = Value
        End Set
    End Property

    ''' <summary>The date the comment was code verified.</summary>
    Public Property DateCodeVerified() As DateTime
        Get
            Return mDateCodeVerified
        End Get
        Set(ByVal value As DateTime)
            mDateCodeVerified = value
        End Set
    End Property

    ''' <summary>The username of the person who code verified the comment.</summary>
    Public Property CodeVerifiedBy() As String
        Get
            Return mCodeVerifiedBy
        End Get
        Set(ByVal Value As String)
            mCodeVerifiedBy = Value
        End Set
    End Property

    ''' <summary>Returns True if the comment data has changed since loaded from the database.</summary>
    Public ReadOnly Property HasCommentChanged() As Boolean
        Get
            Return CommentTextChanged OrElse CodesChanged
        End Get
    End Property

    ''' <summary>Returns a sorted list of comment codes that are assigned to the comment.</summary>
    Public ReadOnly Property Codes() As SortedList
        Get
            Return mCommentCodes
        End Get
    End Property

    '''<summary>Returns a comma delimited string of CodeIDs that have been assigned to this comment</summary>
    Public ReadOnly Property CodeList() As String
        Get
            Dim codeIDs As String
            Dim values(mCommentCodes.Count - 1) As String
            Dim i As Integer
            For i = 0 To mCommentCodes.Count - 1
                values(i) = mCommentCodes.GetByIndex(i).ToString
            Next
            codeIDs = String.Join(",", values)

            Return codeIDs
        End Get
    End Property

    '''<summary>Returns a cached dataTable containing all the comment types</summary>
    Public Shared ReadOnly Property CommentTypes() As DataTable
        Get
            If mCommentTypes Is Nothing Then
                mCommentTypes = ExecuteDataset("SP_QDE_SelectCommentTypes").Tables(0)
            End If

            Return mCommentTypes
        End Get
    End Property

    '''<summary>Returns a cached dataTable containing all the comment valences</summary>
    Public Shared ReadOnly Property CommentValences() As DataTable
        Get
            If mCommentValences Is Nothing Then
                mCommentValences = ExecuteDataset("SP_QDE_SelectCommentValences").Tables(0)
            End If

            Return mCommentValences
        End Get
    End Property

#End Region

#Region " Private Properties "

    ''' <summary>Returns True if the CommentText field has changed since loaded from the database.</summary>
    Private ReadOnly Property CommentTextChanged() As Boolean
        Get
            Return Not (mOriginalText = mCommentText)
        End Get
    End Property

    ''' <summary>Returns True if the comment codes have changed since loaded from the database.</summary>
    Private ReadOnly Property CodesChanged() As Boolean
        Get
            Dim i As Integer
            'If the type or valence has changed then return TRUE
            If Not mCommentTypeID = mOriginalTypeID Then
                Return True
            End If
            If Not mCommentValenceID = mOriginalValenceID Then
                Return True
            End If

            'If the code count has changed return TRUE
            If Not mCommentCodes.Count = mOriginalCodes.Count Then
                Return True
            Else
                'Check each code to make sure it matches (they should be in same order since sortedlist)
                For i = 0 To mCommentCodes.Count - 1
                    If Not CType(mCommentCodes.GetByIndex(i), Integer) = CType(mOriginalCodes.GetByIndex(i), Integer) Then
                        Return True
                    End If
                Next
                Return False
            End If
        End Get
    End Property

  
#End Region

#Region " Constructors "
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Default constructor
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/30/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Sub New()

    End Sub

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Constructor to initialize object from the database.
    ''' </summary>
    ''' <param name="dbData">The datarow object that represents the database record.</param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/30/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Friend Sub New(ByVal dbData As DataRow)
        Dim row As DataRow
        Dim codesTable As DataTable

        If dbData Is Nothing Then
            Throw New ArgumentNullException("dbData")
        End If

        mCmntID = CType(dbData("Cmnt_id"), Integer)
        mQstnCore = CType(dbData("QstnCore"), Integer)
        mSampleUnitID = CType(dbData("SampleUnit_id"), Integer)
        mQuestionText = dbData("strQuestionText").ToString
        mOriginalText = dbData("strCmntText").ToString
        mCommentText = dbData("strCmntText").ToString
        mCommentTypeID = CheckNull(Of Integer)(dbData("CmntType_id"), -1)
        mOriginalTypeID = CheckNull(Of Integer)(dbData("CmntType_id"), -1)
        mCommentValenceID = CheckNull(Of Integer)(dbData("CmntValence_id"), -1)
        mOriginalValenceID = CheckNull(Of Integer)(dbData("CmntValence_id"), -1)
        mDateKeyed = CheckNull(Of Date)(dbData("datKeyed"), DateTime.MinValue)
        mKeyedBy = dbData("strKeyedBy").ToString
        mDateKeyVerified = CheckNull(Of Date)(dbData("datKeyVerified"), DateTime.MinValue)
        mKeyVerifiedBy = dbData("strKeyVerifiedBy").ToString
        mDateCoded = CheckNull(Of Date)(dbData("datCoded"), DateTime.MinValue)
        mCodedBy = dbData("strCodedBy").ToString
        mDateCodeVerified = CheckNull(Of Date)(dbData("datCodeVerified"), DateTime.MinValue)
        mCodeVerifiedBy = dbData("strCodeVerifiedBy").ToString

        'TODO:  Add hand entry fields once they are in the database
        mDateHandEntered = DateTime.MinValue
        mHandEnteredBy = ""
        mDateHandEntryVerified = DateTime.MinValue
        mHandEntryVerifiedBy = ""

        'Now we need to load up the comment codes
        codesTable = ExecuteDataset("SP_QDE_SelectCommentCodes", mCmntID).Tables(0)
        For Each row In codesTable.Rows
            mCommentCodes.Add(row("CmntCode_id"), row("CmntCode_id"))
            mOriginalCodes.Add(row("CmntCode_id"), row("CmntCode_id"))
        Next
    End Sub

#End Region

#Region " Public Methods "
    Public Sub ResetData()
        mCommentText = mOriginalText
        mCommentTypeID = mOriginalTypeID
        mCommentValenceID = mOriginalTypeID
        mCommentCodes = DirectCast(mOriginalCodes.Clone, SortedList)

    End Sub
#Region " DB CRUD Methods "
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Updates the database with the data from this object instance.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/30/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub UpdateDB()
        'Define all the parameters
        Dim params(11) As Object
        params(0) = mCmntID
        params(1) = IIf(mCommentText.Length > 0, mCommentText, DBNull.Value)
        params(2) = IIf(mCommentTypeID < 1, DBNull.Value, mCommentTypeID)
        params(3) = IIf(mCommentValenceID < 1, DBNull.Value, mCommentValenceID)

        params(4) = IIf(mDateKeyed = DateTime.MinValue, DBNull.Value, mDateKeyed)
        params(5) = IIf(mKeyedBy.Length > 0, mKeyedBy, DBNull.Value)

        params(6) = IIf(mDateKeyVerified = DateTime.MinValue, DBNull.Value, mDateKeyVerified)
        params(7) = IIf(mKeyVerifiedBy.Length > 0, mKeyVerifiedBy, DBNull.Value)

        params(8) = IIf(mDateCoded = DateTime.MinValue, DBNull.Value, mDateCoded)
        params(9) = IIf(mCodedBy.Length > 0, mCodedBy, DBNull.Value)

        params(10) = IIf(mDateCodeVerified = DateTime.MinValue, DBNull.Value, mDateCodeVerified)
        params(11) = IIf(mCodeVerifiedBy.Length > 0, mCodeVerifiedBy, DBNull.Value)

        'Execute the SP
        ExecuteNonQuery("SP_QDE_UpdateComment", params)

        'If the comment codes have changed then update them, otherwise don't bother...
        If CodesChanged Then
            'Execute the SP
            ExecuteNonQuery("SP_QDE_UpdateCommentCodes", mCmntID, CodeList)
        End If
    End Sub

    'Enters the data for a comment as it is imported from a file
    Public Shared Sub ImportCommentData(ByVal batchID As Integer, ByVal lithoCode As String, ByVal qstnCore As Integer, ByVal commentText As String)
        Dim params(3) As Object
        params(0) = batchID
        params(1) = lithoCode
        params(2) = qstnCore
        params(3) = commentText
        ExecuteNonQuery("SP_QDE_ImportCommentData", params)
    End Sub

#End Region

#End Region

End Class
