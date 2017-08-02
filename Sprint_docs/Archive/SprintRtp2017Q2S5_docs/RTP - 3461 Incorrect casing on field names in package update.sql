/* 
	RTP - 3461 Incorrect casing on field names in package update.sql
	Update dbo.DESTINATION SET FORMULA...
	6/26/2017 Jing F. - RTP-3461, Incorrect casing on field names in package update
*/
GO
USE [QP_LOAD]
GO

BEGIN TRAN

	--	Step 1: first replace G_CODE_1 
	update destination set formula = 	Replace(formula, 'DTSSource("G_CODE_1")', 'DTSSource("G_Code_1")') 
	from destination 
	where field_id in (1774, 1768, 1769, 1770)
	and formula like '%"G_CODE_1"%'

	update destination set formula = 	Replace(formula, 'DTSSource("G_CODE_2")', 'DTSSource("G_Code_2")') 
	from destination 
	where field_id in (1774, 1768, 1769, 1770)
	and formula like '%"G_CODE_2"%'

	update destination set formula = 	Replace(formula, 'DTSSource("G_CODE_3")', 'DTSSource("G_Code_3")') 
	from destination 
	where field_id in (1774, 1768, 1769, 1770)
	and formula like '%"G_CODE_3"%'

	/* - don't do this way as it only updated some of them as based on the original script for ATL-1430, 1768 is for G_Code_1, 1769 for G_Code_2, 1770 for G_Code_3 but I found out we didn't have G_Code_1 for 1769. 
	--	Step 1: next replace G_CODE_1
	update d set formula = 	Replace(d.formula, 'DTSSource("G_CODE_1")', 'DTSSource("G_Code_1"))') 
	from destination d left join
		destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
		destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
		destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
	where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
	and d2.formula like '%"G_CODE_1"%'

	
	--	Step 2: next replace G_CODE_2 
	update d set formula = 	Replace(d.formula, 'DTSSource("G_CODE_2")', 'DTSSource("G_Code_2"))') 
	from destination d left join
		destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
		destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
		destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
	where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
	and d3.formula like '%"G_CODE_2"%'

	--Step 3: next replace G_CODE_3 
	update d set formula = 	Replace(d.formula, 'DTSSource("G_CODE_3")', 'DTSSource("G_Code_3"))') 
	from destination d left join
		destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
		destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
		destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
	where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
	and d4.formula like '%"G_CODE_3"%'

	select d.formula 
	from destination d left join
		destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
		destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
		destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
	where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
	*/

COMMIT TRAN

GO