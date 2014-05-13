/************************* LAUNCH PAD APPLICATION SETTINGS ********************************/
/*
-- Created by Arman Mnatsakanyan March - 12 - 2009
-- This script needs Temp_InsertUpdateQualProParams Stored procedure to run
*/
/*All of the settings are environment independent*/
 Exec [Temp_InsertUpdateQualProParams] 
	 'NrcAuth', -- strParam_nm 
	 'S', -- STRPARAM_TYPE
	 'LaunchPad', --STRPARAM_GRP
	 'Nrc.LaunchPad.Library.NrcAuthProvider.ApplicationProvider, Nrc.LaunchPad.Library.NrcAuthProvider', -- STRPARAM_VALUE
	 NULL, -- NUMPARAM_VALUE
	 NULL, -- DATPARAM_VALUE
	 'NrcAuthProvider assembly and class name' -- COMMENTS
 
 Exec [Temp_InsertUpdateQualProParams] 'Global',
	 'S', 'LaunchPad', 
	 'Nrc.LaunchPad.Library.GlobalProvider.ApplicationProvider, Nrc.LaunchPad.Library.GlobalProvider', NULL, NULL, 
	 'GlobalProvider assembly and class name' 
 
 Exec [Temp_InsertUpdateQualProParams] 'Custom', 
	 'S', 'LaunchPad', 
	 'Nrc.LaunchPad.Library.CustomProvider.ApplicationProvider, Nrc.LaunchPad.Library.CustomProvider', NULL, NULL,
	 'CustomProvider assembly and class name' 
 
 Exec [Temp_InsertUpdateQualProParams] 'LPApplicationProviderKeys',
	 'S', 'LaunchPad', 
	 'NRCAuth,Global,Custom', NULL, NULL, 
	 'strParamValue is a comma separated list of ParamNames. The app gets the list of param names then gets those param values to store in a NameValueCollection.' 
 
 Exec [Temp_InsertUpdateQualProParams] 'LPProviderCategoryKeys',
	 'S', 'LaunchPad', 
	 'LPDefaultApplicationCategory', NULL, NULL, 
	 '' 
 
 Exec [Temp_InsertUpdateQualProParams] 'LPDefaultApplicationCategory', 
	 'S', 'LaunchPad', 
	 'Custom', NULL, NULL, 
	 'Default application category if none specified.' 
 
 Exec [Temp_InsertUpdateQualProParams] 'LPGlobalApplicationsXMLPath', 
	 'S', 'LaunchPad', 
	 '(AppDirectory)\GlobalApplications.xml', NULL, NULL, 
	 'Global applications and their properties are stored in GlobalApplications.xml which is usually stored in the same folder as Launch Pad executable.' 
 
 Exec [Temp_InsertUpdateQualProParams] 'LPAdminGroups',
	 'S', 'LaunchPad', 
	 'Domain Admins, Information Services', NULL, NULL, 
	 'Admin groups for Launch pad. Admin groups gets access to more options in the application.' 
