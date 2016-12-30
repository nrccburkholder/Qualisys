Imports System
Imports System.Reflection
Imports System.Runtime.InteropServices

' General Information about an assembly is controlled through the following 
' set of attributes. Change these attribute values to modify the information
' associated with an assembly.

' Review the values of the assembly attributes

<Assembly: AssemblyTitle("NRC Class Library")> 
<Assembly: AssemblyDescription("Various classes that implement common functionality in NRC solutions.")> 
<Assembly: AssemblyCompany("National Research Corporation")> 
<Assembly: AssemblyProduct("NRC Class Library")>
<Assembly: AssemblyCopyright("Copyright 2005-2017 National Research Corporation")>
<Assembly: AssemblyTrademark("")> 
<Assembly: CLSCompliant(True)> 
<Assembly: AssemblyKeyFileAttribute("..\..\NationalResearch.snk")> 

'The following GUID is for the ID of the typelib if this project is exposed to COM
<Assembly: Guid("73B31976-026C-4E65-BC19-A165DD5FF00F")>

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
'v1.0.0.0   JPC 05/01/2004 - The initial release...
'v1.1.0.0   JPC 07/07/2004 - Added NRC.WinForms.ExceptionReport Classes
'v1.1.1.0   JPC 07/08/2004 - Added NRC.WinForms.ExceptionReport Classes
'v1.1.2.0   JPC 07/14/2004 - Made SortableListView Re-Sortable
'                            Fixed bug in MultiPane Set SelectedIndex.
'v1.2.0.0   JPC 07/15/2004 - Added NRC.Configuration Namespace and created framework for Environment Settings Section of a .Config file
'v1.3.0.0   JPC 07/26/2004 - Added NRC.WinForms.BalloonTip class
'v1.4.0.0   JPC 08/10/2004 - Split out ScreenScaper class from ExceptionReport
'v1.5.0.0   JPC 08/13/2004 - Create Data.ExcelData to export DataTable to excel
'v1.6.0.0   JPC 09/13/2004 - Initial Release of the Web.ReportTable classes
'v1.6.1.0   JPC 10/07/2004 - Bug fix in Data.ExcelData export function.
'v1.6.1.1   JPC 10/13/2004 - Remove Web.ReportTable temporarily until it is needed.  This eliminates the Siberix dependency.
'v1.6.2.0   JPC 11/05/2004 - Created NRC.Web.SessionStateViewer HTTPHandler for viewing session state contents
'v1.7.0.0   JPC 11/05/2004 - Created NRC.Configuration.SiteMap Classes
'                            Created NRC.Web.BreadCrumbs control.
'v1.8.0.0   JPC 11/16/2004 - Created NRC.Configuration.RSCM classes
'                            Created NRC.Data.CBO class
'                            Created NRC.Data.Null class
'                            Created NRC.Web.FormBinding class
'                            Created NRC.Web.ManagedContent class
'                            Created NRC.Web.Content/Teaser controls
'v1.9.0.0   JPC 01/07/2005 - Created NRC.Web.MasterPage and NRC.Web.ContentRegion controls
'v1.10.0.0  JPC 03/10/2005 - Created NRC.Data.Populator Class - Similar to the CBO class only requires field attributes
'v1.10.1.0  JPC 03/15/2005 - Made changes to Configuration.AppConfigWrapper so that instance can be created as base class
'v1.10.2.0  JPC 03/15/2005 - Configuration.AppConfigWrapper will not try to implement singleton pattern in base.  It is just too problematic.
'v1.10.3.0  JPC 04/08/2005 - Fixed ExceptionReport bug where screen shot is not deleted :)
'v1.11.0.0  BM  04/12/2005 - Added NRCListView class to NRC.WinForms
'v1.11.1.0  BM  04/27/2005 - Fix a bug in NRCListView class
'v1.11.2.0  BM  05/13/2005 - Add some new mehtods and event to NRCListView class
'v1.11.3.0  BM  06/15/2005 - Optimize ExceptionMessage dialogue: adjust the height of message label dynamically to show all the message 
'v1.12.0.0  JPC 06/23/2005 - Created NRC.Web.CollapsePanel control
'                            Minor change to Configuration.AppConfigWrapper
'v1.13.0.0  DC  07/19/2005 - Changed 'Report Exception...' to 'Report Error...' in the error dialog.
'v1.14.0.0  JPC 08/18/2005 - Created NRC.Configuration.EnterpriseLibrary Namespace for using EnvironmentSettings on top of Enterprise Library
'                            Created NRC.WinForms.ThemeInfo Class - Provides access to the XP theme name, color scheme.
'                            Created NRC.WinForms.ProColors Class - Defines some theme specific colors used in professional looking applications (MS Office)
'                            Created NRC.WinForms.ProColorTable Class - Supports the ProColors class
'                            Modified PaneCaption, SectionHeader, SectionPanel, MultiPaneTab, and MultiPane classes to allow rendering with ProColors class
'                            Created NRC.Data.SqlCommandException Class - Provides more detailed information when exceptions occur trying to access data.  
'                            Modified NRC.WinForms.ExceptionReport to display info from SqlCommandException when applicable
'v1.14.1.0  JPC 12/09/2005 - Minor modification to Data.Null to support byte arrays
<Assembly: AssemblyVersion("2.0.0.0")>
