Imports System
Imports System.Reflection
Imports System.Runtime.InteropServices

' General Information about an assembly is controlled through the following 
' set of attributes. Change these attribute values to modify the information
' associated with an assembly.

' Review the values of the assembly attributes

<Assembly: AssemblyTitle("Comparison Data Application")> 
<Assembly: AssemblyDescription("A tool to allow users to access comparison data from all clients.")> 
<Assembly: AssemblyCompany("National Research Corporation.")> 
<Assembly: AssemblyProduct("Comparison Data Application")> 
<Assembly: AssemblyCopyright("©2005 National Research Corporation. All rights reserved.")> 
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
'v1.0.0.0   DC 5/20/2005 - First Production Version
'v1.1.0.0   DC 6/12/2005 - Changed to store report params in database and
'                           to allow the user to save their query
'v1.1.0.1   DC 6/12/2005 - Added '23:59:59' to the maximum date parameter to ensure
'                          we pull all returns from that day.
'v1.1.0.2   DC 6/24/2005 - Added code for member Level Privileges.
'v1.1.0.3   DC 7/7/2005  - Made a change to differentiate between using production norm settings
'                          and staging norm settings.  For queries, production is used.  Otherwise
'                          staging is used. 
'v1.1.0.4   BM 7/13/2005 - Show confirm info before scheduling
'v1.1.0.5   DC 7/15/2005 - Added a section for backing up norms
'v1.1.0.6   DC 7/15/2005 - Made a correction to the code that populates the norms
'v1.1.0.7   DC 7/18/2005 - Added more validation to norms creation
'v1.1.0.8   DC 7/21/2005 - Fixed several bugs related to creating and editing norms
'v1.1.0.9   DC 7/25/2005 - Fixed bug related to saving norm changes
'v1.1.0.10  DC 8/11/2005 - Fixed bug related to saving new equivalent question groups
'v1.1.1.0   BM 8/18/2005 - Fixed bug related to norm update scheduler can not be shown
'v1.1.2.0   BM 8/29/2005 - Adjust control size and location for different screen resolutions
'v1.1.3.0   BM 9/7/2005  - Fixed bug related to incorrect step order showing in Canadian norm wizard
'v1.2.0.0   BM 9/22/2005 - Add background selection function to Canada norm module
'v1.2.1.0   DC & BM 9/26/2005 - Added scroll bars to several of the controls since some users could not see the entire screen
'v1.3.0.0   BM 2/8/2005  - Add Canadian benchmark performer report
'v1.3.1.0   BM 2/9/2005  - In Canadian benchmark performer UI, change dimension combo box to list box
'v1.4.0.0   DC 5/17/2006 - Added Deciles norm option
'v1.5.0.0   DC 8/14/2006 - Restored Canadian benchmark performer


<Assembly: AssemblyVersion("1.6.2.2")> 
<Assembly: AssemblyFileVersionAttribute("1.6.2.2")> 