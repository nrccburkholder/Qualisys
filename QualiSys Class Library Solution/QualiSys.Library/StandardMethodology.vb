Imports Nrc.QualiSys.Library.DataProvider

''' <summary>
''' Represents a Qualisys Standard Methodology for survey data collection
''' </summary>
Public Class StandardMethodology

#Region " Private Fields "
    Private mId As Integer
    Private mName As String
    Private mIsCustomizable As Boolean
    Private mIsExpired As Boolean
#End Region

#Region " Public Properties "
    ''' <summary>The unique identifier of the Standard Methodology</summary>
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Friend Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    ''' <summary>The name of the Standard Methodology</summary>
    Public Property Name() As String
        Get
            Return mName
        End Get
        Friend Set(ByVal value As String)
            mName = value
        End Set
    End Property

    ''' <summary>Returns True if the Standard Methodology can be customized by adding/modifying steps</summary>
    Public Property IsCustomizable() As Boolean
        Get
            Return mIsCustomizable
        End Get
        Set(ByVal value As Boolean)
            mIsCustomizable = value
        End Set
    End Property

    Public Property IsExpired() As Boolean
        Get
            Return mIsExpired
        End Get
        Set(value As Boolean)
            mIsExpired = value
        End Set
    End Property

    Public ReadOnly Property DisplayName() As String
        Get
            Return CStr(IIf(mIsExpired, String.Format("{0} {1}", mName, "(expired)"), mName))
        End Get
      
    End Property

#End Region

#Region " Constructors "
    Friend Sub New()
    End Sub

#End Region

#Region " Public Methods "
    ''' <summary>
    ''' Retrieves a single Standard Methodology object
    ''' </summary>
    ''' <param name="standardMethodologyId">The unique identifier of the Standard Methodolgy</param>
    Public Shared Function [Get](ByVal standardMethodologyId As Integer) As StandardMethodology
        Return MethodologyProvider.Instance.SelectStandardMethodology(standardMethodologyId)
    End Function
    ''' <summary>
    ''' Retrieves a collection of all the Standard Methodologies for a given Survey Type
    ''' </summary>
    ''' <param name="srvyType">The Survey Type</param>
    ''' <returns></returns>
    Public Shared Function GetBySurveyType(ByVal srvyType As SurveyTypes, ByVal subTypes As SubTypeList) As Collection(Of StandardMethodology)

        Dim SubType As SubType = New SubType(0, "", False)

        If (Not subTypes Is Nothing) Then
            For Each st As SubType In subTypes
                If st.IsRuleOverride Then
                    SubType = st
                End If
            Next
        End If


        Return MethodologyProvider.Instance.SelectStandardMethodologiesBySurveyType(srvyType, SubType)
    End Function


    ''' <summary>
    ''' Returns a collection of MethodologySteps built from this Standard Methodology
    ''' </summary>
    Public Function GetMethodologySteps() As MethodologyStepCollection
        Return MethodologyProvider.Instance.SelectStandardMethodologySteps(mId)
    End Function

#End Region

End Class
