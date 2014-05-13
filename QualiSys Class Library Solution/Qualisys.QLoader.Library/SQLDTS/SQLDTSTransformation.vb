Public Class SQLDTSTransformation
    Private mSourceColumns As New ColumnCollection
    Private mDestColumns As New ColumnCollection
    Private mMainScriptCommands As New ArrayList
    Private mFunctions As New ArrayList
    Private mName As String

#Region " Public Properties "
    Public Property Name() As String
        Get
            Return Me.mName
        End Get
        Set(ByVal Value As String)
            Me.mName = Value
        End Set
    End Property
    Public Property SourceColumns() As ColumnCollection
        Get
            Return Me.mSourceColumns
        End Get
        Set(ByVal Value As ColumnCollection)
            Me.mSourceColumns = Value
        End Set
    End Property
    Public Property DestColumns() As ColumnCollection
        Get
            Return Me.mDestColumns
        End Get
        Set(ByVal Value As ColumnCollection)
            Me.mDestColumns = Value
        End Set
    End Property

#End Region

    'Constructor
    Public Sub New(ByVal transformationName As String)
        Me.mName = transformationName
    End Sub

    Public Function GetScript() As String
        Dim strMainScript As String = ""

        strMainScript &= "Function Main()" & vbCrLf

        '... Each function goes here
        Dim command As String
        For Each command In Me.mMainScriptCommands
            strMainScript &= command & vbCrLf
        Next

        strMainScript &= "Main = DTSTransformStat_OK" & vbCrLf
        strMainScript &= "End Function" & vbCrLf & vbCrLf

        strMainScript &= "'Misc. Functions" & vbCrLf & vbCrLf

        Dim func As String
        For Each func In Me.mFunctions
            strMainScript &= func & vbCrLf & vbCrLf
        Next

        Return strMainScript
    End Function

    Public Sub AddMainScriptCommand(ByVal command As String)
        Me.mMainScriptCommands.Add(command)
    End Sub
    Public Sub AddCopyColumnCommand(ByVal source As String, ByVal dest As String)
        Dim strCommand As String
        strCommand = String.Format("DTSDestination(""{0}"") = DTSSource(""{1}"")", dest, source)
        Me.AddMainScriptCommand(strCommand)
    End Sub
    Public Sub AddFormula(ByVal formula As String)
        Me.AddMainScriptCommand(formula)
    End Sub
    Public Sub AddFunction(ByVal functionText As String)
        Me.mFunctions.Add(functionText)
    End Sub

End Class

Public Class SQLDTSTransformationCollection
    Inherits CollectionBase

    Default Public Property Item(ByVal index As Integer) As SQLDTSTransformation
        Get
            Return DirectCast(MyBase.List.Item(index), SQLDTSTransformation)
        End Get
        Set(ByVal Value As SQLDTSTransformation)
            MyBase.List.Item(index) = Value
        End Set
    End Property

    Public Sub Add(ByVal trans As SQLDTSTransformation)
        MyBase.List.Add(trans)
    End Sub

End Class
