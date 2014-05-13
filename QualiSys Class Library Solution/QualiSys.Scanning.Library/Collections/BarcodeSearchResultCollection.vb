Imports System.IO
Imports Nrc.QualiSys.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class BarcodeSearchResultCollection
    Inherits System.Collections.CollectionBase

#Region "Private Members"

#End Region

#Region "Events"

    Public Event BarcodeFileSearchBegin As EventHandler(Of BarcodeFileSearchBeginEventArgs)
    Public Event BarcodeFileSearchComplete As EventHandler(Of BarcodeFileSearchCompleteEventArgs)

#End Region

#Region "Public Properties"

    Default Public ReadOnly Property Item(ByVal index As Integer) As BarcodeSearchResult
        Get
            Return DirectCast(MyBase.List(index), BarcodeSearchResult)
        End Get
    End Property

#End Region

#Region "Public Methods"

    Public Function Add(ByVal newSearchResult As BarcodeSearchResult) As Integer

        Return MyBase.List.Add(newSearchResult)

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="faqssLocation"></param>
    ''' <param name="archiveFolder"></param>
    ''' <param name="templatePattern"></param>
    ''' <param name="useBatchDates"></param>
    ''' <param name="batchDateRangeFrom"></param>
    ''' <param name="batchDateRangeTo"></param>
    ''' <param name="searchStrings"></param>
    ''' <param name="partialBarcodes"></param>
    ''' <param name="startingPosition"></param>
    ''' <param name="exactLocation"></param>
    ''' <remarks></remarks>
    Public Sub Populate(ByVal faqssLocation As FAQSSLocation, ByVal archiveFolder As String, _
                        ByVal templatePattern As String, ByVal useBatchDates As Boolean, _
                        ByVal batchDateRangeFrom As Date, ByVal batchDateRangeTo As Date, _
                        ByVal searchStrings As List(Of String), ByVal partialBarcodes As Boolean, _
                        ByVal startingPosition As Integer, ByVal exactLocation As Boolean)

        Dim faqssFolder As String = String.Empty

        'Set the To date to "23:59:59"
        batchDateRangeTo = batchDateRangeTo.AddDays(1).AddSeconds(-1)

        'Get the FAQSS location 
        Select Case faqssLocation
            Case Library.FAQSSLocation.Archive
                If archiveFolder = "<all>" Then
                    'The user wants to search all of the Archive FAQSS folders so loop through them
                    Dim archiveFolders As List(Of String) = BarcodeSearchResultCollection.GetArchiveFolders(False)
                    For Each folder As String In archiveFolders
                        'Determine the FAQSS folder to be searched
                        faqssFolder = Path.Combine(AppConfig.Params("FAQSSArchive").StringValue, folder)
                        Dim completed As Boolean = CheckFAQSSFolder(faqssFolder, templatePattern, useBatchDates, batchDateRangeFrom, batchDateRangeTo, _
                                                     searchStrings, partialBarcodes, startingPosition, exactLocation)

                        'If the user canceled then we are done
                        If Not completed Then Exit Sub
                    Next
                Else
                    'The user specified the archive folder to be searched
                    faqssFolder = Path.Combine(AppConfig.Params("FAQSSArchive").StringValue, archiveFolder)
                    CheckFAQSSFolder(faqssFolder, templatePattern, useBatchDates, batchDateRangeFrom, batchDateRangeTo, _
                                     searchStrings, partialBarcodes, startingPosition, exactLocation)
                End If

            Case Library.FAQSSLocation.Production
                'The user specified to search the Production FAQSS folder
                faqssFolder = AppConfig.Params("FAQSSProduction").StringValue
                CheckFAQSSFolder(faqssFolder, templatePattern, useBatchDates, batchDateRangeFrom, batchDateRangeTo, _
                                 searchStrings, partialBarcodes, startingPosition, exactLocation)

        End Select

    End Sub

    ''' <summary>
    ''' The CheckFAQSSFolder function searches the specified FAQSS folder for matching barcodes.
    ''' </summary>
    ''' <param name="faqssFolder">The path to the root of a FAQSS folder.</param>
    ''' <param name="templatePattern">The pattern to be used when searching Template folders.  Wildcards are acceptable.</param>
    ''' <param name="useBatchDates">Boolean indicating whether or not to use <paramref name="batchDateRangeFrom"/> and <paramref name="batchDateRangeTo"/> when searching the Batches.</param>
    ''' <param name="batchDateRangeFrom">The beginning date to be used when searching Batches.</param>
    ''' <param name="batchDateRangeTo">The ending date to be used when searching Batches.</param>
    ''' <param name="searchStrings">List of Barcodes to be searched for.</param>
    ''' <param name="partialBarcodes">Boolean indicating whether or not the <paramref name="searchStrings"/> are full or partial.</param>
    ''' <param name="startingPosition">Starting position to begin searching within a Barcode if <paramref name="partialBarcodes"/> is True.</param>
    ''' <param name="exactLocation">Boolean indicating whether the <paramref name="startingPosition"/> is to be treated as the first character in a match or if the match can occur anywhere after <paramref name="startingPosition"/></param>
    ''' <returns>Returns TRUE if the search of this folder completed normally, FALSE if the user canceled.</returns>
    ''' <remarks></remarks>
    Private Function CheckFAQSSFolder(ByVal faqssFolder As String, _
                                      ByVal templatePattern As String, ByVal useBatchDates As Boolean, _
                                      ByVal batchDateRangeFrom As Date, ByVal batchDateRangeTo As Date, _
                                      ByVal searchStrings As List(Of String), ByVal partialBarcodes As Boolean, _
                                      ByVal startingPosition As Integer, ByVal exactLocation As Boolean) As Boolean

        'Loop through templates
        Dim faqssDir As New DirectoryInfo(faqssFolder)
        For Each templateDir As DirectoryInfo In faqssDir.GetDirectories(templatePattern)
            'We found a matching template so let's look through the batches
            For Each batchDir As DirectoryInfo In templateDir.GetDirectories
                'Get the barcode file
                Dim barcodeFile As New FileInfo(Path.Combine(batchDir.FullName, "barcodes."))
                If barcodeFile.Exists Then
                    'Fire the event to display file name
                    Dim beginEventArgs As New BarcodeFileSearchBeginEventArgs(barcodeFile.FullName)
                    RaiseEvent BarcodeFileSearchBegin(Me, beginEventArgs)

                    'Check to see if the user has canceled
                    If beginEventArgs.Cancel Then
                        'The user chose to cancel the search so clear the collection and return false
                        MyBase.List.Clear()
                        RaiseEvent BarcodeFileSearchComplete(Me, New BarcodeFileSearchCompleteEventArgs())
                        Return False
                    End If

                    'The file exists so let's see if the barcode is in there 
                    If Not useBatchDates OrElse (useBatchDates AndAlso barcodeFile.LastWriteTime >= batchDateRangeFrom AndAlso barcodeFile.LastWriteTime <= batchDateRangeTo) Then
                        'Check to see if any of our barcodes exist in this file
                        CheckFile(barcodeFile, searchStrings, partialBarcodes, startingPosition, exactLocation)
                    End If

                    'Fire event to clear file name
                    Dim completeEventArgs As New BarcodeFileSearchCompleteEventArgs()
                    RaiseEvent BarcodeFileSearchComplete(Me, completeEventArgs)

                    'Check to see if the user has canceled
                    If completeEventArgs.Cancel Then
                        'The user chose to cancel the search so clear the collection and return false
                        MyBase.List.Clear()
                        RaiseEvent BarcodeFileSearchComplete(Me, New BarcodeFileSearchCompleteEventArgs())
                        Return False
                    End If
                End If
            Next
        Next

        'The search completed so return True
        Return True

    End Function

    Public Sub CreateSTRFile(ByVal fileName As String)

        Dim strInfo As New FileInfo(fileName)
        Dim strFile As StreamWriter = New StreamWriter(strInfo.FullName, False, System.Text.Encoding.ASCII)

        For Each searchResult As BarcodeSearchResult In MyBase.List
            If searchResult.Selected AndAlso searchResult.StringFileLine.Length > 0 Then
                strFile.WriteLine(searchResult.StringFileLine)
            End If
        Next

        strFile.Flush()
        strFile.Close()

    End Sub

    Public Shared Function GetArchiveFolders(ByVal includeAllOption As Boolean) As List(Of String)

        Dim folders As New List(Of String)

        Dim archiveDir As New DirectoryInfo(AppConfig.Params("FAQSSArchive").StringValue)
        If archiveDir.Exists Then
            'Add each folder that starts with FAQSS
            For Each faqssDir As DirectoryInfo In archiveDir.GetDirectories("faqss*")
                folders.Add(faqssDir.Name)
            Next

            'If the we are including the All option then add it to the beginning of the list
            If includeAllOption AndAlso folders.Count > 0 Then
                folders.Insert(0, "<all>")
            End If
        End If

        Return folders

    End Function

#End Region

#Region "Private Methods"

    Private Sub CheckFile(ByVal barcodeFile As FileInfo, ByVal searchStrings As List(Of String), _
                          ByVal partialBarcodes As Boolean, ByVal startingPosition As Integer, _
                          ByVal exactLocation As Boolean)

        Dim thisFile As StreamReader = New StreamReader(barcodeFile.FullName)
        Dim barcode As String = String.Empty
        Dim lineNum As Integer = 0

        'Loop through the whole file
        Do Until thisFile.EndOfStream
            'Get a line from the file
            barcode = thisFile.ReadLine.ToUpper
            lineNum += 1

            'Check to see if this barcode is one we are looking for
            For Each searchString As String In searchStrings
                searchString = searchString.ToUpper
                If IsMatch(barcode, searchString, partialBarcodes, startingPosition, exactLocation) Then
                    'We found a match so add it
                    Dim searchResult As New BarcodeSearchResult(searchString, barcode, lineNum, barcodeFile.FullName)

                    'Add this result to the collection
                    Add(searchResult)

                    'Now find the string file
                    GetStringFileInfo(searchResult, barcodeFile)
                End If
            Next
        Loop

        'Close the file
        thisFile.Close()

    End Sub

    Private Function IsMatch(ByVal barcode As String, ByVal searchString As String, ByVal partialBarcodes As Boolean, _
                             ByVal startingPosition As Integer, ByVal exactLocation As Boolean) As Boolean

        If partialBarcodes Then
            If exactLocation Then
                Return (barcode.Substring(startingPosition - 1, searchString.Length) = searchString.ToUpper)
            Else
                Return (barcode.IndexOf(searchString.ToUpper, startingPosition - 1) > -1)
            End If
        Else
            'Must be exact match
            Return (barcode = searchString.ToUpper)
        End If

    End Function

    Private Sub GetStringFileInfo(ByVal searchResult As BarcodeSearchResult, ByVal barcodeFile As FileInfo)

        Dim batchName As String = barcodeFile.Directory.Name
        Dim finalDir As New DirectoryInfo(Path.Combine(barcodeFile.Directory.Parent.FullName, "Final"))
        Dim found As Boolean = False

        Dim stringFiles As FileInfo() = finalDir.GetFiles(batchName & ".str", SearchOption.AllDirectories)

        For Each stringFile As FileInfo In stringFiles
            'Open the file
            Dim thisFile As StreamReader = New StreamReader(stringFile.FullName)
            Dim stringLine As String = String.Empty
            Dim lineNum As Integer = 0

            'Loop through the whole file
            Do Until thisFile.EndOfStream
                'Get a line from the file
                stringLine = thisFile.ReadLine.ToUpper
                lineNum += 1

                'Determine if this string line contains our barcode
                If (stringLine.IndexOf(searchResult.Barcode) > -1) Then
                    'Add the string file information
                    If Not found Then
                        'This is the first occurance of the barcode
                        found = True
                        With searchResult
                            .StringFileLine = stringLine
                            .StringFileLineNum = lineNum
                            .StringFileName = stringFile.FullName
                        End With
                    Else
                        'This is an additional occurance so we need to add a new searchResult
                        Dim newResult As New BarcodeSearchResult(searchResult.SearchString, searchResult.Barcode, searchResult.BarcodeFileLineNum, searchResult.BarcodeFileName)
                        With newResult
                            .StringFileLine = stringLine
                            .StringFileLineNum = lineNum
                            .StringFileName = stringFile.FullName
                        End With

                        'Add this instance to the collection
                        Add(newResult)
                    End If
                End If
            Loop

            'Close the file
            thisFile.Close()
        Next

    End Sub

#End Region

End Class
