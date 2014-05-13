
Public Class SampleUnitTreeNode

#Region " Private Fields "
    Private mId As Integer
    Private mName As String
    Private mNodeType As SampleUnitTreeNodeType
    Private mNodes As New List(Of SampleUnitTreeNode)
#End Region

#Region " Public Properties "
    Public Property Id() As Integer
        Get
            Return mId
        End Get
        Set(ByVal value As Integer)
            mId = value
        End Set
    End Property

    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal value As String)
            mName = value
        End Set
    End Property

    Public Property NodeType() As SampleUnitTreeNodeType
        Get
            Return mNodeType
        End Get
        Set(ByVal value As SampleUnitTreeNodeType)
            mNodeType = value
        End Set
    End Property

    Public ReadOnly Property Nodes() As List(Of SampleUnitTreeNode)
        Get
            Return mNodes
        End Get
    End Property

    Public ReadOnly Property HasChildren() As Boolean
        Get
            Return (mNodes.Count > 0)
        End Get
    End Property

    Public ReadOnly Property UniqueId() As String
        Get
            Select Case mNodeType
                Case SampleUnitTreeNodeType.Client
                    Return "CL" & Id.ToString
                Case SampleUnitTreeNodeType.Study
                    Return "ST" & Id.ToString
                Case SampleUnitTreeNodeType.Survey
                    Return "SV" & Id.ToString
                Case Else
                    Return Id.ToString
            End Select
        End Get
    End Property
#End Region

    Public Sub New(ByVal id As Integer, ByVal name As String, ByVal nodeType As SampleUnitTreeNodeType)
        mId = id
        mName = name
        mNodeType = nodeType
    End Sub

    Public Function GetChildUnitList() As String
        Dim ids() As Integer = Me.GetChildUnitIds
        Dim idList As String() = Array.ConvertAll(Of Integer, String)(ids, AddressOf IntegerConverter)
        Return String.Join(",", idList)
    End Function

    Public Shared Function FindNodeByUniqueId(ByVal nodes As List(Of SampleUnitTreeNode), ByVal uniqueId As String) As String
        Dim valuePath As String = FindNodeByUniqueIdCore(nodes, uniqueId, "")
        If valuePath IsNot Nothing Then valuePath = valuePath.Trim("/"c)
        Return valuePath
    End Function

    Private Shared Function FindNodeByUniqueIdCore(ByVal nodes As List(Of SampleUnitTreeNode), ByVal uniqueId As String, ByVal path As String) As String
        For Each child As SampleUnitTreeNode In nodes
            Dim valuePath As String = path & "/"c & child.Id
            If child.UniqueId = uniqueId Then Return valuePath
            Dim selection As String = FindNodeByUniqueIdCore(child.Nodes, uniqueId, valuePath)
            If selection IsNot Nothing Then Return selection
        Next
        Return Nothing
    End Function

    Public Shared Function FindNode(ByVal rootNodes As List(Of SampleUnitTreeNode), ByVal nodeIdPath As String) As SampleUnitTreeNode
        Dim ids() As String = nodeIdPath.Split(Char.Parse("/"))
        If ids.Length = 0 Then
            Return Nothing
        Else
            Dim rootId As Integer = CInt(ids(0))
            For Each node As SampleUnitTreeNode In rootNodes
                If node.Id = rootId Then
                    If ids.Length = 1 Then
                        Return node
                    Else
                        Dim childSearchPath As String = String.Join("/", ids, 1, ids.Length - 1)
                        Return node.FindNode(childSearchPath)
                    End If
                End If
            Next

            Return Nothing
        End If
    End Function

    Public Function FindNode(ByVal nodeIdPath As String) As SampleUnitTreeNode
        Dim ids() As String = nodeIdPath.Split(Char.Parse("/"))
        If ids.Length = 0 Then
            Return Nothing
        Else
            Dim searchId As Integer = CInt(ids(0))
            For Each node As SampleUnitTreeNode In mNodes
                If node.Id = searchId Then
                    If ids.Length = 1 Then
                        Return node
                    Else
                        Dim childSearchPath As String = String.Join("/", ids, 1, ids.Length - 1)
                        Return node.FindNode(childSearchPath)
                    End If
                End If
            Next

            Return Nothing
        End If
    End Function


#Region " Private Methods "
    Private Function IntegerConverter(ByVal input As Integer) As String
        Return input.ToString
    End Function
    Private Function StringConverter(ByVal input As String) As Integer
        Return Integer.Parse(input)
    End Function

    Private Function GetChildUnitIds() As Integer()
        Dim ids As New List(Of Integer)
        If mNodeType = SampleUnitTreeNodeType.Unit Then
            ids.Add(mId)
        End If
        If Me.HasChildren Then
            For Each child As SampleUnitTreeNode In mNodes
                Dim childIds() As Integer = child.GetChildUnitIds
                If childIds.Length > 0 Then
                    ids.AddRange(childIds)
                End If
            Next
        End If

        Return ids.ToArray
    End Function
#End Region

    Public Shared Function Load(ByVal unitList() As Legacy.ToolkitServer.UnitStructure) As List(Of SampleUnitTreeNode)
        Dim clientId As Integer = -1
        Dim rootNodes As New List(Of SampleUnitTreeNode)

        For Each unit As Legacy.ToolkitServer.UnitStructure In unitList
            If clientId <> unit.intClientID Then
                clientId = unit.intClientID
                Dim clientNode As New SampleUnitTreeNode(unit.intClientID, unit.strClientName, SampleUnitTreeNodeType.Client)
                rootNodes.Add(clientNode)
                clientNode.LoadChildNodes(unitList)
            End If
        Next

        Return rootNodes
    End Function

    Private Sub LoadChildNodes(ByVal unitList() As Legacy.ToolkitServer.UnitStructure)
        Select Case Me.NodeType
            Case SampleUnitTreeNodeType.Client
                Dim studyId As Integer = -1
                For Each unit As Legacy.ToolkitServer.UnitStructure In unitList
                    If unit.intClientID = mId AndAlso unit.intStudyID <> studyId Then
                        studyId = unit.intStudyID
                        Dim studyNode As New SampleUnitTreeNode(unit.intStudyID, unit.strStudyName, SampleUnitTreeNodeType.Study)
                        Me.Nodes.Add(studyNode)
                        studyNode.LoadChildNodes(unitList)
                    End If
                Next
            Case SampleUnitTreeNodeType.Study
                Dim surveyId As Integer = -1
                For Each unit As Legacy.ToolkitServer.UnitStructure In unitList
                    If unit.intStudyID = mId AndAlso unit.intSurveyID <> surveyId Then
                        surveyId = unit.intSurveyID
                        Dim surveyNode As New SampleUnitTreeNode(unit.intSurveyID, unit.strSurveyName, SampleUnitTreeNodeType.Survey)
                        Me.Nodes.Add(surveyNode)
                        surveyNode.LoadChildNodes(unitList)
                    End If
                Next
            Case SampleUnitTreeNodeType.Survey
                For Each unit As Legacy.ToolkitServer.UnitStructure In unitList
                    If unit.intSurveyID = mId AndAlso unit.intParentUnitID = 0 Then
                        Dim unitNode As New SampleUnitTreeNode(unit.intUnitID, unit.strUnitName.Replace("&nbsp;", ""), SampleUnitTreeNodeType.Unit)
                        Me.Nodes.Add(unitNode)
                        unitNode.LoadChildNodes(unitList)
                    End If
                Next
            Case SampleUnitTreeNodeType.Unit
                For Each unit As Legacy.ToolkitServer.UnitStructure In unitList
                    If unit.intParentUnitID = Me.mId Then
                        Dim unitNode As New SampleUnitTreeNode(unit.intUnitID, unit.strUnitName.Replace("&nbsp;", ""), SampleUnitTreeNodeType.Unit)
                        Me.Nodes.Add(unitNode)
                        unitNode.LoadChildNodes(unitList)
                    End If
                Next
        End Select
    End Sub

End Class