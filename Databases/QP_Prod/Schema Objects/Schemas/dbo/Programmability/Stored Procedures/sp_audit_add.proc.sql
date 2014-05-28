CREATE PROCEDURE dbo.sp_audit_add
	@employee_id int, @study_id int, @survey_id int,
	@auditcategory_id int, @audittype_id int,
	@module_nm varchar(50), @field_nm varchar(50),
	@previous_value varchar(255),
	@new_value varchar(255)
AS
	IF @study_id = 0 AND @survey_id = 0
	BEGIN
		RAISERROR ('Both Study_id and Survey_id cannot be 0', 16, 1)
		RETURN
	END
	ELSE IF @survey_id = 0
	BEGIN
		SET @survey_id = NULL
	END
	ELSE IF @study_id = 0
	BEGIN
		SELECT @study_id = study_id FROM dbo.survey_def WHERE survey_id = @survey_id
	END

	INSERT INTO dbo.AuditLog (
		employee_id, study_id, survey_id, auditcategory_id, audittype_id,
		module_nm, field_nm, previous_value, new_value
	) VALUES (
		@employee_id, @study_id, @survey_id, @auditcategory_id, @audittype_id,
		@module_nm, @field_nm, @previous_value, @new_value
	)


