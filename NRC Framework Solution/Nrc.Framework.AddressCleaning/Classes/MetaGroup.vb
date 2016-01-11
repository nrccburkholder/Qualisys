Imports Nrc.Framework.BusinessLogic

Public Interface IMetaGroup

    Property GroupID() As Integer

End Interface

''' <summary>
''' This file contains the definition of the MetaGroup object used to hold 
''' all the required information about a single name or address including a 
''' collection of MetaFields that identify each that is part of this name 
''' or address.
''' </summary>
''' <remarks></remarks>
<Serializable()> _
Public Class MetaGroup
    Inherits BusinessBase(Of MetaGroup)
    Implements IMetaGroup

#Region " Private Fields "

    Private mInstanceGuid As Guid = Guid.NewGuid
    Private mGroupID As Integer
    Private mGroupName As String = String.Empty
    Private mGroupType As String = String.Empty
    Private mCleanDefault As Boolean
    Private mTableID As Integer
    Private mTableName As String = String.Empty
    Private mKeyFieldName As String = String.Empty
    Private mSelected As Boolean
    Private mQtyUpdated As Integer
    Private mQtyErrors As Integer
    Private mQtyRemaining As Integer
    Private mQtyTotal As Integer
    Private mProperCase As Boolean
    Private mDuration As TimeSpan = New TimeSpan(0)

    Private mMetaFields As MetaFieldCollection

#End Region

#Region " Public Properties "

    Public Property GroupID() As Integer Implements IMetaGroup.GroupID
        Get
            Return mGroupID
        End Get
        Private Set(ByVal value As Integer)
            If Not value = mGroupID Then
                mGroupID = value
                PropertyHasChanged("GroupID")
            End If
        End Set
    End Property

    Public Property GroupName() As String
        Get
            Return mGroupName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mGroupName Then
                mGroupName = value
                PropertyHasChanged("GroupName")
            End If
        End Set
    End Property

    Public Property GroupType() As String
        Get
            Return mGroupType
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mGroupType Then
                mGroupType = value
                PropertyHasChanged("GroupType")
            End If
        End Set
    End Property

    Public Property CleanDefault() As Boolean
        Get
            Return mCleanDefault
        End Get
        Set(ByVal value As Boolean)
            If Not value = mCleanDefault Then
                mCleanDefault = value
                PropertyHasChanged("CleanDefault")
            End If
        End Set
    End Property

    Public Property TableName() As String
        Get
            Return mTableName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mTableName Then
                mTableName = value
                PropertyHasChanged("TableName")
            End If
        End Set
    End Property

    Public Property Selected() As Boolean
        Get
            Return mSelected
        End Get
        Set(ByVal value As Boolean)
            If Not value = mSelected Then
                mSelected = value
                PropertyHasChanged("Selected")
            End If
        End Set
    End Property

    Public Property QtyUpdated() As Integer
        Get
            Return mQtyUpdated
        End Get
        Set(ByVal value As Integer)
            If Not value = mQtyUpdated Then
                mQtyUpdated = value
                PropertyHasChanged("QtyUpdated")
            End If
        End Set
    End Property

    Public Property QtyErrors() As Integer
        Get
            Return mQtyErrors
        End Get
        Set(ByVal value As Integer)
            If Not value = mQtyErrors Then
                mQtyErrors = value
                PropertyHasChanged("QtyErrors")
            End If
        End Set
    End Property

    Public Property QtyRemaining() As Integer
        Get
            Return mQtyRemaining
        End Get
        Set(ByVal value As Integer)
            If Not value = mQtyRemaining Then
                mQtyRemaining = value
                PropertyHasChanged("QtyRemaining")
            End If
        End Set
    End Property

    Public Property QtyTotal() As Integer
        Get
            Return mQtyTotal
        End Get
        Set(ByVal value As Integer)
            If Not value = mQtyTotal Then
                mQtyTotal = value
                PropertyHasChanged("QtyTotal")
            End If
        End Set
    End Property

    Public Property ProperCase() As Boolean
        Get
            Return mProperCase
        End Get
        Set(ByVal value As Boolean)
            If Not value = mProperCase Then
                mProperCase = value
                PropertyHasChanged("ProperCase")
            End If
        End Set
    End Property

    Public Property Duration() As TimeSpan
        Get
            Return mDuration
        End Get
        Set(ByVal value As TimeSpan)
            If Not value = mDuration Then
                mDuration = value
                PropertyHasChanged("Duration")
            End If
        End Set
    End Property

#End Region

#Region " Friend Properties "

    Friend Property TableID() As Integer
        Get
            Return mTableID
        End Get
        Set(ByVal value As Integer)
            If Not value = mTableID Then
                mTableID = value
                PropertyHasChanged("TableID")
            End If
        End Set
    End Property

    Friend Property KeyFieldName() As String
        Get
            Return mKeyFieldName
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If Not value = mKeyFieldName Then
                mKeyFieldName = value
                PropertyHasChanged("KeyFieldName")
            End If
        End Set
    End Property

#End Region

#Region " Friend ReadOnly Properties "

    Friend ReadOnly Property MetaFields() As MetaFieldCollection
        Get
            Return mMetaFields
        End Get
    End Property

    ''' <summary>
    ''' Returns the formated list of fields used in a select statement to 
    ''' get the information about this name or address from the study table.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend ReadOnly Property SelectFieldList() As String
        Get
            Dim fieldList As String = String.Empty

            'Loop through all of the meta fields in this collection
            For Each metaFld As MetaField In mMetaFields
                If fieldList.Length > 0 Then fieldList &= ", "
                fieldList &= String.Format("{0} AS {1}", metaFld.FieldName, metaFld.ParamName)
            Next metaFld

            Return fieldList
        End Get
    End Property

    ''' <summary>
    ''' Returns the name of the field that contains the error information 
    ''' for this address.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend ReadOnly Property ErrorFieldName() As String
        Get
            Dim errorField As String = String.Empty

            'Find the status field
            For Each metaFld As MetaField In mMetaFields
                If metaFld.ParamName = "FieldAddrErrorCode" And IsAddress() Then
                    errorField = metaFld.FieldName
                    Exit For
                End If
            Next metaFld

            Return errorField
        End Get
    End Property

    ''' <summary>
    ''' Returns the name of the field that contains the status information 
    ''' for this name or address.
    ''' </summary>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend ReadOnly Property StatusFieldName() As String
        Get
            Dim statusField As String = String.Empty

            'Find the status field
            For Each metaFld As MetaField In mMetaFields
                If metaFld.ParamName = "FieldAddrNameStatus" And IsName() Then
                    statusField = metaFld.FieldName
                    Exit For
                ElseIf metaFld.ParamName = "FieldAddrStatusCode" And IsAddress() Then
                    statusField = metaFld.FieldName
                    Exit For
                End If
            Next metaFld

            Return statusField
        End Get
    End Property

    ''' <summary>
    ''' Returns the name of the table that this name or address is contained in.
    ''' </summary>
    ''' <param name="studyID">The StudyID for the specified table name</param>
    ''' <param name="tableSuffix">The suffix for the table name if one is needed. Default is [_Load]"</param>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend ReadOnly Property SQLTableName(ByVal studyID As Integer, Optional ByVal tableSuffix As String = "_Load") As String
        Get
            Return String.Format("s{0}.{1}{2}", studyID, mTableName, tableSuffix)
        End Get
    End Property

    ''' <summary>
    ''' Returns the field and value list required for the SQL UPDATE statement.
    ''' </summary>
    ''' <param name="address">The address object that is to be inserted into the database.</param>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend ReadOnly Property UpdateFieldListAddress(ByVal address As Address) As String
        Get
            Dim thisField As String = String.Empty
            Dim updateList As String = String.Empty

            'Loop through all of the fields
            For Each metaFld As MetaField In mMetaFields
                With metaFld
                    'Get the update field and value for this field
                    Select Case .ParamName
                        Case "FieldAddrStreet1"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(CleanString(address.CleanedAddress.StreetLine1, True, True)))

                        Case "FieldAddrStreet2"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(CleanString(address.CleanedAddress.StreetLine2, True, True)))

                        Case "FieldAddrCity"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(address.CleanedAddress.City))

                        Case "FieldAddrState"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(address.CleanedAddress.State))

                        Case "FieldAddrCountry"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(address.CleanedAddress.Country))

                        Case "FieldAddrZip5"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(address.CleanedAddress.Zip5))

                        Case "FieldAddrZip4"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(address.CleanedAddress.Zip4))

                        Case "FieldAddrProvince"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(address.CleanedAddress.Province))

                        Case "FieldAddrPostal"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(address.CleanedAddress.Postal))

                        Case "FieldAddrDel_Pt"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(address.CleanedAddress.DeliveryPoint))

                        Case "FieldAddrCarrier"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(address.CleanedAddress.Carrier))

                        Case "FieldAddrErrorCode"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(address.CleanedAddress.AddressError))

                        Case "FieldAddrStatusCode"
                            thisField = String.Format("{0} = '{1}'", .FieldName, address.CleanedAddress.AddressStatus)

                        Case "FieldAddrTimeZone"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(address.GeoCode.TimeZoneName))

                        Case "FieldAddrFipsState"
                            Dim fieldVal As String = ExtractFIPSIntegerValue(address.GeoCode.CountyFIPS, 1, 2)
                            thisField = String.Format("{0} = {1}", .FieldName, fieldVal)

                        Case "FieldAddrFipsCounty"
                            Dim fieldVal As String = ExtractFIPSIntegerValue(address.GeoCode.CountyFIPS, 3, 3)
                            thisField = String.Format("{0} = {1}", .FieldName, fieldVal)

                    End Select

                    'Add this field to the list
                    If updateList.Length > 0 Then updateList &= ", "
                    updateList &= thisField
                End With
            Next metaFld

            Return updateList

        End Get
    End Property

    ''' <summary>
    ''' Takes the FIPS string, substrings the given range, checks if it can be parsed to as an Integer
    ''' If it isn't then it will return the "0" string
    ''' </summary>
    ''' <param name="fieldVal"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function ExtractFIPSIntegerValue(sourceString As String, startIdx As Integer, length As Integer) As String
        Dim fieldVal As String
        Try
            fieldVal = GetFieldValue(sourceString).Substring(startIdx, length)
            Dim discardInt As Integer
            If (Integer.TryParse(fieldVal, discardInt) = False) Then
                fieldVal = "0"
            End If
        Catch
            fieldVal = "0"
        End Try
        Return fieldVal
    End Function

    ''' <summary>
    ''' Returns the field and value list required for the SQL UPDATE statement.
    ''' </summary>
    ''' <param name="name">The name object that is to be inserted into the database.</param>
    ''' <value></value>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Friend ReadOnly Property UpdateFieldListName(ByVal name As Name) As String
        Get
            Dim thisField As String = String.Empty
            Dim updateList As String = String.Empty

            'Loop through all of the fields
            For Each metaFld As MetaField In mMetaFields
                With metaFld
                    'Get the update field and value for this field
                    Select Case .ParamName
                        Case "FieldAddrTitleName"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(name.CleanedName.Title))

                        Case "FieldAddrFName"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(name.CleanedName.FirstName))

                        Case "FieldAddrMName"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(name.CleanedName.MiddleInitial))

                        Case "FieldAddrLName"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(name.CleanedName.LastName))

                        Case "FieldAddrSuffixName"
                            thisField = String.Format("{0} = {1}", .FieldName, GetFieldValue(name.CleanedName.Suffix))

                        Case "FieldAddrNameStatus"
                            thisField = String.Format("{0} = '{1}'", .FieldName, name.CleanedName.NameStatus)

                    End Select

                    'Add this field to the list
                    If updateList.Length > 0 Then updateList &= ", "
                    updateList &= thisField
                End With
            Next metaFld

            Return updateList

        End Get
    End Property

    Friend ReadOnly Property RecordType() As String
        Get
            If IsAddress() Then
                Return "Address"
            Else
                Return "Name"
            End If
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

        CreateNew()

    End Sub

#End Region

#Region " Factory Methods "

    Friend Shared Function NewMetaGroup() As MetaGroup

        Return New MetaGroup

    End Function

    Friend Shared Function GetByStudyID(ByVal studyID As Integer) As MetaGroupCollection

        Return MetaGroupProvider.SelectMetaGroupsByStudyID(studyID)

    End Function

#End Region

#Region " Basic Overrides "

    Protected Overrides Function GetIdValue() As Object

        If IsNew Then
            Return mInstanceGuid
        Else
            Return mGroupID
        End If

    End Function

#End Region

#Region " Validation "

    Protected Overrides Sub AddBusinessRules()

        'Add validation rules here...

    End Sub

#End Region

#Region " Data Access "

    Protected Overrides Sub CreateNew()

        'Set default values here
        mSelected = False
        mMetaFields = New MetaFieldCollection

        'Optionally finish by validating default values
        ValidationRules.CheckRules()

    End Sub

    ''' <summary>
    ''' This method stores all of the count properties for each group in the 
    ''' collection to the Loading Database so they can be used for reporting 
    ''' purposes.
    ''' </summary>
    ''' <param name="dataFileID">The data file that this collection is for.</param>
    ''' <remarks></remarks>
    Public Shared Sub SaveCounts(ByVal dataFileID As Integer, ByVal metaGroups As MetaGroupCollection, ByVal loadDB As LoadDatabases)

        MetaGroupProvider.SaveMetaGroupCounts(dataFileID, metaGroups, loadDB)

    End Sub

    ''' <summary>
    ''' This routine sets the count properties for each group in the 
    ''' collection.  These properties can be used by the calling application 
    ''' for display info after the CPostalSoft.CleanAll method completes.
    ''' </summary>
    ''' <param name="dataFileID">The data file that this collection is for.</param>
    ''' <param name="studyID">The study that this collection is for.</param>
    ''' <remarks></remarks>
    Friend Shared Sub GetCounts(ByVal dataFileID As Integer, ByVal studyID As Integer, ByVal metaGroups As MetaGroupCollection, ByVal loadDB As LoadDatabases)

        MetaGroupProvider.GetMetaGroupCounts(dataFileID, studyID, metaGroups, loadDB)

    End Sub

#End Region

#Region " Public Methods "

    Public Function IsAddress() As Boolean

        IsAddress = (mGroupType = "A")

    End Function

    Public Function IsName() As Boolean

        IsName = (mGroupType = "N")

    End Function

#End Region

#Region " Private Methods "

    Private Function GetFieldValue(ByVal field As String) As String

        If field.Length = 0 Then
            Return "NULL"
        Else
            Return String.Format("'{0}'", field)
        End If

    End Function

#End Region

End Class