/*
	S27.US27	QSI
		As a Client Support Manager working with phone vendor data, I want QSI to import results when a breakoff disposition is not the final disposition 
		from the phone vendor, so that I do not have to manually manipulate the vendor files and reimport data prior to CMS submissions.

	T27.3	Scenario 2: Breakoff disposition with all missing responses
		�	An interviewer begins the survey, but the respondent answers �I don�t know� or something similar to all of the questions. These are marked with 
			the appropriate value for �missing�. After several questions, the interviewer gives up and ends the call with a breakoff disposition.
		�	The data from the vendor is brought into the DL_ tables. Since the responses are all �M�, they are recoded to -9 and brought into Qualisys 
			QuestionResult. The breakoff disposition is logged in disposition log.

		For the desired future functionality, I believe we discussed changing this to a �no response� disposition. 
		
		I noticed there is a �blank phone survey� disposition available (disposition_id = 27), but most CAHPS don�t have a disposition mapping to this.
		
		We could assign that dispo and add records in SurveyTypeDispositions to map that disposition_id to the appropriate CAHPS disposition for �no response�.

Dave Gilsdorf

NRC_DataMart:
insert into Disposition
insert into CahpsDisposition 
update/insert into CahpsDispositionMapping 

*/

use NRC_Datamart
go
delete from Disposition where dispositionid=49
delete from CahpsDispositionMapping where DispositionID=49 
