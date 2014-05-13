Imports Nrc.Framework.Data
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Data.Common

Namespace Legacy

    ''' <summary>
    ''' This class contains the code required for the eToolKit web application
    ''' </summary>
    <Serializable()> _
    Public Class ToolkitServer


#Region " Private Fields "

        Private Const mkstrAppVersion As String = "1.0"

        'Private mstrLoginName As String = ""
        Private ReadOnly mintSelectedMemberId As Integer
        Private ReadOnly mintSelectedGroupId As Integer
        Private ReadOnly mMemberPreference As MemberReportPreference
        Private ReadOnly mMemberGroupPreference As MemberGroupReportPreference
        Private ReadOnly mResultSetId As Guid
        Private mbolInitialized As Boolean = False

        Private mintCurrentDimensionID As Integer

        'Private mobjQualityProgramsDs As DataSet
        Private mobjCompDatasetsDs As DataSet
        Private mobjServiceTypesDs As DataSet

        Private mobjDimensionDataDs As DataSet
        Private mbolDimDataLoaded As Boolean

        Private mobjContentDataDs As DataSet
        Private mintCDDimensionID As Integer
        Private mintCDQstnCore As Integer

        Structure UnitStructure
            Dim intClientID As Integer
            Dim strClientName As String
            Dim intUnitID As Integer
            Dim strUnitName As String
            Dim intStudyID As Integer
            Dim strStudyName As String
            Dim intSurveyID As Integer
            Dim strSurveyName As String
            Dim intParentUnitID As Integer
        End Structure

        Private maobjAvailableUnits() As UnitStructure
        Private mbolAvailUnitsLoaded As Boolean

        Structure UnitLookup
            Dim intClientID As Integer
            Dim intStudyID As Integer
            Dim intSurveyID As Integer
            Dim strUnitList As String
        End Structure

        Private maobjUnitLookups() As UnitLookup

        Public Enum enuContentDataTypes
            enuCDTQuestionImportance = 1
            enuCDTQuickCheck = 2
            enuCDTRecommendations = 3
            enuCDTResources = 4
        End Enum

        Public Enum enuDataAnalysisTypes
            enuDATPercentage = 0
            enuDATProblem = 1
            enuDATPositive = 2
        End Enum

        Public Enum EReportsChartType
            TrendChart = 1
            ControlChart = 2
        End Enum

        Public Enum AnalysisVariable
            ProblemScore = 1
            PositiveScore = 2
        End Enum

#End Region

#Region " Public Properties "

        ''' <summary>Member preferences for the selected member</summary>
        Public ReadOnly Property MemberPreference() As MemberReportPreference
            Get
                Return mMemberPreference
            End Get
        End Property

        ''' <summary>Member preferences for the selected group</summary>
        Public ReadOnly Property MemberGroupPreference() As MemberGroupReportPreference
            Get
                Return mMemberGroupPreference
            End Get
        End Property

        ''' <summary>Returns the result set id</summary>
        Public ReadOnly Property ResultSetId() As Guid
            Get
                Return mResultSetId
            End Get
        End Property

        ''' <summary>Returns the application version</summary>
        Public ReadOnly Property AppVersion() As String
            Get
                Return mkstrAppVersion
            End Get
        End Property

        '''' <summary></summary>
        'Public ReadOnly Property QualityPrograms() As DataSet
        '    Get
        '        Return mobjQualityProgramsDs
        '    End Get
        'End Property


        Public ReadOnly Property CompDatasets() As DataSet
            Get
                Return mobjCompDatasetsDs
            End Get
        End Property


        ''' <summary>The selected service type name</summary>
        Public ReadOnly Property ServiceTypeName() As String
            Get

                Dim intCnt As Integer
                Dim strReturn As String = ""

                'Find the selected service type
                With mobjServiceTypesDs.Tables(0)
                    For intCnt = 0 To .Rows.Count - 1
                        If CInt(.Rows(intCnt).Item("TKDimension_id")) = MemberGroupPreference.ServiceTypeId Then
                            strReturn = .Rows(intCnt).Item("strTKDimension_nm").ToString
                            Exit For
                        End If
                    Next
                End With

                'Set return value
                Return strReturn

            End Get
        End Property

        Public ReadOnly Property ServiceTypes() As DataSet
            Get
                Return mobjServiceTypesDs
            End Get
        End Property

        ''' <summary>The selected sample unit name</summary>
        Public ReadOnly Property SelectedUnitName() As String
            Get

                Dim intID As Integer
                Dim intCnt As Integer
                Dim strUnitName As String = ""

                If IsNumeric(MemberGroupPreference.SelectedUnit) Then
                    For intCnt = 0 To UBound(maobjAvailableUnits)
                        If maobjAvailableUnits(intCnt).intUnitID = Val(MemberGroupPreference.SelectedUnit) Then
                            strUnitName = maobjAvailableUnits(intCnt).strUnitName
                            Exit For
                        End If
                    Next
                ElseIf MemberGroupPreference.SelectedUnit.ToUpper.StartsWith("CL") Then
                    intID = CInt(MemberGroupPreference.SelectedUnit.Substring(2))
                    For intCnt = 0 To UBound(maobjAvailableUnits)
                        If maobjAvailableUnits(intCnt).intClientID = intID Then
                            strUnitName = maobjAvailableUnits(intCnt).strClientName
                            Exit For
                        End If
                    Next
                ElseIf MemberGroupPreference.SelectedUnit.ToUpper.StartsWith("ST") Then
                    intID = CInt(MemberGroupPreference.SelectedUnit.Substring(2))
                    For intCnt = 0 To UBound(maobjAvailableUnits)
                        If maobjAvailableUnits(intCnt).intStudyID = intID Then
                            strUnitName = maobjAvailableUnits(intCnt).strStudyName
                            Exit For
                        End If
                    Next
                ElseIf MemberGroupPreference.SelectedUnit.ToUpper.StartsWith("SV") Then
                    intID = CInt(MemberGroupPreference.SelectedUnit.Substring(2))
                    For intCnt = 0 To UBound(maobjAvailableUnits)
                        If maobjAvailableUnits(intCnt).intSurveyID = intID Then
                            strUnitName = maobjAvailableUnits(intCnt).strSurveyName
                            Exit For
                        End If
                    Next
                End If

                Return strUnitName

            End Get
        End Property

#End Region

#Region " Constructors "
        ''' <summary>
        ''' When a user logs into eToolKit the ToolKitServer should be popluated with
        ''' all the user specific data
        ''' </summary>
        ''' <param name="selectedMemberId">The ID of the NRcAuth Member account that the user has selected</param>
        ''' <param name="selectedGroupId">The ID of the NrcAuth Group account that the user has selected</param>
        Public Sub New(ByVal selectedMemberId As Integer, ByVal selectedGroupId As Integer)

            mMemberPreference = MemberReportPreference.GetByKey(selectedMemberId)
            If mMemberPreference Is Nothing Then
                mMemberPreference = MemberReportPreference.NewMemberReportPreference(selectedMemberId)
            End If
            AddHandler mMemberPreference.PropertyChanged, AddressOf OnPreferenceChanged

            mMemberGroupPreference = MemberGroupReportPreference.GetByKey(selectedMemberId, selectedGroupId)
            If mMemberGroupPreference Is Nothing Then
                mMemberGroupPreference = MemberGroupReportPreference.NewMemberGroupReportPreference(selectedMemberId, selectedGroupId)
            End If
            AddHandler mMemberGroupPreference.PropertyChanged, AddressOf OnPreferenceChanged

            'Save the WebAccount object
            'mobjWebAccount = objWebAccount

            'Load the user data
            'mintClientUserID = mobjWebAccount.AccountProperty(strField_Nm:="ClientUser_id")
            mintSelectedMemberId = selectedMemberId
            mintSelectedGroupId = selectedGroupId
            mResultSetId = Guid.NewGuid()
            'mstrLoginName = mobjWebAccount.AccountProperty(strField_Nm:="strLogin_Nm")
            'mstrLoginName = user.UserName
            LoadUserData(mintSelectedGroupId)

            'All went well so set the initialized flag
            mbolInitialized = True

        End Sub
#End Region

#Region " Private Properties "
        ''' <summary>A reference to the toolkit database object</summary>
        Private Shared ReadOnly Property Db() As Database
            Get
                Return DatabaseHelper.DataMartDb
            End Get
        End Property
#End Region

#Region " Public Methods "
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        '\\ Copyright © National Research Corporation
        '\\
        '\\ Routine Name:   LoadUserData
        '\\
        '\\ Created By:     Jeffrey J. Fleming
        '\\         Date:   02-07-2003
        '\\
        '\\ Description:    This routine is called to populate all essential
        '\\                 information about this user into the object.
        '\\
        '\\ Parameters:
        '\\     Name        Type        Description
        '\\     intUserID   Integer     Specifies the logged in users id.
        '\\
        '\\ Revisions:
        '\\     Date        By      Description
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        Public Sub LoadUserData(ByVal intClientUserID As Integer)

            'Populate the lookups
            'PopQualityPrograms()
            PopCompDatasets()
            PopServiceTypes()

        End Sub

        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        '\\ Copyright © National Research Corporation
        '\\
        '\\ Routine Name:   GetUnitList
        '\\
        '\\ Created By:     Jeffrey J. Fleming
        '\\         Date:   02-07-2003
        '\\
        '\\ Description:    This routine populates an array with the names
        '\\                 of the available sample units to be used in
        '\\                 populating filter by unit page.
        '\\
        '\\ Parameters:
        '\\     Name        Type            Description
        '\\     aobjUnits   UnitStructure   Array to be populated with a list of
        '\\                                 available sample units.
        '\\
        '\\ Return Value:
        '\\     Type        Description
        '\\     Integer     Quantity of sample units returned in the array.
        '\\
        '\\ Revisions:
        '\\     Date        By      Description
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        Public Function GetUnitList(ByRef aobjUnits() As UnitStructure) As Integer
            If Not mbolAvailUnitsLoaded Then
                Dim cmd As DbCommand = Db.GetStoredProcCommand("DCL_SelectUnitTree")
                Db.AddInParameter(cmd, "@Group_ID", DbType.Int32, mintSelectedGroupId)
                Db.AddInParameter(cmd, "@ServiceTypeId", DbType.Int32, MemberGroupPreference.ServiceTypeId)

                Dim units As New List(Of UnitStructure)
                Dim lookups As New List(Of UnitLookup)

                Using rdr As New SafeDataReader(ExecuteReader(cmd))
                    'Populate the unit list array
                    While rdr.Read
                        Dim unit As New UnitStructure
                        unit.intClientID = rdr.GetInteger("Client_id")
                        unit.strClientName = rdr.GetString("Client").Replace(vbCrLf, "")
                        unit.intUnitID = rdr.GetInteger("SampleUnit_id")
                        unit.strUnitName = rdr.GetString("strSampleUnit_Nm").Replace(vbCrLf, "")
                        unit.intStudyID = rdr.GetInteger("Study_id")
                        unit.strStudyName = rdr.GetString("Study").Replace(vbCrLf, "")
                        unit.intSurveyID = rdr.GetInteger("Survey_id")
                        unit.strSurveyName = rdr.GetString("Survey").Replace(vbCrLf, "")
                        unit.intParentUnitID = rdr.GetInteger("ParentSampleUnit_id")
                        units.Add(unit)
                    End While

                    'Populate the unit lookups
                    If rdr.NextResult() Then
                        While rdr.Read
                            Dim lookup As New UnitLookup
                            lookup.intClientID = rdr.GetInteger("client_id")
                            lookup.intStudyID = rdr.GetInteger("study_id")
                            lookup.intSurveyID = rdr.GetInteger("survey_id")
                            lookup.strUnitList = rdr.GetString("SampleUnits")
                            lookups.Add(lookup)
                        End While
                    End If
                End Using

                maobjUnitLookups = lookups.ToArray
                maobjAvailableUnits = units.ToArray

                'Set the flag to indicate that the units are already cached
                mbolAvailUnitsLoaded = True
            End If

            'We have already loaded the units so just return them
            aobjUnits = maobjAvailableUnits

            'return the quantity of recently viewed
            Return maobjAvailableUnits.Length
        End Function

        Private mUnitTree As List(Of SampleUnitTreeNode)
        Public Function GetUnitTree() As List(Of SampleUnitTreeNode)
            If Me.mbolAvailUnitsLoaded Then
                If mUnitTree Is Nothing Then
                    mUnitTree = SampleUnitTreeNode.Load(maobjAvailableUnits)
                End If
                Return mUnitTree
            Else
                Dim unitList() As UnitStructure = Nothing
                Me.GetUnitList(unitList)
                mUnitTree = SampleUnitTreeNode.Load(unitList)
                Return mUnitTree
            End If
        End Function

        Public Function GetTreeData(ByVal intDimensionID As Integer) As DataSet
            If Not mbolDimDataLoaded Then
                'Get the unit list to be used
                Dim strUnitList As String = ""

                strUnitList = BuildUnitList()

                Dim cmd As DbCommand = Db.GetStoredProcCommand("DCL_ScoredDimension", _
                    intDimensionID, _
                    strUnitList, _
                    MemberGroupPreference.ReportStartDate, _
                    MemberGroupPreference.ReportEndDate, _
                    False, _
                    mintSelectedGroupId, _
                    mintSelectedMemberId, _
                    mResultSetId _
                    )

                mobjDimensionDataDs = ExecuteDataSet(cmd)
                mbolDimDataLoaded = True
            End If

            'Return the data for the tree
            Dim objDataSet As DataSet = mobjDimensionDataDs.Copy()
            objDataSet.Tables.Remove(objDataSet.Tables(1))
            For intCnt As Integer = objDataSet.Tables(0).Rows.Count - 1 To 0 Step -1
                If CInt(objDataSet.Tables(0).Rows(intCnt).Item("ParentDimension_id")) <> intDimensionID Then
                    objDataSet.Tables(0).Rows.Remove(objDataSet.Tables(0).Rows(intCnt))
                End If
            Next
            Return objDataSet

        End Function

        Public Function GetQuestionData(ByVal intDimensionID As Integer) As DataSet
            If Not mbolDimDataLoaded Then
                GetTreeData(intDimensionID)
            End If
            Dim objDataSet As DataSet = mobjDimensionDataDs.Copy()
            objDataSet.Tables.Remove(objDataSet.Tables(0))
            Return objDataSet
        End Function

        Public Function GetQuestionScores(ByVal viewID As Integer, ByVal intDimensionID As Integer) As DataView
            If viewID = -1 Then ' Choose a question...
                viewID = intDimensionID
            End If

            If Not mbolDimDataLoaded Then
                GetTreeData(viewID)
            End If

            'Save the current dimension id
            mintCurrentDimensionID = intDimensionID

            'Return the question data for the requested dimension
            Dim objDataView As DataView = New DataView(mobjDimensionDataDs.Tables(1))
            objDataView.RowFilter = "Dimension_id=" & intDimensionID
            Return objDataView

        End Function

        Public Function GetQuestionScore(ByVal viewID As Integer, ByVal dimensionID As Integer, ByVal questionID As Integer) As Double
            Dim dv As DataView = GetQuestionScores(viewID, dimensionID)
            For Each row As DataRowView In dv
                If CInt(row("QstnCore")) = questionID Then
                    Return CType(row("QuestionScore"), Double)
                End If
            Next
        End Function

        Public Function GetQuestionNorm(ByVal viewID As Integer, ByVal dimensionID As Integer, ByVal questionID As Integer) As Double
            Dim dv As DataView = GetQuestionScores(viewID, dimensionID)
            For Each row As DataRowView In dv
                If CInt(row("QstnCore")) = questionID Then
                    Return CType(row("NormScore"), Double)
                End If
            Next
        End Function

        Public Function GetQuestionBest(ByVal viewID As Integer, ByVal dimensionID As Integer, ByVal questionID As Integer) As Double
            Dim dv As DataView = GetQuestionScores(viewID, dimensionID)
            For Each row As DataRowView In dv
                If CInt(row("QstnCore")) = questionID Then
                    Return CType(row("BenchMarkScore"), Double)
                End If
            Next
        End Function

        Public Function GetQuestionText(ByVal viewID As Integer, ByVal dimensionID As Integer, ByVal questionID As Integer) As String
            Dim dv As DataView = GetQuestionScores(viewID, dimensionID)
            For Each row As DataRowView In dv
                If CInt(row("QstnCore")) = questionID Then
                    Return CType(row("strQuestionText"), String)
                End If
            Next
            Return ""
        End Function

        Public Function GetContentData(ByVal intDimensionID As Integer, ByVal intQstnCore As Integer, _
                               ByVal enuContentDataType As enuContentDataTypes, ByRef bNewContent As Boolean) As String

            'Get the data set if we do not already have it
            If mintCDDimensionID <> intDimensionID Or mintCDQstnCore <> intQstnCore Then
                Dim cmd As DbCommand = Db.GetStoredProcCommand("sp_TK_ContentData", mintSelectedGroupId, intDimensionID, intQstnCore)
                mobjContentDataDs = ExecuteDataSet(cmd)

                mintCDDimensionID = intDimensionID
                mintCDQstnCore = intQstnCore
            End If

            'Find the correct value to return
            Dim intCnt As Integer
            Dim strReturn As String = ""

            For intCnt = 0 To mobjContentDataDs.Tables(0).Rows.Count - 1
                If CType(mobjContentDataDs.Tables(0).Rows(intCnt).Item("ContentType_id"), enuContentDataTypes) = enuContentDataType Then
                    strReturn = mobjContentDataDs.Tables(0).Rows(intCnt).Item("txtContent").ToString
                    bNewContent = CType(mobjContentDataDs.Tables(0).Rows(intCnt).Item("UpdatedContent"), Boolean)
                    Exit For
                End If
            Next
            Return strReturn

        End Function

        Public Function GetCommentsUnits() As String()
            Dim unitList As String = BuildUnitList()
            Dim cmd As DbCommand = Db.GetStoredProcCommand("sp_TK_UnitConv", mintSelectedGroupId, unitList)

            Dim unitListResult As String = ""
            Using rdr As New SafeDataReader(ExecuteReader(cmd))
                'Set the user preferences
                If rdr.Read Then
                    unitListResult = rdr.GetString("txt").Trim
                Else
                    Throw New ToolKitDataAccessException("No data returned for procedure 'sp_TK_UnitConv'")
                End If
            End Using


            Dim astrUnits() As String = Split(unitListResult, ",")

            Return astrUnits
        End Function

        Public Function GetCommentsCodedAs() As String()

            Dim strCommentCodes As String

            Dim cmd As DbCommand = Db.GetStoredProcCommand("sp_TK_DimensionCodes", mintCurrentDimensionID)
            Using rdr As New SafeDataReader(ExecuteReader(cmd))
                'Set the user preferences
                If rdr.Read() Then
                    strCommentCodes = rdr.GetString("Codes").Trim
                Else
                    Throw New ToolKitDataAccessException("No data returned for procedure 'sp_TK_DimensionCodes'")
                End If
            End Using


            Dim astrCodes() As String = Split(strCommentCodes, ",")
            Return astrCodes
        End Function


#Region " Question Content Management "

        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        '\\ Copyright © National Research Corporation
        '\\
        '\\ Routine Name:   GetServiceTypes
        '\\
        '\\ Created By:     Joe Camp
        '\\         Date:   08-06-2003
        '\\
        '\\ Description:    Returns a data reader containing all available service types
        '\\                 for the content management page
        '\\
        '\\ Parameters:
        '\\     Name        Type        Description
        '\\
        '\\ Return Value:
        '\\     Type        Description
        '\\     Datareader  Reader containing Service Types
        '\\
        '\\ Revisions:
        '\\     Date        By      Description
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        Public Shared Function GetServiceTypes() As IDataReader
            Dim cmd As DbCommand = Db.GetStoredProcCommand("SP_TK_Dimension", 0, 0)
            Return ExecuteReader(cmd)
        End Function

        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        '\\ Copyright © National Research Corporation
        '\\
        '\\ Routine Name:   GetQuestionViews
        '\\
        '\\ Created By:     Joe Camp
        '\\         Date:   08-06-2003
        '\\
        '\\ Description:    Returns a data reader containing all available views
        '\\                 for the content management page
        '\\
        '\\ Parameters:
        '\\     Name            Type        Description
        '\\     intServiceType  Integer     The ID of the selected service type to which the views belong
        '\\
        '\\ Return Value:
        '\\     Type        Description
        '\\     Datareader  Reader containing dimension views
        '\\
        '\\ Revisions:
        '\\     Date        By      Description
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        Public Shared Function GetQuestionViews(ByVal intServiceType As Integer) As IDataReader
            Dim cmd As DbCommand = Db.GetStoredProcCommand("SP_TK_Dimension", intServiceType, 0)
            Return ExecuteReader(cmd)
        End Function

        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        '\\ Copyright © National Research Corporation
        '\\
        '\\ Routine Name:   GetDimensions
        '\\
        '\\ Created By:     Joe Camp
        '\\         Date:   08-06-2003
        '\\
        '\\ Description:    Returns a data reader containing all available dimensions
        '\\                 for the content management page
        '\\
        '\\ Parameters:
        '\\     Name        Type        Description
        '\\     intView     Integer     The ID of the view to which the dimensions belong
        '\\
        '\\ Return Value:
        '\\     Type        Description
        '\\     Datareader  Reader containing the dimensions
        '\\
        '\\ Revisions:
        '\\     Date        By      Description
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        Public Shared Function GetDimensions(ByVal intView As Integer) As IDataReader
            Dim cmd As DbCommand = Db.GetStoredProcCommand("SP_TK_Dimension", intView, 0)
            Return ExecuteReader(cmd)
        End Function

        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        '\\ Copyright © National Research Corporation
        '\\
        '\\ Routine Name:   GetDimensionCores
        '\\
        '\\ Created By:     Joe Camp
        '\\         Date:   08-06-2003
        '\\
        '\\ Description:    Returns a data reader containing all available questions
        '\\                 for the content management page
        '\\
        '\\ Parameters:
        '\\     Name            Type        Description
        '\\     intDimension    Integer     The ID of the dimension to which the questions belong
        '\\
        '\\ Return Value:
        '\\     Type        Description
        '\\     Datareader  Reader containing the questions
        '\\
        '\\ Revisions:
        '\\     Date        By      Description
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        Public Shared Function GetDimensionCores(ByVal intDimension As Integer) As IDataReader
            Dim cmd As DbCommand = Db.GetStoredProcCommand("SP_TK_DimensionCores", intDimension)
            Return ExecuteReader(cmd)
        End Function

        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        '\\ Copyright © National Research Corporation
        '\\
        '\\ Routine Name:   LoadAssociatedCores
        '\\
        '\\ Created By:     Dennis Grady
        '\\         Date:   07-09-2004
        '\\
        '\\ Description:    Loads associated core questions
        '\\                 
        '\\
        '\\ Parameters:
        '\\     Name            Type        Description
        '\\     intCore         Integer     The ID of the Question Core
        '\\
        '\\ Return Value:
        '\\     Type        Description
        '\\
        '\\ Revisions:
        '\\     Date        By      Description
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        Public Shared Function LoadAssociatedCores(ByVal intCore As Integer) As DataSet
            Dim cmd As DbCommand = Db.GetStoredProcCommand("SP_TK_AssociatedCores", 0, 0, intCore)
            Return ExecuteDataSet(cmd)
        End Function

        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        '\\ Copyright © National Research Corporation
        '\\
        '\\ Routine Name:   LoadQuestionContent
        '\\
        '\\ Created By:     Joe Camp
        '\\         Date:   08-06-2003
        '\\
        '\\ Description:    Loads the HTML Content (Quick check, resources, etc.) for a 
        '\\                 question into the session object
        '\\
        '\\ Parameters:
        '\\     Name            Type        Description
        '\\     intCore         Integer     The ID of the Question Core
        '\\
        '\\ Return Value:
        '\\     Type        Description
        '\\
        '\\ Revisions:
        '\\     Date        By      Description
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        'Public Shared Sub LoadQuestionContent(ByVal intCore As Integer)
        '    Dim cmd As DbCommand = Db.GetStoredProcCommand("SP_TK_ContentData", 0, 0, intCore)
        '    Using rdr As New SafeDataReader(ExecuteReader(cmd))
        '        'For every record store it in the session object
        '        Dim typeId As Integer
        '        Dim htmlContent As String
        '        While rdr.Read()
        '            typeId = rdr.GetInteger("ContentType_id")
        '            htmlContent = rdr.GetString("txtContent")

        '            'Store in session
        '            QuestionContent(typeId) = htmlContent
        '        End While
        '    End Using
        'End Sub

        'Public Shared Function GetQuestionContent(ByVal questionId As Integer) As QuestionContent
        '    Dim cmd As DbCommand = Db.GetStoredProcCommand("SP_TK_ContentData", 0, 0, questionId)
        '    Dim content As New QuestionContent
        '    Dim privateinterface As IQuestionContent = content

        '    Using rdr As New SafeDataReader(ExecuteReader(cmd))
        '        privateinterface.QuestionId = questionId

        '        While rdr.Read
        '            Dim html As String = rdr.GetString("txtContent")
        '            Dim isNew As Boolean = CType(rdr.GetValue("UpdatedContent"), Boolean)

        '            Select Case rdr.GetEnum(Of QuestionContentType)("ContentType_id")
        '                Case QuestionContentType.QuestionImportance
        '                    content.ImportanceHtml = html
        '                    content.ImportanceIsNew = isNew
        '                Case QuestionContentType.QuickCheck
        '                    content.QuickCheckHtml = html
        '                    content.QuickCheckIsNew = False
        '                Case QuestionContentType.Recommendations
        '                    content.RecommendationsHtml = html
        '                    content.RecommendationsIsNew = isNew
        '                Case QuestionContentType.Resources
        '                    content.ResourcesHtml = html
        '                    content.ResourcesIsNew = isNew
        '            End Select
        '        End While

        '    End Using

        '    Return content
        'End Function

        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        '\\ Copyright © National Research Corporation
        '\\
        '\\ Routine Name:   QuestionContent
        '\\
        '\\ Created By:     Joe Camp
        '\\         Date:   08-06-2003
        '\\
        '\\ Description:    Get/Sets the content HTML for the question that is currently
        '\\                 loaded into the session object
        '\\
        '\\ Parameters:
        '\\     Name            Type        Description
        '\\     intType         Integer     The ID of the content type (ie. quick check, importance, etc.)
        '\\
        '\\ Return Value:
        '\\     Type        Description
        '\\     String      The HTML string of the content
        '\\
        '\\ Revisions:
        '\\     Date        By      Description
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        'Public Shared Property QuestionContent(ByVal intType As Integer) As String
        '    Get
        '        'Get the collection from the current session
        '        Dim contentDictionary As Dictionary(Of Integer, String)
        '        contentDictionary = TryCast(System.Web.HttpContext.Current.Session("ContentDictionary"), Dictionary(Of Integer, String))

        '        'if collection doesn't exist return an empty string
        '        If contentDictionary Is Nothing Then
        '            Return String.Empty
        '        End If

        '        'Return the HTML string
        '        Return contentDictionary(intType)
        '    End Get
        '    Set(ByVal Value As String)
        '        'Get the collection from the current session
        '        Dim contentDictionary As Dictionary(Of Integer, String)
        '        contentDictionary = DirectCast(System.Web.HttpContext.Current.Session("ContentDictionary"), Dictionary(Of Integer, String))

        '        'if the collection doesn't exist then create a new one
        '        If contentDictionary Is Nothing Then
        '            contentDictionary = New Dictionary(Of Integer, String)
        '            System.Web.HttpContext.Current.Session("ContentDictionary") = contentDictionary
        '        End If

        '        'store the HTML string into the collection
        '        contentDictionary(intType) = Value
        '    End Set
        'End Property

        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        '\\ Copyright © National Research Corporation
        '\\
        '\\ Routine Name:   SaveQuestionContent
        '\\
        '\\ Created By:     Joe Camp
        '\\         Date:   08-06-2003
        '\\
        '\\ Description:    Saves the content HTML for the question that is currently
        '\\                 loaded into the session object into the database
        '\\
        '\\ Parameters:
        '\\     Name            Type        Description
        '\\     intContentType  Integer     The ID of the content type (ie. quick check, importance, etc.)
        '\\     intCore         Integer     The ID of the question core being updated
        '\\     strHTML         String      The HTML string of content
        '\\
        '\\ Revisions:
        '\\     Date        By      Description
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        'Public Shared Sub SaveQuestionContent(ByVal intCore As Integer, ByVal contentType As QuestionContentType, ByVal strHTML As String, ByVal bNewContent As Boolean)
        '    Dim cmd As DbCommand = Db.GetStoredProcCommand("SP_TK_UpdateContentData", intCore, contentType, strHTML, bNewContent)
        '    ExecuteNonQuery(cmd)
        'End Sub


#End Region

#Region " Dimension Experts "
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        '\\ Copyright © National Research Corporation
        '\\
        '\\ Routine Name:   GetExperts
        '\\
        '\\ Created By:     Joe Camp
        '\\         Date:   10-26-2004
        '\\
        '\\ Description:    Returns a list of dimension experts
        '\\                 
        '\\
        '\\ Parameters:
        '\\     Name            Type        Description
        '\\     expertID        Integer     The ID of a specific Expert to retrieve.  If 0 then return all
        '\\
        '\\ Revisions:
        '\\     Date        By      Description
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        'Public Shared Function GetExperts(ByVal expertID As Integer) As IDataReader
        '    Dim expertIdParam As Object
        '    If expertID = 0 Then
        '        expertIdParam = DBNull.Value
        '    Else
        '        expertIdParam = expertID
        '    End If
        '    Dim cmd As DbCommand = Db.GetStoredProcCommand("SP_TK_GetExperts", expertID)
        '    Return ExecuteReader(cmd)
        'End Function

        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        '\\ Copyright © National Research Corporation
        '\\
        '\\ Routine Name:   GetExperts (Overload)
        '\\
        '\\ Created By:     Joe Camp
        '\\         Date:   10-26-2004
        '\\
        '\\ Description:    Returns a list of all dimension experts
        '\\                 
        '\\
        '\\ Parameters:
        '\\     Name            Type        Description
        '\\
        '\\ Revisions:
        '\\     Date        By      Description
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        'Public Shared Function GetExperts() As IDataReader
        '    Return GetExperts(0)
        'End Function

        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        '\\ Copyright © National Research Corporation
        '\\
        '\\ Routine Name:   GetDimensionExpert
        '\\
        '\\ Created By:     Joe Camp
        '\\         Date:   10-26-2004
        '\\
        '\\ Description:    Returns expert associated with a dimension
        '\\                 
        '\\
        '\\ Parameters:
        '\\     Name            Type        Description
        '\\
        '\\ Revisions:
        '\\     Date        By      Description
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        'Public Shared Function GetDimensionExpert(ByVal dimensionID As Integer) As Integer
        '    'Get the connection string and create SQL connection 
        '    Dim strConn As String = GetSQLConnectString("Toolkit")
        '    Dim objConn As New SqlConnection(strConn)
        '    Dim rdr As IDataReader

        '    'Create the SP Command and add parameter
        '    Dim cmdContent As SqlCommand = objConn.CreateCommand
        '    With cmdContent
        '        .CommandType = CommandType.StoredProcedure
        '        .CommandTimeout = AppConfig.Instance.SqlCommandTimeout
        '        .CommandText = "SP_TK_GetDimensionExpert"
        '        .Parameters.Add("@Dimension_id", SqlDbType.Int).Value = dimensionID


        '        'ExecuteNonQuery requires open connection
        '        .Connection.Open()
        '    End With

        '    'Execute the command 
        '    rdr = cmdContent.ExecuteReader

        '    Try
        '        If rdr.Read Then
        '            Return rdr("Expert_id")
        '        Else
        '            Return 0
        '        End If
        '    Finally
        '        rdr.Close()
        '    End Try

        'End Function

        'Public Shared Sub SetDimensionExpert(ByVal dimensionID As Integer, ByVal expertID As Integer)
        '    'Get the connection string and create SQL connection 
        '    Dim strConn As String = GetSQLConnectString("Toolkit")
        '    Dim objConn As New SqlConnection(strConn)

        '    'Create the SP Command and add parameter
        '    Dim cmdContent As SqlCommand = objConn.CreateCommand
        '    With cmdContent
        '        .CommandType = CommandType.StoredProcedure
        '        .CommandTimeout = AppConfig.Instance.SqlCommandTimeout
        '        .CommandText = "SP_TK_DimensionExpert"
        '        .Parameters.Add("@Dimension_id", SqlDbType.Int).Value = dimensionID
        '        .Parameters.Add("@Expert_id", SqlDbType.Int).Value = expertID

        '        'ExecuteNonQuery requires open connection
        '        .Connection.Open()
        '    End With

        '    'Execute the command 
        '    cmdContent.ExecuteNonQuery()

        '    'Close the connection
        '    cmdContent.Connection.Close()
        'End Sub

        'Public Shared Sub UpdateExpert(ByVal expertID As Integer, ByVal expertName As String, ByVal expertEmail As String, ByVal expertBio As String, ByVal expertImg As Byte())
        '    'Get the connection string and create SQL connection 
        '    Dim strConn As String = GetSQLConnectString("Toolkit")
        '    Dim objConn As New SqlConnection(strConn)

        '    'Create the SP Command and add parameter
        '    Dim cmdContent As SqlCommand = objConn.CreateCommand
        '    With cmdContent
        '        .CommandType = CommandType.StoredProcedure
        '        .CommandTimeout = AppConfig.Instance.SqlCommandTimeout
        '        .CommandText = "SP_TK_SaveExpert"
        '        .Parameters.Add("@Expert_id", SqlDbType.Int).Value = expertID
        '        .Parameters.Add("@strExpertName", SqlDbType.VarChar).Value = expertName
        '        .Parameters.Add("@strExpertEmail", SqlDbType.VarChar).Value = expertEmail
        '        .Parameters.Add("@ExpertText", SqlDbType.Text).Value = expertBio
        '        .Parameters.Add("@ExpertPicture", SqlDbType.Image).Value = expertImg

        '        'ExecuteNonQuery requires open connection
        '        .Connection.Open()
        '    End With

        '    'Execute the command 
        '    cmdContent.ExecuteNonQuery()

        '    'Close the connection
        '    cmdContent.Connection.Close()
        'End Sub
#End Region

#Region " Trendline Functions "
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        '\\ Copyright © National Research Corporation
        '\\
        '\\ Routine Name:   GetExperts
        '\\
        '\\ Created By:     Joe Camp
        '\\         Date:   10-26-2004
        '\\
        '\\ Description:    Returns a list of dimension experts
        '\\                 
        '\\
        '\\ Parameters:
        '\\     Name            Type        Description
        '\\     expertID        Integer     The ID of a specific Expert to retrieve.  If 0 then return all
        '\\
        '\\ Revisions:
        '\\     Date        By      Description
        '\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        Public Function RegisterReport(ByVal questionId As Integer, ByVal type As EReportsChartType) As Integer
            Dim unitList As String = Me.BuildUnitList
            Dim cmd As DbCommand = Db.GetStoredProcCommand("SP_TK_TrendReport", mintSelectedGroupId, questionId, unitList, MemberGroupPreference.ReportStartDate, MemberGroupPreference.ReportEndDate, type)
            Return ExecuteInteger(cmd)
        End Function
#End Region

#End Region

#Region " Private Methods "

        'Private Sub PopQualityPrograms()
        '    Dim cmd As DbCommand = Db.GetStoredProcCommand("sp_TK_QualityProgram_lst")
        '    Db.AddInParameter(cmd, "@ClientUser_id", DbType.Int32, mintSelectedGroupId)

        '    mobjQualityProgramsDs = ExecuteDataSet(cmd)
        '    mobjqualityprogramsds.Tables(0).TableName = "QualityPrograms"
        'End Sub

        Private Sub PopCompDatasets()
            Dim cmd As DbCommand = Db.GetStoredProcCommand("sp_TK_CompDataset_lst")
            Db.AddInParameter(cmd, "@ClientUser_id", DbType.Int32, mintSelectedGroupId)

            mobjCompDatasetsDs = ExecuteDataSet(cmd)
            mobjCompDatasetsDs.Tables(0).TableName = "CompDatasets"
        End Sub

        Private Sub PopServiceTypes()
            Dim cmd As DbCommand = Db.GetStoredProcCommand("sp_TK_Dimension")
            Db.AddInParameter(cmd, "@Dimension_id", DbType.Int32, 0)
            Db.AddInParameter(cmd, "@User_id", DbType.Int32, mintSelectedGroupId)

            mobjServiceTypesDs = ExecuteDataSet(cmd)
            mobjServiceTypesDs.Tables(0).TableName = "ServiceTypes"
        End Sub

        Private Function BuildUnitList() As String
            Dim intID As Integer
            Dim intCnt As Integer
            Dim strUnitList As String = ""

            If IsNumeric(MemberGroupPreference.SelectedUnit) Then
                strUnitList = MemberGroupPreference.SelectedUnit
            ElseIf MemberGroupPreference.SelectedUnit.ToUpper.StartsWith("CL") Then
                intID = CInt(MemberGroupPreference.SelectedUnit.Substring(2))
                For intCnt = 0 To UBound(maobjUnitLookups)
                    If maobjUnitLookups(intCnt).intClientID = intID Then
                        strUnitList = maobjUnitLookups(intCnt).strUnitList
                        Exit For
                    End If
                Next
            ElseIf MemberGroupPreference.SelectedUnit.ToUpper.StartsWith("ST") Then
                intID = CInt(MemberGroupPreference.SelectedUnit.Substring(2))
                For intCnt = 0 To UBound(maobjUnitLookups)
                    If maobjUnitLookups(intCnt).intStudyID = intID Then
                        strUnitList = maobjUnitLookups(intCnt).strUnitList
                        Exit For
                    End If
                Next
            ElseIf MemberGroupPreference.SelectedUnit.ToUpper.StartsWith("SV") Then
                intID = CInt(MemberGroupPreference.SelectedUnit.Substring(2))
                For intCnt = 0 To UBound(maobjUnitLookups)
                    If maobjUnitLookups(intCnt).intSurveyID = intID Then
                        strUnitList = maobjUnitLookups(intCnt).strUnitList
                        Exit For
                    End If
                Next
            End If

            Return strUnitList
        End Function

#End Region

        Public Sub Invalidate()
            mbolDimDataLoaded = False
        End Sub

        Private Sub OnPreferenceChanged(ByVal sender As Object, ByVal e As System.ComponentModel.PropertyChangedEventArgs)
            Dim base As BusinessBase = TryCast(sender, BusinessBase)
            If base IsNot Nothing AndAlso base.IsDirty = False Then Return
            Select Case e.PropertyName
                Case "ReportStartDate", "ReportEndDate", "QualityProgramId", "CompDatasetId", "AnalysisId", "SelectedUnit"
                    mbolDimDataLoaded = False
                Case "ServiceTypeId"
                    mbolDimDataLoaded = False
                    mbolAvailUnitsLoaded = False
                    mUnitTree = Nothing
                Case "SelectedViewId"
                    ' No-op
                Case Else
                    ' TODO: Uncomment the following line for debugging this routine...
                    'Throw New ArgumentOutOfRangeException("e.PropertyName", e.PropertyName, "Unexpected property changed")
            End Select
        End Sub

    End Class

End Namespace