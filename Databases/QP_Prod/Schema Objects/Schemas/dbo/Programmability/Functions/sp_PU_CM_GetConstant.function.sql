/*******************************************************************************
 *
 * Function Name:
 *           sp_PU_CM_GetConstant
 *
 * Description:
 *           Get constants' value
 *
 * Parameters:
 *           @strConstantName    varchar(64)
 *             Constant variable name
 *
 * Return:
 *           Constant value
 *
 * History:
 *           1.0  11/28/2003 by Brian M
 *
 ******************************************************************************/

CREATE FUNCTION dbo.sp_PU_CM_GetConstant(
         @strConstantName     varchar(64)
       ) RETURNS int
AS
BEGIN

  RETURN(CASE @strConstantName
           WHEN 'YES'                       THEN 1
           WHEN 'NO'                        THEN 0
			
           WHEN 'FORMAT_TEXT'               THEN 0
           WHEN 'FORMAT_HTML'               THEN 1
			
           WHEN 'FREQ_WEEKLY'               THEN 1
           WHEN 'FREQ_BIWEEKLY'             THEN 2
           WHEN 'FREQ_TRIWEEKLY'            THEN 3
           WHEN 'FREQ_4WEEKLY'              THEN 4
           WHEN 'FREQ_MONTHLY'              THEN 10
           WHEN 'FREQ_BIMONTHLY'            THEN 11

           WHEN 'PLAN_STATUS_USING'         THEN 0
           WHEN 'PLAN_STATUS_DELETED'       THEN 1

           WHEN 'RPT_STATUS_SETUP'          THEN 1
           WHEN 'RPT_STATUS_POSTED'         THEN 100
           WHEN 'RPT_STATUS_SKIPPED'        THEN 200
			
           WHEN 'RR_LEVEL_ROOT'             THEN 1
           WHEN 'RR_LEVEL_ROOT_PLUS_1'      THEN 2
           WHEN 'RR_LEVEL_ROOT_PLUS_2'      THEN 3
           WHEN 'RR_LEVEL_ROOT_PLUS_3'      THEN 4
           WHEN 'RR_LEVEL_ROOT_PLUS_4'      THEN 5
           WHEN 'RR_LEVEL_ROOT_PLUS_5'      THEN 6
			
           WHEN 'SECTION_HEADING_INFO'      THEN 1
           WHEN 'SECTION_COMMENT'           THEN 2
           WHEN 'SECTION_DATA_LOADING'      THEN 3
           WHEN 'SECTION_SAMPLE_ACTIVITY'   THEN 4
           WHEN 'SECTION_RESPONSE_RATE'     THEN 5
			
           WHEN 'MAILSTEP_SCHEDULED'        THEN 1
           WHEN 'MAILSTEP_COMPLETED'        THEN 2

           WHEN 'PERIOD_CURRENT'            THEN 1
           WHEN 'PERIOD_PERVIOUS'           THEN 2
           WHEN 'PERIOD_CUSTOM'             THEN 3

           WHEN 'PERIOD_1'                  THEN 1
           WHEN 'PERIOD_2'                  THEN 2

           ELSE NULL
           END
        )
END


