Imports Nrc.Qualisys.QLoader.Library.SqlProvider
Imports Nrc.Framework.BusinessLogic.Configuration

''' <summary>
''' Represents a custom function defined in the QualiSys Loading database.
''' </summary>
''' <remarks>
''' </remarks>
''' <history>
''' 	[JCamp]	5/24/2004	Created
''' </history>
Public Class DTSFunction

#Region " Private Members "

    Private mFunctionID As Integer
    Private mName As String
    Private mDescription As String
    Private mSourceCode As String
    Private mIsVBScript As Boolean
    Private mClientID As Integer
    Private mGroupID As Integer
    Private mParameters As ArrayList

    Private mConnection As String
    Private Shared mScript As MSScriptControl.ScriptControl

#End Region

#Region " Public Properties "

    ''' <summary>
    ''' The function ID for this function in the Loading Database.
    ''' </summary>
    ''' <value>The new function ID</value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Property FunctionID() As Integer
        Get
            Return Me.mFunctionID
        End Get
        Set(ByVal Value As Integer)
            Me.mFunctionID = Value
        End Set
    End Property

    ''' <summary>
    ''' The name of the function.
    ''' </summary>
    ''' <value>The new name of the function</value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Property Name() As String
        Get
            Return Me.mName
        End Get
        Set(ByVal Value As String)
            Me.mName = Value
        End Set
    End Property

    ''' <summary>
    ''' Calculates and returns the signature of the function derived 
    ''' from the defined parameters
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public ReadOnly Property Signature() As String
        Get
            Dim sig As String = mName & "({0})"
            Dim param As String
            Dim paramList As String = ""
            For Each param In mParameters
                paramList &= param & ","
            Next
            If paramList.Length > 0 Then
                paramList = paramList.Substring(0, paramList.Length - 1)
            End If

            Return String.Format(sig, paramList)
        End Get
    End Property

    ''' <summary>
    ''' A brief description of what the function does
    ''' </summary>
    ''' <value>The new description</value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Property Description() As String
        Get
            Return Me.mDescription
        End Get
        Set(ByVal Value As String)
            Me.mDescription = Value
        End Set
    End Property

    ''' <summary>
    ''' The acutal source code definition of the function.
    ''' </summary>
    ''' <value>The new source code.</value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Property SourceCode() As String
        Get
            Return Me.mSourceCode
        End Get
        Set(ByVal Value As String)
            Me.mSourceCode = Value
        End Set
    End Property

    ''' <summary>
    ''' Returns True when the function represents a built-in VBScript function.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Property IsVBScript() As Boolean
        Get
            Return Me.mIsVBScript
        End Get
        Set(ByVal Value As Boolean)
            Me.mIsVBScript = Value
        End Set
    End Property

    ''' <summary>
    ''' The client ID that this function is associated with.  Returns zero if the
    ''' function is a Global Custom Function
    ''' </summary>
    ''' <value>The new client ID</value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Property ClientID() As Integer
        Get
            Return Me.mClientID
        End Get
        Set(ByVal Value As Integer)
            Me.mClientID = Value
        End Set
    End Property

    ''' <summary>
    ''' The group ID from the database that determines under which category
    ''' the function is displayed.
    ''' </summary>
    ''' <value>The new group ID</value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Property GroupID() As Integer
        Get
            Return Me.mGroupID
        End Get
        Set(ByVal Value As Integer)
            Me.mGroupID = Value
        End Set
    End Property

    ''' <summary>
    ''' Returns an ArrayList of the parameters defined for this function
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public ReadOnly Property Parameters() As ArrayList
        Get
            Return Me.mParameters
        End Get
    End Property

    ''' <summary>
    ''' Calculates and returns the "Function Stub" for this function to help start
    ''' the user in the syntax for creating a VB Script function.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public ReadOnly Property FunctionStub() As String
        Get
            Dim stub As String
            stub = "Function " & Signature & vbCrLf
            stub &= "  " & mName & " = " & vbCrLf
            stub &= "End Function"

            Return stub
        End Get
    End Property

#End Region

    ''' <summary>
    ''' This shared constructor creates an instance of the MS Script Control that can
    ''' be shared among all instances of this class.  This is a COM object so having
    ''' one shared object ensures that we don't have to re-create this object many
    ''' times.
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Shared Sub New()

        mScript = New MSScriptControl.ScriptControl
        mScript.Language = "VBScript"

    End Sub

    ''' <summary>
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Sub New()

        Me.mConnection = AppConfig.QLoaderConnection
        Me.mParameters = New ArrayList

    End Sub

    ''' <summary>
    ''' Populates the DTSFunction object from a specific function stored in the Loading Database
    ''' </summary>
    ''' <param name="functionID">The function ID of the object to load</param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Sub LoadFromDB(ByVal functionID As Integer)

        Dim row As DataRow = PackageDB.GetFunction(functionID)
        Me.LoadFromDataRow(row)

    End Sub

    ''' <summary>
    ''' Populates the DTSFunction object with the information contained in a DataRow
    ''' object extracted from the Loading Database.
    ''' </summary>
    ''' <param name="row">The DataRow object containing the record to load</param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Sub LoadFromDataRow(ByVal row As DataRow)

        Me.mFunctionID = CType(row("Function_id"), Integer)
        Me.mName = row("strFunction_nm").ToString
        Me.mDescription = row("strFunction_dsc").ToString
        Me.mSourceCode = row("strFunction_code").ToString
        Me.mIsVBScript = CType(row("bitVBS"), Boolean)
        Me.mClientID = CType(row("Client_id"), Integer)
        Me.mGroupID = CType(row("FunctionGroup_id"), Integer)
        Me.GetParamsFromSignature(row("strFunction_sig").ToString)

    End Sub

    ''' <summary>
    ''' Persists the DTSFunction object to the Loading Database for future use
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Sub SaveToDB()

        Dim conn As New SqlClient.SqlConnection(mConnection)
        conn.Open()
        Dim trans As SqlClient.SqlTransaction
        trans = conn.BeginTransaction(IsolationLevel.ReadCommitted)

        Try
            PackageDB.SaveFunctions(trans, mFunctionID, mName, _
                Signature, mDescription, mSourceCode, mIsVBScript, _
               mClientID, mGroupID)
            trans.Commit()

        Catch ex As Exception
            trans.Rollback()
            Throw ex

        Finally
            conn.Close()

        End Try

    End Sub

    ''' <summary>
    ''' Stores the function parameters for the function based off of a given function signature
    ''' </summary>
    ''' <param name="signature">The function signature that should be used to
    ''' generate the parameter list</param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Private Sub GetParamsFromSignature(ByVal signature As String)

        Me.mParameters.Clear()
        Dim startpos As Integer = signature.IndexOf("(")
        Dim endpos As Integer = signature.IndexOf(")", startpos)
        startpos += 1
        Dim params() As String
        Dim param As String

        params = signature.Substring(startpos, endpos - startpos).Split(Char.Parse(","))
        For Each param In params
            Me.mParameters.Add(param)
        Next

    End Sub

    ''' <summary>
    ''' Returns a collection of all the DTSFunction objects that a given client has access to
    ''' </summary>
    ''' <param name="clientID">The client ID that should be used to gain access to the functions</param>
    ''' <returns>A DTSFunctionCollection containing all the functions available</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Shared Function GetAllFunctions(ByVal clientID As Integer) As DTSFunctionCollection

        Dim tblFunctions As DataTable = PackageDB.GetAllFunctions(clientID)
        Dim row As DataRow
        Dim functions As New DTSFunctionCollection
        Dim func As DTSFunction

        For Each row In tblFunctions.Rows
            func = New DTSFunction()
            func.LoadFromDataRow(row)

            functions.Add(func)
        Next

        Return functions

    End Function

    ''' <summary>
    ''' Performs a syntax check of the DTSFunction object.
    ''' </summary>
    ''' <param name="result">The string that will store any result messages</param>
    ''' <returns>A Boolean Flag specifying if the syntax check was successful</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Function SyntaxCheck(ByRef result As String) As Boolean

        Try
            mScript.Reset()
            mScript.ExecuteStatement(mSourceCode)
            result = "Syntax Check Successful"
            Return True

        Catch ex As Exception
            result = ex.Message
            Return False

        End Try

    End Function

    ''' <summary>
    ''' Performs a test execution of the function defined.  The parameters for the function
    ''' must be passed in as a ParamArray
    ''' </summary>
    ''' <param name="result">The string that will store any result messages</param>
    ''' <param name="params">An array of parameters needed by the VBScript function</param>
    ''' <returns>A Boolean Flag indicating if the execution was successful</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Function Execute(ByRef result As String, ByVal ParamArray params() As Object) As Boolean

        If Not params.Length = mParameters.Count Then
            result = "Invalid number of parameters for function " & mName
            Return False
        End If

        Dim command As String = mName
        Dim param As Object

        Try
            command &= "("
            For Each param In params
                command &= param.ToString & ", "
            Next

            command = command.Substring(0, command.Length - 2)
            command &= ")"

            mScript.Reset()
            mScript.AddCode(mSourceCode)
            result = mScript.Eval(command).ToString
            Return True

        Catch ex As Exception
            result = ex.Message
            Return False

        End Try

    End Function

    ''' <summary>
    ''' Validates the DTSFunction object.  This will ensure that simple errors 
    ''' have not been created in the function information and will also perform
    ''' a syntax check.
    ''' </summary>
    ''' <param name="result">The string that will store any result messages</param>
    ''' <returns>A Boolean Flag inidating if the function is valid</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Function Validate(ByRef result As String) As Boolean

        If mName = "" Then
            result = "Invalid function name."
            Return False
        End If

        If mSourceCode = "" Then
            result = "Invalid source code for function."
            Return False
        End If

        If mSourceCode.ToLower.IndexOf("function " & mName.ToLower) < 0 Then
            result = "Function source code must define the function '" & mName & "'"
            Return False
        End If

        If mSourceCode.ToLower.IndexOf(Signature.ToLower) < 0 Then
            result = "Function source code must have the signature '" & Signature & "'"
            Return False
        End If

        If mGroupID < 1 Then
            result = "Invalid Function Group."
            Return False
        End If

        If Not SyntaxCheck(result) Then
            Return False
        End If

        Return True

    End Function

End Class

''' <summary>
''' A strongly typed collection of DTSFunction objects
''' </summary>
''' <remarks>
''' </remarks>
''' <history>
''' 	[JCamp]	5/24/2004	Created
''' </history>
Public Class DTSFunctionCollection
    Inherits System.Collections.CollectionBase

    ''' <summary>
    ''' Gets or sets the DTSFunction object stored at any particular index
    ''' </summary>
    ''' <param name="index">The index of the object in the collection</param>
    ''' <value>The new DTSFunction object to store</value>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Property Item(ByVal index As Integer) As DTSFunction
        Get
            Return DirectCast(MyBase.List.Item(index), DTSFunction)
        End Get
        Set(ByVal Value As DTSFunction)
            MyBase.List.Item(index) = Value
        End Set
    End Property

    ''' <summary>
    ''' Adds a new DTSFunction object to the collection
    ''' </summary>
    ''' <param name="func">The DTSFunction object to add to the collection</param>
    ''' <returns>The index of the newly added DTSFunction object</returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	5/24/2004	Created
    ''' </history>
    Public Function Add(ByVal func As DTSFunction) As Integer

        Return MyBase.List.Add(func)

    End Function

End Class
