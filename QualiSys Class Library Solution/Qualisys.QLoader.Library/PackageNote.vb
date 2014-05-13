Imports Nrc.Qualisys.QLoader.Library.SqlProvider
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class PackageNote

#Region " Private Members "

    Private mPackageID As Integer
    Private mPackageNoteID As Integer
    Private mAssociate As String
    Private mVersion As Integer
    Private mDateCreated As Date
    Private mNoteText As String
    Private mIsSaved As Boolean
    Private mConnection As String

#End Region

#Region " Public Properties "

    Public ReadOnly Property PackageID() As Integer
        Get
            Return mPackageID
        End Get
    End Property

    Public ReadOnly Property PackageNoteID() As Integer
        Get
            Return mPackageNoteID
        End Get
    End Property

    Public ReadOnly Property Associate() As String
        Get
            Return mAssociate
        End Get
    End Property

    Public ReadOnly Property Version() As Integer
        Get
            Return mVersion
        End Get
    End Property

    Public ReadOnly Property DateCreated() As Date
        Get
            Return mDateCreated
        End Get
    End Property

    Public Property NoteText() As String
        Get
            Return mNoteText
        End Get
        Set(ByVal Value As String)
            mNoteText = Value
        End Set
    End Property

    Public ReadOnly Property IsSaved() As Boolean
        Get
            Return mIsSaved
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal connection As String)

        'Store the connection and set the default values
        mConnection = connection
        mDateCreated = Date.Today
        mIsSaved = False

    End Sub

    Public Sub New(ByVal connection As String, ByVal packageID As Integer, ByVal userName As String)

        'Call the default contructor
        Me.New(connection)

        'Store the package and user name
        mPackageID = packageID
        mAssociate = userName

    End Sub

#End Region

#Region " Load / Save to database "

    Public Sub SaveToDB()

        'if this note has not been saved
        If Not mIsSaved Then
            Try
                'Call the save SP and mark the note as saved
                PackageDB.SavePackageNote(mAssociate, mPackageID, mNoteText)
                mIsSaved = True

            Catch ex As SqlClient.SqlException
                Throw New Exception("Could not save note to database due to SQL exception: " & ex.Message, ex)

            Catch ex As Exception
                Throw New Exception("Could not save note to database: " & ex.Message, ex)

            End Try
        End If

    End Sub

    'Gets a collection of all the note objects for a certain packageID
    Public Shared Function GetPackageNotes(ByVal packageID As Integer) As PackageNoteCollection

        Dim notes As New PackageNoteCollection
        Dim note As PackageNote
        Dim row As DataRow

        'Get the dataset of notes
        Dim tblNotes As DataTable = PackageDB.GetPackageNotes(packageID)

        'Create a note object for each record in the table
        For Each row In tblNotes.Rows
            note = New PackageNote(AppConfig.QLoaderConnection)
            note.mPackageID = CType(row("Package_id"), Integer)
            note.mPackageNoteID = CType(row("PackageNote_id"), Integer)
            note.mAssociate = row("Associate").ToString
            note.mVersion = CType(row("intVersion"), Integer)
            note.mDateCreated = CType(row("datNoteAdded"), Date)
            note.mNoteText = row("Note").ToString
            note.mIsSaved = True

            notes.Add(note)
        Next

        'Return the collection
        Return notes

    End Function

#End Region

    'Override the ToString() to display date and author of note
    Public Overrides Function ToString() As String

        Return String.Format("{0} ({1})", mDateCreated.ToShortDateString, mAssociate)

    End Function

End Class

#Region " PackageNoteCollection Class"

Public Class PackageNoteCollection
    Inherits System.Collections.CollectionBase

    Default Public Property Item(ByVal index As Integer) As PackageNote
        Get
            Return DirectCast(MyBase.List.Item(index), PackageNote)
        End Get
        Set(ByVal Value As PackageNote)
            MyBase.List.Item(index) = Value
        End Set
    End Property

    Public Function Add(ByVal note As PackageNote) As Integer

        Return MyBase.List.Add(note)

    End Function

    Public Sub Insert(ByVal index As Integer, ByVal note As PackageNote)

        MyBase.List.Insert(index, note)

    End Sub

    'Saves all the notes in the collection to the database
    'if they have been newly added
    Public Sub SaveAllToDB()

        Dim note As PackageNote

        For Each note In Me
            If Not note.IsSaved Then
                note.SaveToDB()
            End If
        Next

    End Sub

End Class

#End Region
