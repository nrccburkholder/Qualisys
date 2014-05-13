Imports Nrc.Framework.BusinessLogic.Configuration

Public Class Cleaner

#Region " Private Members "

    Private mCountryID As CountryIDs
    Private mLoadDB As LoadDatabases
    Private mNames As NameCollection
    Private mAddresses As AddressCollection

    Private Const mkMinCleanBatchSize As Integer = 1000

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property Addresses() As AddressCollection
        Get
            Return mAddresses
        End Get
    End Property

    Public ReadOnly Property Names() As NameCollection
        Get
            Return mNames
        End Get
    End Property

#End Region

#Region " Constructors "

    ''' <summary>
    ''' Creates a new instance of the Cleaner object.
    ''' </summary>
    ''' <param name="countryID">Country that is to be used to perform cleaning.</param>
    ''' <remarks>Allows user to specify the country directory to be used for cleaning.</remarks>
    Public Sub New(ByVal countryID As CountryIDs, ByVal loadDB As LoadDatabases)

        'Call the base class
        MyBase.New()

        'Store the parameters
        mCountryID = countryID
        mLoadDB = loadDB

        'Create the names collection
        mNames = New NameCollection(countryID)

        'Create the addresses collection
        mAddresses = New AddressCollection(countryID)

    End Sub

#End Region

#Region " Destructors "

    Protected Overrides Sub Finalize()

        'Cleanup the collections
        mNames = Nothing
        mAddresses = Nothing

        'Call the base clase
        MyBase.Finalize()

    End Sub

#End Region

#Region " Public Methods "

    ''' <summary>
    ''' This is the public interface called to initialize the cleaning process 
    ''' if all names and addresses for the specified datafile and study are to 
    ''' be cleaned and you want the status counts before you begin.  If you do 
    ''' not need the status counts prior to starting then just call CleanAll.
    ''' </summary>
    ''' <param name="dataFileID">The datafile to be cleaned.</param>
    ''' <param name="studyID">The study to be cleaned.</param>
    ''' <returns>Returns a reference to the MetaGroups collection so the calling 
    ''' application can obtain the current statistics for this run.</returns>
    ''' <remarks></remarks>
    Public Function GetInitialCounts(ByVal dataFileID As Integer, ByVal studyID As Integer) As MetaGroupCollection

        'Populate the lookup data
        Dim metaGroups As MetaGroupCollection = MetaGroup.GetByStudyID(studyID)

        'Get the counts
        MetaGroup.GetCounts(dataFileID, studyID, metaGroups, mLoadDB)

        'Set the return value and cleanup the lookup data
        Return metaGroups

    End Function

    ''' <summary>
    ''' This is the public interface called to clean all names and addresses 
    ''' for the specified datafile and study.
    ''' </summary>
    ''' <param name="dataFileID">The datafile to be cleaned.</param>
    ''' <param name="studyID">The study to be cleaned.</param>
    ''' <returns>Returns a reference to the MetaGroups collection so the calling 
    ''' application can obtain the current statistics for this run.</returns>
    ''' <remarks></remarks>
    Public Function CleanAll(ByVal dataFileID As Integer, ByVal studyID As Integer, ByVal forceProxy As Boolean) As MetaGroupCollection

        Return CleanAll(dataFileID, studyID, mkMinCleanBatchSize, forceProxy)

    End Function

    ''' <summary>
    ''' This is the public interface called to clean all names and addresses 
    ''' for the specified datafile and study.
    ''' </summary>
    ''' <param name="dataFileID">The datafile to be cleaned.</param>
    ''' <param name="studyID">The study to be cleaned.</param>
    ''' <param name="batchSize">The quantity of records to process on each pass.</param>
    ''' <returns>Returns a reference to the MetaGroups collection so the calling 
    ''' application can obtain the current statistics for this run.</returns>
    ''' <remarks></remarks>
    Public Function CleanAll(ByVal dataFileID As Integer, ByVal studyID As Integer, ByVal batchSize As Integer, ByVal forceProxy As Boolean) As MetaGroupCollection

        Dim metaGroups As MetaGroupCollection = MetaGroup.GetByStudyID(studyID)

        'Setup the groups
        For Each metaGrp As MetaGroup In metaGroups
            metaGrp.Selected = True
        Next metaGrp

        'Get the processing batch size
        If batchSize < mkMinCleanBatchSize Then
            batchSize = mkMinCleanBatchSize
        End If

        'Clean selected names
        mNames.CleanAll(dataFileID, studyID, batchSize, metaGroups, mLoadDB, forceProxy)

        'Clean selected addresses
        mAddresses.CleanAll(dataFileID, studyID, batchSize, metaGroups, mLoadDB, forceProxy)

        'Get the counts
        MetaGroup.GetCounts(dataFileID, studyID, metaGroups, mLoadDB)

        'Set the return value and cleanup the lookup data
        Return metaGroups

    End Function

    ''' <summary>
    ''' This is the public interface called to clean all phone numbers 
    ''' for the specified datafile.
    ''' </summary>
    ''' <param name="dataFileID">The datafile to be cleaned.</param>
    ''' <returns>Returns a TimeSpan representing how long it took to execute.</returns>
    ''' <remarks></remarks>
    Public Function CheckPhone(ByVal dataFileID As Integer) As TimeSpan

        'Store the start time
        Dim startDate As Date = Date.Now

        'Check the phone numbers in the specified file
        PhoneProvider.CheckPhoneNumbers(dataFileID, mLoadDB)

        'Return the duration
        Dim finishDate As Date = Date.Now
        Return finishDate.Subtract(startDate)

    End Function

    ''' <summary>
    ''' This method is used to determine if address cleaning is turned on for the specified study.
    ''' </summary>
    ''' <param name="studyID">The study to be checked.</param>
    ''' <returns>Returns TRUE if address cleaning is turned on.</returns>
    ''' <remarks></remarks>
    Public Function IsCleanAddrBitSet(ByVal studyID As Integer) As Boolean

        Return AddressProvider.SelectCleanAddressBit(studyID)

    End Function

    ''' <summary>
    ''' This method is used to determine if phone number cleaning is turned on for the specified study.
    ''' </summary>
    ''' <param name="studyID">The study to be checked.</param>
    ''' <returns>Returns TRUE if phone number cleaning is turned on.</returns>
    ''' <remarks></remarks>
    Public Function IsCheckPhoneBitSet(ByVal studyID As Integer) As Boolean

        Return PhoneProvider.SelectCleanPhoneBit(studyID)

    End Function

#End Region

End Class
