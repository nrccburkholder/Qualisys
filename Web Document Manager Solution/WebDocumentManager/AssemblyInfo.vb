Imports System
Imports System.Reflection
Imports System.Runtime.InteropServices

' General Information about an assembly is controlled through the following 
' set of attributes. Change these attribute values to modify the information
' associated with an assembly.

' Review the values of the assembly attributes

<Assembly: AssemblyTitle("NRCWebDocumentManager")> 
<Assembly: AssemblyDescription("A Web Document Management Utility.")> 
<Assembly: AssemblyCompany("National Research Corporation.")> 
<Assembly: AssemblyProduct("NRCWebDocumentManager")> 
<Assembly: AssemblyCopyright("©2005 National Research  Corporation. All rights reserved.")> 
<Assembly: AssemblyTrademark("")> 
<Assembly: CLSCompliant(True)> 

'The following GUID is for the ID of the typelib if this project is exposed to COM
<Assembly: Guid("B59BBD76-98D4-4057-ACBC-82003627C379")> 

' Version information for an assembly consists of the following four values:
'
'      Major Version - Big Dog
'      Minor Version - Enhancement
'      Build Number - Bug Fix
'      Revision - Recompile
'
' You can specify all the values or you can default the Build and Revision Numbers 
' by using the '*' as shown below:

'[Major Version].[Minor Version].[Build Number].[Revision]
'v0.0.0.1   DC  4/7/2005 - Fixed some more bugs in Document 
'v0.0.0.2   DC  4/12/2005 - Added User rights to Application
'v0.0.0.3   DC  4/13/2005 - Brian added code to make sure PDF file exists for Action Plan
'v1.0.0.0   DC  4/14/2005 - Roll out Version 1!!!!
'v1.0.0.1   DC  4/14/2005 - Brian added some changes to Rollback
'v1.0.0.2   DC  4/15/2005 - Fixed a bug with the changing of TreeGrouping Types
'v1.0.0.3   DC  4/15/2005 - Fixed a bug where deleting didn't ask if you wanted to delete all occurrences
'v1.0.0.4   DC  4/19/2005 - Brian added the AP description to the list view in APB Post
'v1.0.0.5   DC  4/20/2005 - Brian fixed a bug in posting
'v1.0.0.6   BM  4/21/2005 - Brian add some error message
'v1.0.0.7   DC  4/29/2005 - Fixed a bug in Mass Poster that caused it to pass in a nodeID of 0
'v1.0.0.8   DC  4/29/2005 - Made changes to Mass Poster to improve speed
'v1.0.0.9   DC  4/29/2005 - Added code for Mass Poster to correct bad node paths in the spreadsheet
'v1.0.0.10  DC  4/29/2005 - Changed wording in context menus from 'node' to 'folder'
'v1.0.0.11  BM  5/12/2005 - Fix the bug of "No to All" button doesn't work in reposting check
'v1.0.0.12  BM  6/30/2005 - Recompile
'V1.0.0.13  DC  8/26/2005 - Fixed a Data Binding issue the group groups combo box in the document manager control
'v1.0.1.0   BM  8/29/2005 - Adjust control size and location for different screen resolutions
'v1.0.2.0   DC  8/30/2005 - Fixed a bug in mass post where causes "OrgUnit not exists" issue
'v1.0.2.1   DC  9/13/2005 - Fixed a bug that caused an exception when a group does not exist
'v1.0.2.2   DC  12/14/2006 - Fixed a bug that caused an exception when opening the APB Rollback screen during the month of December.

<Assembly: AssemblyVersion("1.1.12.0")> 
<Assembly: AssemblyFileVersionAttribute("1.1.12.0")> 
