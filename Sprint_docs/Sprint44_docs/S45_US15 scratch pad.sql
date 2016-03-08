drop table #x
go
create table #x (x_id int identity(1,1), instrument varchar(250), variable_dsc varchar(2000), field_pos varchar(8), ValueLabels varchar(2000), details varchar(2000), qstncore varchar(100), completeness char(1), measure char(1))

insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q1.     Our records show that your child got care from
the provider named below in the last 6 months. Is that right?
','120','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','50483','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q2.     Is this the provider you usually see if your child needs a check-up or gets sick or hurt?
','121','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50484','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q3.     How long has your child been going to this
provider?
','122','1 = Less than 6 months
2 = At least 6 months but less than 1 year
3 = At least 1 year but less than 3
years
4 = At least 3 years but less than 5 years
5 = 5 years or more
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50485','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q4.     In the last 6 months, how many times did your child visit this provider for care?
','123','1 = None
2 = 1 time
3 = 2
4 = 3
5 = 4
6 = 5 to 9
7 = 10 or more times
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50486','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q5.     In the last 6 months, did you ever stay in the exam room with your child during a visit to this provider?
','124','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50487','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q6.     Did this provider give you enough information about
what was discussed during the visit when you were not there?
','125','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50488','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q7.     Is your child able to talk with providers about his or her health care?
','126','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50489','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q8.     In the last 6 months, how often did this provider explain things in a way
that was easy for your child to understand?
','127','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50490','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q9.     In the last 6 months, how often did this provider listen carefully to your child?
','128','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50491','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q10.   Did this provider tell you that you needed to do anything to follow up on the care your child got during the visit?
','129','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50492','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q11.   Did this provider give you enough information about
what you needed to do to follow up on your child’s care?
','130','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50493','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q12.   In the last 6 months, did you phone this provider’s office to get an appointment for your child for an illness, injury, or condition that needed
care right away?
','131','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50494','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q13.   In the last 6 months, when you phoned this
provider’s office to get an
appointment for care your child needed right away,
how often did you get an appointment as soon as your child needed?
','132','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50495','','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q14.   In the last 6 months, how many days did you
usually have to wait for an appointment when your
child needed care right away?
','133','1 = Same day
2 = 1 day
3 = 2 to 3 days
4 = 4 to 7 days
5 = More than 7 days
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50629','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q15.   In the last 6 months, did you make any appointments for a check-
up or routine care for your child with this provider?
','134','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50496','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q16.   In the last 6 months, when you made an
appointment for a check-
up or routine care for your child with this provider,
how often did you get an appointment as soon as your child needed?
','135','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50497','','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q17.   Did this provider’s office give you information about what to do if your child needed care during evenings, weekends, or holidays?
','136','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50630','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q18.   In the last 6 months, did your child need care during evenings weekends, or holidays?
','137','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50631','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q19.   In the last 6 months, how often were you able to get
the care your child needed from this provider’s office during evenings, weekends, or
holidays?
','138','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50632','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q20.   In the last 6 months, did you phone this provider’s
office with a medical question about your child during regular office hours?
','139','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50498','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q21.   In the last 6 months, when you phoned this provider’s office during regular office hours, how
often did you get an answer to your medical question that same day?
','140','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50499','','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q22.   In the last 6 months, did you phone this provider’s office with a medical question about your child after regular office hours?
','141','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50500','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q23.   In the last 6 months, when you phoned this
provider’s office after regular office hours, how often did you get an answer to your medical
question as soon as you needed?
','142','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50501','','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q24.   Some offices remind patients between visits
about tests, treatment, or
appointments.  In the last
6 months, did you get any reminders about your
child’s care from this
provider’s office between visits?
','143','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50633','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q25.  Wait time includes time spent in the waiting room and exam room. In the
last 6 months, how often did your child see this provider within 15 minutes of his or her appointment
time?
','144','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50502','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q26.   In the last 6 months, how often did this provider explain things about your
child’s health in a way that was easy to understand?
','145','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50503','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q27.   In the last 6 months, how often did this provider listen carefully to you?
','146','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50504','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q28.   In the last 6 months, did you and this provider talk about any questions or concerns you had about your child’s health?
','147','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50505','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q29.   In the last 6 months, how often did this provider give
you easy to understand information about these health questions or concerns?
','148','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50506','','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q30.   In the last 6 months, how often did this provider seem to know the
important information about your child’s medical history?
','149','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50507','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q31.   In the last 6 months, how often did this provider show respect for what you
had to say?
','150','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50508','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q32.   In the last 6 months, how often did this provider spend enough time with
your child?
','151','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50509','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q33.   In the last 6 months, did this provider order a blood test, x-ray, or other test
for your child?
','152','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50510','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q34.   In the last 6 months, when this provider
ordered a blood test, x-
ray, or other test for your child, how often did
someone from this provider’s office follow up to give you those results?
','153','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50511','','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q35.   Using any number from 0 to 10, where 0 is the worst provider possible and 10
is the best provider
possible, what number would you use to rate this provider?
','154-155','0 = 0 Worst provider possible
1 = 1
2 = 2
3 = 3
4 = 4
5 = 5
6 = 6
7 = 7
8 = 8
9 = 9
10 = 10 Best provider possible
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50512','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q36.   Specialists are doctors like surgeons, heart
doctors, allergy doctors,
skin doctors, and other doctors who specialize in
one area of health care. In the last 6 months, did your child see a specialist for a particular health
problem?
','156','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50634','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q37.   In the last 6 months, how often did the provider named in Question 1
seem informed and up-to- date about the care your child got from specialists?
','157','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50635','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q38.   In the last 6 months, did you and anyone in this provider’s office talk about
your child’s learning ability?
','158','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50513','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q39.   In the last 6 months, did you and anyone in this
provider’s office talk about
the kinds of behaviors that are normal for your child
at this age?
','159','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50514','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q40.   In the last 6 months, did you and anyone in this
provider’s office talk about how your child’s body is growing?
','160','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50515','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q41.   In the last 6 months, did you and anyone in this provider’s office talk about your child’s moods and emotions?
','161','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50516','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q42.   In the last 6 months, did you and anyone in this provider’s office talk about
things you can do to keep your child from getting injured?
','162','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50517','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q43.   In the last 6 months, did anyone in this provider’s office give you information about how to keep your child from getting injured?
','163','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50518','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q44.   In the last 6 months, did you and anyone in this
provider’s office talk about how much time your child spends on a computer
and in front of a TV?
','164','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50519','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q45.   In the last 6 months, did you and anyone in this provider’s office talk about
how much or what kind of food your child eats?
','165','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50520','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q46.   In the last 6 months, did you and anyone in this
provider’s office talk about
how much or what kind of exercise your child gets?
','166','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50521','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q47.   In the last 6 months, did you and anyone in this provider’s office talk about how your child gets along with others?
','167','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50522','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q48.   In the last 6 months, did you and anyone in this
provider’s office talk about whether there are any problems in your household that might
affect your child?
','168','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50523','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q49.   In the last 6 months, did anyone in this provider’s
office talk with you about specific goals for your child’s health?
','169','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50636','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q50.   In the last 6 months, did anyone in this provider’s office ask you if there are things that make it hard for you to take care of your child’s heath?
','170','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50637','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q51.   In the last 6 months, did your child take any
prescription medicine?
','171','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50638','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q52.   In the last 6 months, did you and anyone in this provider’s office talk at
each visit about all the prescription medicines your child was taking?
','172','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50639','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q53.   In the last 6 months, how often were clerks and
receptionists at this
provider’s office as helpful as you thought they
should be?
','173','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50524','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q54.  In the last 6 months, how often did clerks and receptionists at this provider’s office treat you with courtesy and respect?
','174','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50525','Y','Y')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q55.   In general, how would you rate your child’s overall health?
','175','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','50526','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q56.   In general, how would you rate your child’s overall mental or emotional health?
','176','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','50527','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q57. What is your child’s age?
o   Less than 1 year old
','177-178','0 = Less than 1 year old
Enter reported age if one year or older
H = Multiple mark
M = Missing
','','50528','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q58.   Is your child male or female?
','179','1 = Male
2 = Female
H = Multiple mark
M = Missing
','','50529','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q59.   Is your child of Hispanic or
Latino origin or descent?
','180','1 = Yes, Hispanic or Latino
2 = No, not Hispanic or Latino
H = Multiple mark
M = Missing
','','50530','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q60a. What is your child’s race?
Mark one or more.
o  White
','181','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325.','50531a
52325a','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q60b. What is your child’s race?
Mark one or more.
o  Black or African
American
','182','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325.','50531b
52325b','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q60c. What is your child’s race?
Mark one or more.
o   Asian
','183','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325.','50531c
52325c','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q60d. What is your child’s race?
Mark one or more.
o Native Hawaiian or
Other Pacific Islander
','184','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325.','50531d
52325d','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q60e. What is your child’s race?
Mark one or more.
o  American Indian or
Alaska Native
','185','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325.','50531e
52325e','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q60f.  What is your child’s race?
Mark one or more.
o  Other
','186','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325. 50531 does not have a scale value for Other; Code 0 if question 50531.','52325f','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q61.   What is your age?
','187','0 = Under 18
1 = 18 to 24
2 = 25 to 34
3 = 35 to 44
4 = 45 to 54
5 = 55 to 64
6 = 65 to 74
7 = 75 or older
H = Multiple mark
M = Missing
','','50532','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q62.   Are you male or female?
','188','1 = Male
2 = Female
H = Multiple mark
M = Missing
','','50533','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q63.  What is the highest grade or level of school that you have completed?
','189','1 = 8th grade or less
2 = Some high school, but did not graduate
3 = High school graduate or GED
4 = Some college or 2-year degree
5 = 4-year college graduate
6 = More than 4-year college degree
H = Multiple mark
M = Missing
','','50534','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q64.   How are you related to the child?
','190','1 = Mother or father
2 = Grandparent
3 = Aunt or Uncle
4 = Older brother or sister
5 = Other relative
6 = Legal guardian
7 = Someone else
H = Multiple mark
M = Missing
','','50535','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q65.   Did someone help you complete this survey?
','191','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','50536','Y','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q66a. How did that person help you? Mark one or more.
o   Read the questions to me
','192','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50537a','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q66b.  How did that person help you? Mark one or more.
o    Wrote down the answers I gave
','193','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50537b','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q66c.   How did that person help you? Mark one or more.
o    Answered the questions for me
','194','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50537c','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q66d.  How did that person help you? Mark one or more.
o   Translated the questions into my language
','195','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50537d','','')
insert into #x values ('Child 6 Month Survey PCMH 2.0', 'Q66e.  How did that person help you? Mark one or more.
o    Helped in some other way
','196','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50537e','','')



insert into #x values ('Adult 12 Month Survey 2.0', 'Q1.     Our records show that you got care from the
provider named below in the last 12 months. Is that right?
','120','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','44121','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q2.     Is this the provider you usually see if you need a check-up, want advice about a health problem, or get sick or hurt?
','121','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44122','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q3.     How long have you been going to this provider?
','122','1 = Less than 6 months
2 = At least 6 months but less than 1 year
3 = At least 1 year but less than 3
years
4 = At least 3 years but less than 5 years
5 = 5 years or more
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44123','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q4.     In the last 12 months, how many times did you visit this provider to get care
for yourself?
','123','1 = None
2 = 1 time
3 = 2
4 = 3
5 = 4
6 = 5 to 9
7 = 10 or more times
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44124','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q5.     In the last 12 months, did you phone this provider’s office to get an appointment for an illness, injury or condition that needed care right away?
','124','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44125','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q6.     In the last 12 months, when you phoned this
provider’s office to get an
appointment for care you needed right away, how
often did you get an appointment as soon as you needed?
','125','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44126','','Y')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q7.     In the last 12 months, did you make any appointments for a check- up or routine care with
this provider?
','126','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44129','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q8.     In the last 12 months, when you made an appointment for a check- up or routine care with this provider, how often did you get an appointment as soon as you needed?
','127','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44130','','Y')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q9.     In the last 12 months, did you phone this provider’s office with a medical
question during regular office hours?
','128','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44139','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q10.   In the last 12 months, when you phoned this
provider’s office during
regular office hours, how often did you get an
answer to your medical question that same day?
','129','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44140','','Y')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q11.   In the last 12 months, did you phone this provider’s
office with a medical question after regular office hours?
','130','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44141','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q12.   In the last 12 months, when you phoned this
provider’s office after regular office hours, how often did you get an answer to your medical
question as soon as you needed?
','131','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44142','','Y')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q13.   Wait time includes time spent in the waiting room
and exam room. In the
last 12 months, how often did you see this provider
within 15 minutes of your appointment time?
','132','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44148','Y','Y')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q14.   In the last 12 months, how often did this provider
explain things in a way
that was easy to understand?
','133','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44150','Y','Y')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q15.   In the last 12 months, how often did this provider
listen carefully to you?
','134','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44152','Y','Y')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q16.   In the last 12 months, did you talk with this provider
about any health
questions or concerns?
','135','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44155','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q17.   In the last 12 months, how often did this provider give you easy to understand information about these health questions or concerns?
','136','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44157','','Y')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q18.   In the last 12 months, how often did this provider seem to know the important information about your medical history?
','137','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44158','Y','Y')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q19.   In the last 12 months, how often did this provider show respect for what you had to say?
','138','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44161','Y','Y')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q20.   In the last 12 months, how often did this provider
spend enough time with
you?
','139','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44162','Y','Y')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q21.   In the last 12 months, did this provider order a blood
test, x-ray, or other test
for you?
','140','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44168','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q22.   In the last 12 months, when this provider ordered a blood test, x-
ray, or other test for you, how often did someone from this provider’s office follow up to give you
those results?
','141','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44169','','Y')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q23.   Using any number from 0 to 10, where 0 is the
worst provider possible and 10 is the best provider possible, what number would you use to
rate this provider?
','142-143','0 = 0 Worst provider possible
1 = 1
2 = 2
3 = 3
4 = 4
5 = 5
6 = 6
7 = 7
8 = 8
9 = 9
10 = 10 Best provider possible
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44181','Y','Y')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q24.   In the last 12 months, how often were clerks and receptionists at this provider’s office as helpful as you thought they
should be?
','144','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44201','Y','Y')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q25.   In the last 12 months, how often did clerks and receptionists at this provider’s office treat you with courtesy and
respect?
','145','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44202','Y','Y')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q26.   In general, how would you rate your overall health?
','146','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','44203','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q27.   In general, how would you rate your overall mental or emotional health?
','147','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','44204','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q28.  What is your age?
','148','1 = 18 to 24
2 = 25 to 34
3 = 35 to 44
4 = 45 to 54
5 = 55 to 64
6 = 65 to 74
7 = 75 or older
H = Multiple mark
M = Missing
','','44226','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q29.   Are you male or female?
','149','1 = Male
2 = Female
H = Multiple mark
M = Missing
','','44227','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q30.  What is the highest grade or level of school that you
have completed?
','150','1 = 8th grade or less
2 = Some high school, but did not graduate
3 = High school graduate or GED
4 = Some college or 2-year degree
5 = 4-year college graduate
6 = More than 4-year college degree
H = Multiple mark
M = Missing
','','44228','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q31.   Are you of Hispanic or
Latino origin or decent?
','151','1 = Yes, Hispanic or Latino
2 = No, not Hispanic or Latino
H = Multiple mark
M = Missing
','','44229','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q32a. What is your race? Mark one or more.
o  White
','152','0 = Not Selected
1 = Selected
','','44230a','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q32b. What is your race? Mark one or more.
o  Black or African
American
','153','0 = Not Selected
1 = Selected
','','44230b','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q32c. What is your race? Mark one or more.
o  Asian
','154','0 = Not Selected
1 = Selected
','','44230c','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q32d. What is your race? Mark one or more.
o  Native Hawaiian or
Other Pacific Islander
','155','0 = Not Selected
1 = Selected
','','44230d','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q32e. What is your race? Mark one or more.
o  American Indian or
Alaska Native
','156','0 = Not Selected
1 = Selected
','','44230e','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q32f. What is your race? Mark one or more.
o  Other
','157','0 = Not Selected
1 = Selected
','','44230f','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q33.   Did someone help you complete this survey?
','158','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','44234','Y','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q34a. How did that person help you? Mark one or more.
o   Read the questions to me
','159','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','44235a','','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q34b. How did that person help you? Mark one or more.
o  Wrote down the answers I gave
','160','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','44235b','','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q34c. How did that person help you? Mark one or more.
o    Answered the questions for me
','161','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','44235c','','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q34d. How did that person help you? Mark one or more.
o   Translated the questions into my language
','162','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','44235d','','')
insert into #x values ('Adult 12 Month Survey 2.0', 'Q34e. How did that person help you? Mark one or more.
o    Helped in some other way
','163','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','44235e','','')

insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q1.     Our records show that you got care from the
provider named below in the last 12 months. Is that right?
','120','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','44121','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q2.     Is this the provider you usually see if you need a check-up, want advice about a health problem, or get sick or hurt?
','121','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44122','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q3.     How long have you been going to this provider?
','122','1 = Less than 6 months
2 = At least 6 months but less than 1 year
3 = At least 1 year but less than 3
years
4 = At least 3 years but less than 5 years
5 = 5 years or more
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44123','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q4.     In the last 12 months, how many times did you visit this provider to get care
for yourself?
','123','1 = None
2 = 1 time
3 = 2
4 = 3
5 = 4
6 = 5 to 9
7 = 10 or more times
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44124','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q5.     In the last 12 months, did you phone this provider’s office to get an appointment for an illness, injury or condition that needed care right away?
','124','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44125','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q6.     In the last 12 months, when you phoned this
provider’s office to get an
appointment for care you needed right away, how
often did you get an appointment as soon as you needed?
','125','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44126','','Y')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q7.     In the last 12 months, how many days did you
usually have to wait for an appointment when you needed care right away?
','126','1 = Same day
2 = 1 day
3 = 2 to 3 days
4 = 4 to 7 days
5 = More than 7 days
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44127','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q8.     In the last 12 months, did you make any appointments for a check- up or routine care with
this provider?
','127','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44129','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q9.     In the last 12 months, when you made an
appointment for a check- up or routine care with this provider, how often did you get an
appointment as soon as you needed?
','128','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44130','','Y')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q10.   Did this provider’s office give you information
about what to do if you
needed care during evenings, weekends, or
holidays?
','129','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44134','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q11.   In the last 12 months, did you need care for yourself during evenings,
weekends, or holidays?
','130','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44135','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q12.   In the last 12 months, how often were you able to get
the care you needed from
this provider’s office during evenings,
weekends, or holidays?
','131','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44136','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q13.   In the last 12 months, did you phone this provider’s
office with a medical
question during regular office hours?
','132','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44139','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q14.   In the last 12 months, when you phoned this provider’s office during
regular office hours, how often did you get an answer to your medical question that same day?
','133','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44140','','Y')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q15.   In the last 12 months, did you phone this provider’s office with a medical
question after regular office hours?
','134','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44141','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q16.   In the last 12 months, when you phoned this provider’s office after
regular office hours, how often did you get an answer to your medical question as soon as you
needed?
','135','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44142','','Y')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q17.   Some offices remind patients between visits about tests, treatment or appointments. In the last
12 months, did you get any reminders from this provider’s office between visits?
','136','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44147','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q18.   Wait time includes time spent in the waiting room and exam room. In the
last 12 months, how often did you see this provider within 15 minutes of your appointment time?
','137','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44148','Y','Y')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q19.   In the last 12 months, how often did this provider explain things in a way
that was easy to understand?
','138','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44150','Y','Y')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q20.   In the last 12 months, how often did this provider listen carefully to you?
','139','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44152','Y','Y')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q21.   In the last 12 months, did you talk with this provider about any health questions or concerns?
','140','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44155','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q22.   In the last 12 months, how often did this provider give
you easy to understand information about these health questions or concerns?
','141','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44157','','Y')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q23.   In the last 12 months, how often did this provider
seem to know the important information about your medical history?
','142','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44158','Y','Y')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q24.   In the last 12 months, how often did this provider
show respect for what you had to say?
','143','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44161','Y','Y')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q25.   In the last 12 months, how often did this provider spend enough time with
you?
','144','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44162','Y','Y')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q26.   In the last 12 months, did this provider order a blood test, x-ray, or other test
for you?
','145','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44168','Y','Y')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q27.   In the last 12 months, when this provider
ordered a blood test, x- ray, or other test for you, how often did someone from this provider’s office
follow up to give you those results?
','146','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44169','','Y')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q28.   In the last 12 months, did you and this provider talk
about starting or stopping
a prescription medicine?
','147','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44171','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q29.  When you talked about starting or stopping a prescription medicine, how much did this
provider talk about the reasons you might want to take a medicine?
','148','1 = Not at all
2 = A little
3 = Some
4 = A lot
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44172','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q30.  When you talked about starting or stopping a prescription medicine, how much did this provider talk about the reasons you might not want to take a medicine?
','149','1 = Not at all
2 = A little
3 = Some
4 = A lot
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44173','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q31.  When you talked about starting or stopping a prescription medicine, did this provider ask you what you thought was best for you?
','150','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44174','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q32.   Using any number from 0 to 10, where 0 is the
worst provider possible
and 10 is the best provider possible, what
number would you use to rate this provider?
','151-152','0 = 0 Worst provider possible
1 = 1
2 = 2
3 = 3
4 = 4
5 = 5
6 = 6
7 = 7
8 = 8
9 = 9
10 = 10 Best provider possible
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44181','Y','Y')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q33.   Specialists are doctors like surgeons, heart doctors, allergy doctors,
skin doctors, and other doctors who specialize in one area of health care. In the last 12 months, did
you see a specialist for a particular health problem?
','153','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44164','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q34.   In the last 12 months,
how often did the provider named in Question 1
seem informed and up-to-
date about the care you got from specialists?
','154','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44165','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q35.   In the last 12 months, did anyone in this provider’s office talk with you about specific goals for your health?
','155','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44190','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q36.   In the last 12 months, did anyone in this provider’s
office ask you if there are things that make it hard for you to take care of your health?
','156','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44191','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q37.   In the last 12 months, did you take any prescription medicine?
','157','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44175','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q38.   In the last 12 months, did you and anyone in this
provider’s office talk at each visit about all the prescription medicines you were taking?
','158','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44176','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q39.   In the last 12 months, did anyone in this provider’s office ask you if there was
a period of time when you felt sad, empty, or depressed?
','159','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44188','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q40.   In the last 12 months, did you and anyone in this provider’s office talk about things in your life that worry you or cause you stress?
','160','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44187','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q41.   In the last 12 months, did you and anyone in this
provider’s office talk about
a personal problem, family problem, alcohol
use, drug use, or a mental or emotional illness?
','161','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','44166','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q42.   In the last 12 months, how often were clerks and
receptionists at this
provider’s office as helpful as you thought they
should be?
','162','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44201','Y','Y')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q43.   In the last 12 months, how often did clerks and
receptionists at this provider’s office treat you with courtesy and respect?
','163','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','44202','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q44.   In general, how would you rate your overall health?
','164','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','44203','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q45.   In general, how would you rate your overall mental or emotional health?
','165','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','44204','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q46.  What is your age?
','166','1 = 18 to 24
2 = 25 to 34
3 = 35 to 44
4 = 45 to 54
5 = 55 to 64
6 = 65 to 74
7 = 75 or older
H = Multiple mark
M = Missing
','','44226','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q47.   Are you male or female?
','167','1 = Male
2 = Female
H = Multiple mark
M = Missing
','','44227','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q48.  What is the highest grade or level of school that you
have completed?
','168','1 = 8th grade or less
2 = Some high school, but did not graduate
3 = High school graduate or GED
4 = Some college or 2-year degree
5 = 4-year college graduate
6 = More than 4-year college degree
H = Multiple mark
M = Missing
','','44228','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q49.   Are you of Hispanic or
Latino origin or decent?
','169','1 = Yes, Hispanic or Latino
2 = No, not Hispanic or Latino
H = Multiple mark
M = Missing
','','44229','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q50a. What is your race? Mark one or more.
o  White
','170','0 = Not Selected
1 = Selected
','','44230a','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q50b. What is your race? Mark one or more.
o  Black or African
American
','171','0 = Not Selected
1 = Selected
','','44230b','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q50c. What is your race? Mark one or more.
o  Asian
','172','0 = Not Selected
1 = Selected
','','44230c','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q50d. What is your race? Mark one or more.
o  Native Hawaiian or
Other Pacific Islander
','173','0 = Not Selected
1 = Selected
','','44230d','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q50e. What is your race? Mark one or more.
o  American Indian or
Alaska Native
','174','0 = Not Selected
1 = Selected
','','44230e','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q50f. What is your race? Mark one or more.
o  Other
','175','0 = Not Selected
1 = Selected
','','44230f','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q51.   Did someone help you complete this survey?
','176','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','44234','Y','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q52a.  How did that person help you? Mark one or more.
o   Read the questions to me
','177','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','44235a','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q52b.  How did that person help you? Mark one or more.
o  Wrote down the answers I gave
','178','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','44235b','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q52c.  How did that person help you? Mark one or more.
o    Answered the questions for me
','179','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','44235c','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q52d.  How did that person help you? Mark one or more.
o   Translated the questions into my language
','180','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','44235d','','')
insert into #x values ('Adult 12 Month Survey PCMH 2.0', 'Q52e.  How did that person help you? Mark one or more.
o    Helped in some other way
','181','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','44235e','','')

insert into #x values ('Adult 6 Month Survey 2.0', 'Q1.     Our records show that you got care from the
provider named below in the last 6 months. Is that right?
','120','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','50344','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q2.     Is this the provider you usually see if you need a check-up, want advice about a health problem, or get sick or hurt?
','121','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50176','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q3.     How long have you been going to this provider?
','122','1 = Less than 6 months
2 = At least 6 months but less than 1 year
3 = At least 1 year but less than 3
years
4 = At least 3 years but less than 5 years
5 = 5 years or more
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50177','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q4.     In the last 6 months, how many times did you visit this provider to get care
for yourself?
','123','1 = None
2 = 1 time
3 = 2
4 = 3
5 = 4
6 = 5 to 9
7 = 10 or more times
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50178','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q5.     In the last 6 months, did you phone this provider’s office to get an appointment for an illness, injury or condition that needed care right away?
','124','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50179','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q6.     In the last 6 months, when you phoned this
provider’s office to get an
appointment for care you needed right away, how
often did you get an appointment as soon as you needed?
','125','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50180','','Y')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q7.     In the last 6 months, did you make any appointments for a check- up or routine care with
this provider?
','126','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50181','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q8.     In the last 6 months, when you made an appointment for a check- up or routine care with this provider, how often did you get an appointment as soon as you needed?
','127','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50182','','Y')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q9.     In the last 6 months, did you phone this provider’s office with a medical
question during regular office hours?
','128','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50183','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q10.   In the last 6 months, when you phoned this
provider’s office during
regular office hours, how often did you get an
answer to your medical question that same day?
','129','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50184','','Y')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q11.   In the last 6 months, did you phone this provider’s
office with a medical question after regular office hours?
','130','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50185','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q12.   In the last 6 months, when you phoned this
provider’s office after regular office hours, how often did you get an answer to your medical
question as soon as you needed?
','131','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50186','','Y')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q13.   Wait time includes time spent in the waiting room
and exam room. In the
last 6 months, how often did you see this provider
within 15 minutes of your appointment time?
','132','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50189','Y','Y')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q14.   In the last 6 months, how often did this provider
explain things in a way
that was easy to understand?
','133','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50190','Y','Y')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q15.   In the last 6 months, how often did this provider
listen carefully to you?
','134','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50191','Y','Y')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q16.   In the last 6 months, did you talk with this provider
about any health
questions or concerns?
','135','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50192','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q17.   In the last 6 months, how often did this provider give you easy to understand information about these health questions or concerns?
','136','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50193','','Y')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q18.   In the last 6 months, how often did this provider seem to know the important information about your medical history?
','137','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50194','Y','Y')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q19.   In the last 6 months, how often did this provider show respect for what you had to say?
','138','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50196','Y','Y')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q20.   In the last 6 months, how often did this provider
spend enough time with
you?
','139','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50197','Y','Y')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q21.   In the last 6 months, did this provider order a blood
test, x-ray, or other test
for you?
','140','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50198','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q22.   In the last 6 months, when this provider ordered a blood test, x-
ray, or other test for you, how often did someone from this provider’s office follow up to give you
those results?
','141','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50199','','Y')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q23.   Using any number from 0 to 10, where 0 is the
worst provider possible and 10 is the best provider possible, what number would you use to
rate this provider?
','142-143','0 = 0 Worst provider possible
1 = 1
2 = 2
3 = 3
4 = 4
5 = 5
6 = 6
7 = 7
8 = 8
9 = 9
10 = 10 Best provider possible
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50215','Y','Y')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q24.   In the last 6 months, how often were clerks and receptionists at this provider’s office as helpful as you thought they
should be?
','144','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50216','Y','Y')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q25.   In the last 6 months, how often did clerks and receptionists at this provider’s office treat you with courtesy and
respect?
','145','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50217','Y','Y')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q26.   In general, how would you rate your overall health?
','146','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','50234','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q27.   In general, how would you rate your overall mental or emotional health?
','147','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','50235','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q28.  What is your age?
','148','1 = 18 to 24
2 = 25 to 34
3 = 35 to 44
4 = 45 to 54
5 = 55 to 64
6 = 65 to 74
7 = 75 or older
H = Multiple mark
M = Missing
','If 1-7, keep the response value
If 8, 9, or 10, recode to 7.','50241','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q29.   Are you male or female?
','149','1 = Male
2 = Female
H = Multiple mark
M = Missing
','','50699','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q30.  What is the highest grade or level of school that you
have completed?
','150','1 = 8th grade or less
2 = Some high school, but did not graduate
3 = High school graduate or GED
4 = Some college or 2-year degree
5 = 4-year college graduate
6 = More than 4-year college degree
H = Multiple mark
M = Missing
','','50243','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q31.   Are you of Hispanic or
Latino origin or decent?
','151','1 = Yes, Hispanic or Latino
2 = No, not Hispanic or Latino
H = Multiple mark
M = Missing
','','50253','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q32a. What is your race? Mark one or more.
o  White
','152','0 = Not Selected
1 = Selected
','','50255a','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q32b. What is your race? Mark one or more.
o  Black or African
American
','153','0 = Not Selected
1 = Selected
','','50255b','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q32c. What is your race? Mark one or more.
o  Asian
','154','0 = Not Selected
1 = Selected
','If any of these are selected, then 1','50255d
50255e
50255f
50255g
50255h
50255i
50255j','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q32d. What is your race? Mark one or more.
o  Native Hawaiian or
Other Pacific Islander
','155','0 = Not Selected
1 = Selected
','If any of these are selected, then 1','50255k
50255l
50255m
50255n','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q32e. What is your race? Mark one or more.
o  American Indian or
Alaska Native
','156','0 = Not Selected
1 = Selected
','','50255c','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q32f. What is your race? Mark one or more.
o  Other
','157','0 = Not Selected
1 = Selected
','Other was not included on the scale, so will always be 0.','N/A','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q33.   Did someone help you complete this survey?
','158','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','50256','Y','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q34a. How did that person help you? Mark one or more.
o   Read the questions to me
','159','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50257a','','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q34b. How did that person help you? Mark one or more.
o  Wrote down the answers I gave
','160','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50257b','','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q34c. How did that person help you? Mark one or more.
o    Answered the questions for me
','161','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50257c','','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q34d. How did that person help you? Mark one or more.
o   Translated the questions into my language
','162','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50257d','','')
insert into #x values ('Adult 6 Month Survey 2.0', 'Q34e. How did that person help you? Mark one or more.
o    Helped in some other way
','163','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50257e','','')

insert into #x values ('Adult 6 Month Survey 3.0', 'Q1.     Our records show that you got care from the
provider named below in the last 6 months. Is that right?
','120','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','50344','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q2.     Is this the provider you usually see if you need a check-up, want advice about a health problem, or get sick or hurt?
','121','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50176','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q3.     How long have you been going to this provider?
','122','1 = Less than 6 months
2 = At least 6 months but less than 1 year
3 = At least 1 year but less than 3
years
4 = At least 3 years but less than 5 years
5 = 5 years or more
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50177','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q4.     In the last 6 months, how many times did you visit this provider to get care
for yourself?
','123','1 = None
2 = 1 time
3 = 2
4 = 3
5 = 4
6 = 5 to 9
7 = 10 or more times
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50178','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q5.     In the last 6 months, did you contact this provider’s office to get an appointment for an illness, injury or condition that needed care right away?
','124','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50179','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q6.     In the last 6 months, when you contacted this
provider’s office to get an
appointment for care you needed right away, how
often did you get an appointment as soon as you needed?
','125','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50180','','Y')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q7.     In the last 6 months, did you make any appointments for a check- up or routine care with
this provider?
','126','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50181','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q8.     In the last 6 months, when you made an appointment for a check- up or routine care with this provider, how often did you get an appointment as soon as you needed?
','127','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50182','','Y')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q9.     In the last 6 months, did you contact this provider’s office with a medical
question during regular office hours?
','128','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50183','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q10.   In the last 6 months, when you contacted this
provider’s office during
regular office hours, how often did you get an
answer to your medical question that same day?
','129','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50184','','Y')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q11.   In the last 6 months, how often did this provider
explain things in a way
that was easy to understand?
','130','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50190','Y','Y')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q12.   In the last 6 months, how often did this provider
listen carefully to you?
','131','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50191','Y','Y')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q13.   In the last 6 months, how often did this provider seem to know the important information about your medical history?
','132','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50194','Y','Y')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q14.   In the last 6 months, how often did this provider show respect for what you had to say?
','133','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50196','Y','Y')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q15.   In the last 6 months, how often did this provider
spend enough time with
you?
','134','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50197','Y','Y')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q16.   In the last 6 months, did this provider order a blood
test, x-ray, or other test
for you?
','135','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50198','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q17.   In the last 6 months, when this provider ordered a blood test, x-
ray, or other test for you, how often did someone from this provider’s office follow up to give you
those results?
','136','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50199','','Y')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q18.   Using any number from 0 to 10, where 0 is the
worst provider possible and 10 is the best provider possible, what number would you use to
rate this provider?
','137-138','0 = 0 Worst provider possible
1 = 1
2 = 2
3 = 3
4 = 4
5 = 5
6 = 6
7 = 7
8 = 8
9 = 9
10 = 10 Best provider possible
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50215','Y','Y')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q19. In the last 6 months, did you take any prescription medicine?','139','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing','New','50226','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q20. In the last 6 months, how often did you and someone from this provider’s office talk about all the prescription medicines you were taking?','140','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing','New','53426','','Y')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q21.   In the last 6 months, how often were clerks and receptionists at this provider’s office as helpful as you thought they
should be?
','141','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50216','Y','Y')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q22.   In the last 6 months, how often did clerks and receptionists at this provider’s office treat you with courtesy and
respect?
','142','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50217','Y','Y')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q23.   In general, how would you rate your overall health?
','143','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','50234','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q24.   In general, how would you rate your overall mental or emotional health?
','144','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','50235','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q25.  What is your age?
','145','1 = 18 to 24
2 = 25 to 34
3 = 35 to 44
4 = 45 to 54
5 = 55 to 64
6 = 65 to 74
7 = 75 or older
H = Multiple mark
M = Missing
','If 1-7, keep the response value
If 8, 9, or 10, recode to 7.','50241','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q26.   Are you male or female?
','146','1 = Male
2 = Female
H = Multiple mark
M = Missing
','','50699','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q27.  What is the highest grade or level of school that you
have completed?
','147','1 = 8th grade or less
2 = Some high school, but did not graduate
3 = High school graduate or GED
4 = Some college or 2-year degree
5 = 4-year college graduate
6 = More than 4-year college degree
H = Multiple mark
M = Missing
','','50243','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q28.   Are you of Hispanic or
Latino origin or decent?
','148','1 = Yes, Hispanic or Latino
2 = No, not Hispanic or Latino
H = Multiple mark
M = Missing
','','50253','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q29a. What is your race? Mark one or more.
o  White
','149','0 = Not Selected
1 = Selected
','','50255a','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q29b. What is your race? Mark one or more.
o  Black or African
American
','150','0 = Not Selected
1 = Selected
','','50255b','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q29c. What is your race? Mark one or more.
o  Asian
','151','0 = Not Selected
1 = Selected
','If any of these are selected, then 1','50255d
50255e
50255f
50255g
50255h
50255i
50255j','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q32d. What is your race? Mark one or more.
o  Native Hawaiian or
Other Pacific Islander
','152','0 = Not Selected
1 = Selected
','If any of these are selected, then 1','50255k
50255l
50255m
50255n','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q29e. What is your race? Mark one or more.
o  American Indian or
Alaska Native
','153','0 = Not Selected
1 = Selected
','','50255c','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q29f. What is your race? Mark one or more.
o  Other
','154','0 = Not Selected
1 = Selected
','Other was not included on the scale, so will always be 0.','N/A','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q30.   Did someone help you complete this survey?
','155','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','50256','Y','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q31a. How did that person help you? Mark one or more.
o   Read the questions to me
','156','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50257a','','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q31b. How did that person help you? Mark one or more.
o  Wrote down the answers I gave
','157','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50257b','','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q31c. How did that person help you? Mark one or more.
o    Answered the questions for me
','158','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50257c','','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q31d. How did that person help you? Mark one or more.
o   Translated the questions into my language
','159','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50257d','','')
insert into #x values ('Adult 6 Month Survey 3.0', 'Q31e. How did that person help you? Mark one or more.
o    Helped in some other way
','160','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50257e','','')

insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q1.     Our records show that you got care from the
provider named below in the last 6 months. Is that right?
','120','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','50344','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q2.     Is this the provider you usually see if you need a check-up, want advice about a health problem, or get sick or hurt?
','121','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50176','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q3.     How long have you been going to this provider?
','122','1 = Less than 6 months
2 = At least 6 months but less than 1 year
3 = At least 1 year but less than 3
years
4 = At least 3 years but less than 5 years
5 = 5 years or more
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50177','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q4.     In the last 6 months, how many times did you visit this provider to get care
for yourself?
','123','1 = None
2 = 1 time
3 = 2
4 = 3
5 = 4
6 = 5 to 9
7 = 10 or more times
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50178','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q5.     In the last 6 months, did you phone this provider’s office to get an appointment for an illness, injury or condition that needed care right away?
','124','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50179','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q6.     In the last 6 months, when you phoned this
provider’s office to get an
appointment for care you needed right away, how
often did you get an appointment as soon as you needed?
','125','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50180','','Y')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q7.     In the last 6 months, how many days did you
usually have to wait for an appointment when you needed care right away?
','126','1 = Same day
2 = 1 day
3 = 2 to 3 days
4 = 4 to 7 days
5 = More than 7 days
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50541','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q8.     In the last 6 months, did you make any appointments for a check- up or routine care with
this provider?
','127','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50181','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q9.     In the last 6 months, when you made an
appointment for a check- up or routine care with this provider, how often did you get an
appointment as soon as you needed?
','128','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50182','','Y')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q10.   Did this provider’s office give you information
about what to do if you
needed care during evenings, weekends, or
holidays?
','129','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50542','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q11.   In the last 6 months, did you need care for yourself during evenings,
weekends, or holidays?
','130','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50543','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q12.   In the last 6 months, how often were you able to get
the care you needed from
this provider’s office during evenings,
weekends, or holidays?
','131','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50544','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q13.   In the last 6 months, did you phone this provider’s
office with a medical
question during regular office hours?
','132','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50183','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q14.   In the last 6 months, when you phoned this provider’s office during
regular office hours, how often did you get an answer to your medical question that same day?
','133','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50184','','Y')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q15.   In the last 6 months, did you phone this provider’s office with a medical
question after regular office hours?
','134','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50185','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q16.   In the last 6 months, when you phoned this provider’s office after
regular office hours, how often did you get an answer to your medical question as soon as you
needed?
','135','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50186','','Y')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q17.   Some offices remind patients between visits about tests, treatment or appointments. In the last
6 months, did you get any reminders from this provider’s office between visits?
','136','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50545','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q18.   Wait time includes time spent in the waiting room and exam room. In the
last 6 months, how often did you see this provider within 15 minutes of your appointment time?
','137','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50189','Y','Y')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q19.   In the last 6 months, how often did this provider explain things in a way
that was easy to understand?
','138','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50190','Y','Y')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q20.   In the last 6 months, how often did this provider listen carefully to you?
','139','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50191','Y','Y')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q21.   In the last 6 months, did you talk with this provider about any health questions or concerns?
','140','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50192','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q22.   In the last 6 months, how often did this provider give
you easy to understand information about these health questions or concerns?
','141','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50193','','Y')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q23.   In the last 6 months, how often did this provider
seem to know the important information about your medical history?
','142','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50194','Y','Y')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q24.   In the last 6 months, how often did this provider
show respect for what you had to say?
','143','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50196','Y','Y')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q25.   In the last 6 months, how often did this provider spend enough time with
you?
','144','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50197','Y','Y')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q26.   In the last 6 months, did this provider order a blood test, x-ray, or other test
for you?
','145','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50198','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q27.   In the last 6 months, when this provider
ordered a blood test, x- ray, or other test for you, how often did someone from this provider’s office
follow up to give you those results?
','146','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50199','','Y')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q28.   In the last 6 months, did you and this provider talk
about starting or stopping
a prescription medicine?
','147','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50546','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q29.  When you talked about starting or stopping a prescription medicine, how much did this
provider talk about the reasons you might want to take a medicine?
','148','1 = Not at all
2 = A little
3 = Some
4 = A lot
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50547','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q30.  When you talked about starting or stopping a prescription medicine, how much did this provider talk about the reasons you might not want to take a medicine?
','149','1 = Not at all
2 = A little
3 = Some
4 = A lot
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50548','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q31.  When you talked about starting or stopping a prescription medicine, did this provider ask you what you thought was best for you?
','150','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50549','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q32.   Using any number from 0 to 10, where 0 is the
worst provider possible
and 10 is the best provider possible, what
number would you use to rate this provider?
','151-152','0 = 0 Worst provider possible
1 = 1
2 = 2
3 = 3
4 = 4
5 = 5
6 = 6
7 = 7
8 = 8
9 = 9
10 = 10 Best provider possible
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50215','Y','Y')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q33.   Specialists are doctors like surgeons, heart doctors, allergy doctors,
skin doctors, and other doctors who specialize in one area of health care. In the last 6 months, did
you see a specialist for a particular health problem?
','153','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50550','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q34.   In the last 6 months,
how often did the provider named in Question 1
seem informed and up-to-
date about the care you got from specialists?
','154','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50551','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q35.   In the last 6 months, did anyone in this provider’s office talk with you about specific goals for your health?
','155','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50552','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q36.   In the last 6 months, did anyone in this provider’s
office ask you if there are things that make it hard for you to take care of your health?
','156','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50553','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q37.   In the last 6 months, did you take any prescription medicine?
','157','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50554','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q38.   In the last 6 months, did you and anyone in this
provider’s office talk at each visit about all the prescription medicines you were taking?
','158','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50555','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q39.   In the last 6 months, did anyone in this provider’s office ask you if there was
a period of time when you felt sad, empty, or depressed?
','159','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50556','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q40.   In the last 6 months, did you and anyone in this provider’s office talk about things in your life that worry you or cause you stress?
','160','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50557','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q41.   In the last 6 months, did you and anyone in this
provider’s office talk about
a personal problem, family problem, alcohol
use, drug use, or a mental or emotional illness?
','161','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','50558','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q42.   In the last 6 months, how often were clerks and
receptionists at this
provider’s office as helpful as you thought they
should be?
','162','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50216','Y','Y')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q43.   In the last 6 months, how often did clerks and
receptionists at this provider’s office treat you with courtesy and respect?
','163','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50217','Y','Y')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q44.   In general, how would you rate your overall health?
','164','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','50234','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q45.   In general, how would you rate your overall mental or emotional health?
','165','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','50235','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q46.  What is your age?
','166','1 = 18 to 24
2 = 25 to 34
3 = 35 to 44
4 = 45 to 54
5 = 55 to 64
6 = 65 to 74
7 = 75 or older
H = Multiple mark
M = Missing
','If 1-7, keep the response value
If 8, 9, or 10, recode to 7.','50241','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q47.   Are you male or female?
','167','1 = Male
2 = Female
H = Multiple mark
M = Missing
','','50699','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q48.  What is the highest grade or level of school that you
have completed?
','168','1 = 8th grade or less
2 = Some high school, but did not graduate
3 = High school graduate or GED
4 = Some college or 2-year degree
5 = 4-year college graduate
6 = More than 4-year college degree
H = Multiple mark
M = Missing
','','50243','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q49.   Are you of Hispanic or
Latino origin or decent?
','169','1 = Yes, Hispanic or Latino
2 = No, not Hispanic or Latino
H = Multiple mark
M = Missing
','','50253','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q50a. What is your race? Mark one or more.
o  White
','170','0 = Not Selected
1 = Selected
','','50255a','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q50b. What is your race? Mark one or more.
o  Black or African
American
','171','0 = Not Selected
1 = Selected
','','50255b','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q50c. What is your race? Mark one or more.
o  Asian
','172','0 = Not Selected
1 = Selected
','','50255d
50255e
50255f
50255g
50255h
50255i
50255j','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q50d. What is your race? Mark one or more.
o  Native Hawaiian or
Other Pacific Islander
','173','0 = Not Selected
1 = Selected
','','50255k
50255l
50255m
50255n','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q50e. What is your race? Mark one or more.
o  American Indian or
Alaska Native
','174','0 = Not Selected
1 = Selected
','','50255c','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q50f. What is your race? Mark one or more.
o  Other
','175','0 = Not Selected
1 = Selected
','Other was not included on the scale, so will always be 0.','N/A','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q51.   Did someone help you complete this survey?
','176','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','50256','Y','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q52a.  How did that person help you? Mark one or more.
o   Read the questions to me
','177','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50257a','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q52b.  How did that person help you? Mark one or more.
o  Wrote down the answers I gave
','178','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50257b','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q52c.  How did that person help you? Mark one or more.
o    Answered the questions for me
','179','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50257c','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q52d.  How did that person help you? Mark one or more.
o   Translated the questions into my language
','180','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50257d','','')
insert into #x values ('Adult 6 Month Survey PCMH 2.0', 'Q52e.  How did that person help you? Mark one or more.
o    Helped in some other way
','181','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50257e','','')

insert into #x values ('Adult Visit 2.0', 'Q1.     Our records show that you got care from the
provider named below. Is that right?
','120','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','39113','Y','')
insert into #x values ('Adult Visit 2.0', 'Q2.     Is this the provider you usually see if you need a
check-up, want advice
about a health problem, or get sick or hurt?
','121','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39114','Y','')
insert into #x values ('Adult Visit 2.0', 'Q3.     How long have you been going to this provider?
','122','1 = Less than 6 months
2 = At least 6 months but less than 1 year
3 = At least 1 year but less than 3 years
4 = At least 3 years but less than 5 years
5 = 5 years or more
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39115','Y','')
insert into #x values ('Adult Visit 2.0', 'Q4.     In the last 12 months, how many times did you visit this provider to get care
for yourself?
','123','1 = None
2 = 1 time
3 = 2
4 = 3
5 = 4
6 = 5 to 9
7 = 10 or more times
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39116','Y','')
insert into #x values ('Adult Visit 2.0', 'Q5.     In the last 12 months, did you phone this provider’s
office to get an
appointment for an illness, injury or condition that
needed care right away?
','124','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39117','Y','')
insert into #x values ('Adult Visit 2.0', 'Q6.     In the last 12 months, when you phoned this
provider’s office to get an appointment for care you needed right away, how often did you get an
appointment as soon as you needed?
','125','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39118','','Y')
insert into #x values ('Adult Visit 2.0', 'Q7.     In the last 12 months, did you make any
appointments for a check-
up or routine care with this provider?
','126','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39119','Y','')
insert into #x values ('Adult Visit 2.0', 'Q8.     In the last 12 months, when you made an appointment for a check- up or routine care with this provider, how often did you get an appointment as soon as you needed?
','127','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39120','','Y')
insert into #x values ('Adult Visit 2.0', 'Q9.     In the last 12 months, did you phone this provider’s office with a medical
question during regular office hours?
','128','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39121','Y','')
insert into #x values ('Adult Visit 2.0', 'Q10.   In the last 12 months, when you phoned this
provider’s office during
regular office hours, how often did you get an
answer to your medical question that same day?
','129','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39122','','Y')
insert into #x values ('Adult Visit 2.0', 'Q11.   In the last 12 months, did you phone this provider’s
office with a medical question after regular office hours?
','130','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39123','Y','')
insert into #x values ('Adult Visit 2.0', 'Q12.   In the last 12 months, when you phoned this
provider’s office after regular office hours, how often did you get an answer to your medical
question as soon as you needed?
','131','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39124','','Y')
insert into #x values ('Adult Visit 2.0', 'Q13.   Wait time includes time spent in the waiting room
and exam room. In the
last 12 months, how often did you see this provider
within 15 minutes of your appointment time?
','132','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39125','Y','Y')
insert into #x values ('Adult Visit 2.0', 'Q14.   How long has it been since your most recent
visit with this provider?
','133','1 = Less than 1 month
2 = At least 1 month but less than 3 months
3 = At least 3 months but less than 6 months
4 = At least 6 months but less than
12 months
5 = 12 months or more
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39126','Y','')
insert into #x values ('Adult Visit 2.0', 'Q15.  Wait time includes time spent in the waiting room
and exam room. During
your most recent visit, did you see this provider
within 15 minutes of your appointment time?
','134','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39127','Y','')
insert into #x values ('Adult Visit 2.0', 'Q16.   During your most recent visit, did this provider explain things in a way that was easy to understand?
','135','1 = Yes, definitely
2 = Yes, somewhat
3 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39130','Y','Y')
insert into #x values ('Adult Visit 2.0', 'Q17.   During your most recent visit, did this provider
listen carefully to you?
','136','1 = Yes, definitely
2 = Yes, somewhat
3 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39131','Y','Y')
insert into #x values ('Adult Visit 2.0', 'Q18.   During your most recent visit, did you talk with this
provider about any health questions or concerns?
','137','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39132','Y','')
insert into #x values ('Adult Visit 2.0', 'Q19.   During your most recent visit, did this provider give you easy to understand information about these health questions or concerns?
','138','1 = Yes, definitely
2 = Yes, somewhat
3 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39133','','Y')
insert into #x values ('Adult Visit 2.0', 'Q20.   During your most recent visit, did this provider
seem to know the important information about your medical history?
','139','1 = Yes, definitely
2 = Yes, somewhat
3 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39134','Y','Y')
insert into #x values ('Adult Visit 2.0', 'Q21.   During your most recent visit, did this provider
show respect for what you
had to say?
','140','1 = Yes, definitely
2 = Yes, somewhat
3 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39135','Y','Y')
insert into #x values ('Adult Visit 2.0', 'Q22.   During your most recent visit, did this provider spend enough time with you?
','141','1 = Yes, definitely
2 = Yes, somewhat
3 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39136','Y','Y')
insert into #x values ('Adult Visit 2.0', 'Q23.   During your most recent visit, did this provider
order a blood test, x-ray,
or other test for you?
','142','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39128','Y','')
insert into #x values ('Adult Visit 2.0', 'Q24.   Did someone from this provider’s office follow up to give you those results?
','143','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39129','','Y')
insert into #x values ('Adult Visit 2.0', 'Q25.   Using any number from 0 to 10, where 0 is the worst provider possible and 10
is the best provider
possible, what number would you use to rate this provider?
','144-145','0 = 0 Worst provider possible
1 = 1
2 = 2
3 = 3
4 = 4
5 = 5
6 = 6
7 = 7
8 = 8
9 = 9
10 = 10 Best provider possible
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39137','Y','Y')
insert into #x values ('Adult Visit 2.0', 'Q26.  Would you recommend this provider’s office to
your family and friends?
','146','1 = Yes, definitely
2 = Yes, somewhat
3 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39138','Y','')
insert into #x values ('Adult Visit 2.0', 'Q27.   During your most recent visit, were clerks and receptionists at this
provider’s office as helpful as you thought they
should be?
','147','1 = Yes, definitely
2 = Yes, somewhat
3 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39139','Y','Y')
insert into #x values ('Adult Visit 2.0', 'Q28.   During your most recent visit, did clerks and receptionists at this provider’s office treat you with courtesy and respect?
','148','1 = Yes, definitely
2 = Yes, somewhat
3 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','39140','Y','Y')
insert into #x values ('Adult Visit 2.0', 'Q29.   In general, how would you rate your overall health?
','149','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','39151','Y','')
insert into #x values ('Adult Visit 2.0', 'Q30.   In general, how would you rate your overall mental or
emotional health?
','150','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','46688','Y','')
insert into #x values ('Adult Visit 2.0', 'Q31.  What is your age?
','151','1 = 18 to 24
2 = 25 to 34
3 = 35 to 44
4 = 45 to 54
5 = 55 to 64
6 = 65 to 74
7 = 75 or older
H = Multiple mark
M = Missing
','','39156','Y','')
insert into #x values ('Adult Visit 2.0', 'Q32.   Are you male or female?
','152','1 = Male
2 = Female
H = Multiple mark
M = Missing
','','39157','Y','')
insert into #x values ('Adult Visit 2.0', 'Q33.  What is the highest grade or level of school that you have completed?
','153','1 = 8th grade or less
2 = Some high school, but did not graduate
3 = High school graduate or GED
4 = Some college or 2-year degree
5 = 4-year college graduate
6 = More than 4-year college degree
H = Multiple mark
M = Missing
','','39158','Y','')
insert into #x values ('Adult Visit 2.0', 'Q34.   Are you of Hispanic or
Latino origin or decent?
','154','1 = Yes, Hispanic or Latino
2 = No, not Hispanic or Latino
H = Multiple mark
M = Missing
','','39159','Y','')
insert into #x values ('Adult Visit 2.0', 'Q35a. What is your race? Mark one or more.
o  White
','155','0 = Not Selected
1 = Selected
','','39160a','Y','')
insert into #x values ('Adult Visit 2.0', 'Q35b. What is your race? Mark one or more.
o  Black or African
American
','156','0 = Not Selected
1 = Selected
','','39160b','Y','')
insert into #x values ('Adult Visit 2.0', 'Q35c. What is your race? Mark one or more.
o  Asian
','157','0 = Not Selected
1 = Selected
','','39160c','Y','')
insert into #x values ('Adult Visit 2.0', 'Q35d. What is your race? Mark one or more.
o  Native Hawaiian or
Other Pacific Islander
','158','0 = Not Selected
1 = Selected
','','39160d','Y','')
insert into #x values ('Adult Visit 2.0', 'Q35e. What is your race? Mark one or more.
o  American Indian or
Alaska Native
','159','0 = Not Selected
1 = Selected
','','39160e','Y','')
insert into #x values ('Adult Visit 2.0', 'Q35f. What is your race? Mark one or more.
o  Other
','160','0 = Not Selected
1 = Selected
','','39160f','Y','')
insert into #x values ('Adult Visit 2.0', 'Q36.   Did someone help you complete this survey?
','161','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','40716','Y','')
insert into #x values ('Adult Visit 2.0', 'Q37a. How did that person help you? Mark one or more.
o   Read the questions to me
','162','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','39162a','','')
insert into #x values ('Adult Visit 2.0', 'Q37b. How did that person help you? Mark one or more.
o  Wrote down the answers I gave
','163','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','39162b','','')
insert into #x values ('Adult Visit 2.0', 'Q37c. How did that person help you? Mark one or more.
o    Answered the questions for me
','164','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','39162c','','')
insert into #x values ('Adult Visit 2.0', 'Q37d. How did that person help you? Mark one or more.
o   Translated the questions into my language
','165','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','39162d','','')
insert into #x values ('Adult Visit 2.0', 'Q37e. How did that person help you? Mark one or more.
o    Helped in some other way
','166','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','39162e','','')

insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q1.     Our records show that your child got care from
the provider named below in the last 12 months. Is that right?
','120','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','46265','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q2.     Is this the provider you usually see if your child needs a check-up or gets sick or hurt?
','121','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46266','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q3.     How long has your child been going to this
provider?
','122','1 = Less than 6 months
2 = At least 6 months but less than 1 year
3 = At least 1 year but less than 3
years
4 = At least 3 years but less than 5 years
5 = 5 years or more
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46267','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q4.     In the last 12 months, how many times did your child visit this provider for care?
','123','1 = None
2 = 1 time
3 = 2
4 = 3
5 = 4
6 = 5 to 9
7 = 10 or more times
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46268','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q5.     In the last 12 months, did you ever stay in the exam room with your child during a visit to this provider?
','124','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46269','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q6.     Did this provider give you enough information about
what was discussed during the visit when you were not there?
','125','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46270','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q7.     Is your child able to talk with providers about his or her health care?
','126','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46271','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q8.     In the last 12 months, how often did this provider explain things in a way
that was easy for your child to understand?
','127','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46272','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q9.     In the last 12 months, how often did this provider listen carefully to your child?
','128','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46273','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q10.   Did this provider tell you that you needed to do anything to follow up on the care your child got during the visit?
','129','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46274','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q11.   Did this provider give you enough information about
what you needed to do to follow up on your child’s care?
','130','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46275','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q12.   In the last 12 months, did you phone this provider’s office to get an appointment for your child for an illness, injury, or condition that needed
care right away?
','131','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46276','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q13.   In the last 12 months, when you phoned this
provider’s office to get an
appointment for care your child needed right away,
how often did you get an appointment as soon as your child needed?
','132','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46277','','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q14.   In the last 12 months, how many days did you
usually have to wait for an appointment when your
child needed care right away?
','133','1 = Same day
2 = 1 day
3 = 2 to 3 days
4 = 4 to 7 days
5 = More than 7 days
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','46278','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q15.   In the last 12 months, did you make any appointments for a check-
up or routine care for your child with this provider?
','134','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46279','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q16.   In the last 12 months, when you made an
appointment for a check-
up or routine care for your child with this provider,
how often did you get an appointment as soon as your child needed?
','135','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46280','','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q17.   Did this provider’s office give you information about what to do if your child needed care during evenings, weekends, or holidays?
','136','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','46281','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q18.   In the last 12 months, did your child need care during evenings weekends, or holidays?
','137','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','46282','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q19.   In the last 12 months, how often were you able to get
the care your child needed from this provider’s office during evenings, weekends, or
holidays?
','138','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','46283','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q20.   In the last 12 months, did you phone this provider’s
office with a medical question about your child during regular office hours?
','139','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46284','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q21.   In the last 12 months, when you phoned this provider’s office during regular office hours, how
often did you get an answer to your medical question that same day?
','140','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46285','','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q22.   In the last 12 months, did you phone this provider’s office with a medical question about your child after regular office hours?
','141','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46286','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q23.   In the last 12 months, when you phoned this
provider’s office after regular office hours, how often did you get an answer to your medical
question as soon as you needed?
','142','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46287','','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q24.   Some offices remind patients between visits
about tests, treatment, or
appointments.  In the last
12 months, did you get any reminders about your
child’s care from this
provider’s office between visits?
','143','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','46288','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q25.  Wait time includes time spent in the waiting room and exam room. In the
last 12 months, how often did your child see this provider within 15 minutes of his or her appointment
time?
','144','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46289','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q26.   In the last 12 months, how often did this provider explain things about your
child’s health in a way that was easy to understand?
','145','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46290','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q27.   In the last 12 months, how often did this provider listen carefully to you?
','146','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46291','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q28.   In the last 12 months, did you and this provider talk about any questions or concerns you had about your child’s health?
','147','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46292','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q29.   In the last 12 months, how often did this provider give
you easy to understand information about these health questions or concerns?
','148','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46293','','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q30.   In the last 12 months, how often did this provider seem to know the
important information about your child’s medical history?
','149','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46294','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q31.   In the last 12 months, how often did this provider show respect for what you
had to say?
','150','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46295','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q32.   In the last 12 months, how often did this provider spend enough time with
your child?
','151','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46296','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q33.   In the last 12 months, did this provider order a blood test, x-ray, or other test
for your child?
','152','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46297','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q34.   In the last 12 months, when this provider
ordered a blood test, x-
ray, or other test for your child, how often did
someone from this provider’s office follow up to give you those results?
','153','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46298','','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q35.   Using any number from 0 to 10, where 0 is the worst provider possible and 10
is the best provider
possible, what number would you use to rate this provider?
','154-155','0 = 0 Worst provider possible
1 = 1
2 = 2
3 = 3
4 = 4
5 = 5
6 = 6
7 = 7
8 = 8
9 = 9
10 = 10 Best provider possible
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46299','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q36.   Specialists are doctors like surgeons, heart
doctors, allergy doctors,
skin doctors, and other doctors who specialize in
one area of health care. In the last 12 months, did your child see a specialist for a particular health
problem?
','156','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','46300','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q37.   In the last 12 months, how often did the provider named in Question 1
seem informed and up-to- date about the care your child got from specialists?
','157','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','46301','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q38.   In the last 12 months, did you and anyone in this provider’s office talk about
your child’s learning ability?
','158','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46302','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q39.   In the last 12 months, did you and anyone in this
provider’s office talk about
the kinds of behaviors that are normal for your child
at this age?
','159','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46303','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q40.   In the last 12 months, did you and anyone in this
provider’s office talk about how your child’s body is growing?
','160','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46304','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q41.   In the last 12 months, did you and anyone in this provider’s office talk about your child’s moods and emotions?
','161','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46305','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q42.   In the last 12 months, did you and anyone in this provider’s office talk about
things you can do to keep your child from getting injured?
','162','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46306','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q43.   In the last 12 months, did anyone in this provider’s office give you information about how to keep your child from getting injured?
','163','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46307','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q44.   In the last 12 months, did you and anyone in this
provider’s office talk about how much time your child spends on a computer
and in front of a TV?
','164','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46308','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q45.   In the last 12 months, did you and anyone in this provider’s office talk about
how much or what kind of food your child eats?
','165','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46309','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q46.   In the last 12 months, did you and anyone in this
provider’s office talk about
how much or what kind of exercise your child gets?
','166','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46310','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q47.   In the last 12 months, did you and anyone in this provider’s office talk about how your child gets along with others?
','167','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46311','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q48.   In the last 12 months, did you and anyone in this
provider’s office talk about whether there are any problems in your household that might
affect your child?
','168','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46312','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q49.   In the last 12 months, did anyone in this provider’s
office talk with you about specific goals for your child’s health?
','169','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','46313','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q50.   In the last 12 months, did anyone in this provider’s office ask you if there are things that make it hard for you to take care of your child’s heath?
','170','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','46314','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q51.   In the last 12 months, did your child take any
prescription medicine?
','171','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','46315','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q52.   In the last 12 months, did you and anyone in this provider’s office talk at
each visit about all the prescription medicines your child was taking?
','172','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','PCMH supplemental item
','46316','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q53.   In the last 12 months, how often were clerks and
receptionists at this
provider’s office as helpful as you thought they
should be?
','173','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46317','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q54.  In the last 12 months, how often did clerks and receptionists at this provider’s office treat you with courtesy and respect?
','174','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','46318','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q55.   In general, how would you rate your child’s overall health?
','175','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','46319','Y','Y')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q56.   In general, how would you rate your child’s overall mental or emotional health?
','176','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','46320','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q57. What is your child’s age?
o   Less than 1 year old
','177-178','0 = Less than 1 year old
Enter reported age if one year or older
H = Multiple mark
M = Missing
','','46321','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q58.   Is your child male or female?
','179','1 = Male
2 = Female
H = Multiple mark
M = Missing
','','46322','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q59.   Is your child of Hispanic or
Latino origin or descent?
','180','1 = Yes, Hispanic or Latino
2 = No, not Hispanic or Latino
H = Multiple mark
M = Missing
','','46323','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q60a. What is your child’s race?
Mark one or more.
o  White
','181','0 = Not Selected
1 = Selected
','','46324a','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q60b. What is your child’s race?
Mark one or more.
o  Black or African
American
','182','0 = Not Selected
1 = Selected
','','46324b','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q60c. What is your child’s race?
Mark one or more.
o   Asian
','183','0 = Not Selected
1 = Selected
','','46324c','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q60d. What is your child’s race?
Mark one or more.
o Native Hawaiian or
Other Pacific Islander
','184','0 = Not Selected
1 = Selected
','','46324d','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q60e. What is your child’s race?
Mark one or more.
o  American Indian or
Alaska Native
','185','0 = Not Selected
1 = Selected
','','46324e','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q60f.  What is your child’s race?
Mark one or more.
o  Other
','186','0 = Not Selected
1 = Selected
','','46324f','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q61.   What is your age?
','187','0 = Under 18
1 = 18 to 24
2 = 25 to 34
3 = 35 to 44
4 = 45 to 54
5 = 55 to 64
6 = 65 to 74
7 = 75 or older
H = Multiple mark
M = Missing
','A survey will have either 46325 or 48856. 48856 does not have a scale value for Under 18. All codes are the same otherwise.','46325 48856','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q62.   Are you male or female?
','188','1 = Male
2 = Female
H = Multiple mark
M = Missing
','','46326','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q63.  What is the highest grade or level of school that you have completed?
','189','1 = 8th grade or less
2 = Some high school, but did not graduate
3 = High school graduate or GED
4 = Some college or 2-year degree
5 = 4-year college graduate
6 = More than 4-year college degree
H = Multiple mark
M = Missing
','','46327','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q64.   How are you related to the child?
','190','1 = Mother or father
2 = Grandparent
3 = Aunt or Uncle
4 = Older brother or sister
5 = Other relative
6 = Legal guardian
7 = Someone else
H = Multiple mark
M = Missing
','A survey will have either 46328 or 48666. 48666 does not have a hand entry option. All codes are the same.','46328 48666','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q65.   Did someone help you complete this survey?
','191','1 = Yes
2 = No
H = Multiple mark
M = Missing
','A survey will have either 46329 or 48667. 48667 has different skip instructions. All codes are the same.','46329 48667','Y','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q66a. How did that person help you? Mark one or more.
o   Read the questions to me
','192','0 = Not Selected
1 = Selected
S = Appropriately skipped
','A survey will have either 46330 or 48668. 48668 does not have a hand entry option. All codes are the same.','46330a 48668a','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q66b.  How did that person help you? Mark one or more.
o    Wrote down the answers I gave
','193','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','46330b 48668b','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q66c.   How did that person help you? Mark one or more.
o    Answered the questions for me
','194','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','46330c 48668c','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q66d.  How did that person help you? Mark one or more.
o   Translated the questions into my language
','195','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','46330d 48668d','','')
insert into #x values ('Child 12 Month Survey PCMH 2.0', 'Q66e.  How did that person help you? Mark one or more.
o    Helped in some other way
','196','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','46330e 48668e','','')

insert into #x values ('Child 6 Month Survey 2.0', 'Q1.     Our records show that your child got care from
the provider named below in the last 6 months. Is that right?
','120','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','50483','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q2.     Is this the provider you usually see if your child needs a check-up or gets sick or hurt?
','121','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50484','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q3.     How long has your child been going to this
provider?
','122','1 = Less than 6 months
2 = At least 6 months but less than 1 year
3 = At least 1 year but less than 3
years
4 = At least 3 years but less than 5 years
5 = 5 years or more
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50485','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q4.     In the last 6 months, how many times did your child visit this provider for care?
','123','1 = None
2 = 1 time
3 = 2
4 = 3
5 = 4
6 = 5 to 9
7 = 10 or more times
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50486','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q5.     In the last 6 months, did you ever stay in the exam room with your child during a visit to this provider?
','124','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50487','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q6.     Did this provider give you enough information about
what was discussed during the visit when you were not there?
','125','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50488','','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q7.     Is your child able to talk with providers about his or her health care?
','126','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50489','','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q8.     In the last 6 months, how often did this provider explain things in a way
that was easy for your child to understand?
','127','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50490','','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q9.     In the last 6 months, how often did this provider listen carefully to your child?
','128','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50491','','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q10.   Did this provider tell you that you needed to do anything to follow up on the care your child got during the visit?
','129','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50492','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q11.   Did this provider give you enough information about
what you needed to do to follow up on your child’s care?
','130','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50493','','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q12.   In the last 6 months, did you phone this provider’s office to get an appointment for your child for an illness, injury, or condition that needed
care right away?
','131','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50494','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q13.   In the last 6 months, when you phoned this
provider’s office to get an
appointment for care your child needed right away,
how often did you get an appointment as soon as your child needed?
','132','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50495','','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q14.   In the last 6 months, did you make any appointments for a check-
up or routine care for your child with this provider?
','133','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50496','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q15.   In the last 6 months, when you made an
appointment for a check-
up or routine care for your child with this provider,
how often did you get an appointment as soon as your child needed?
','134','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50497','','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q16.   In the last 6 months, did you phone this provider’s
office with a medical question about your child during regular office hours?
','135','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50498','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q17.   In the last 6 months, when you phoned this provider’s office during regular office hours, how
often did you get an answer to your medical question that same day?
','136','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50499','','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q18.   In the last 6 months, did you phone this provider’s office with a medical question about your child after regular office hours?
','137','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50500','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q19.   In the last 6 months, when you phoned this
provider’s office after regular office hours, how often did you get an answer to your medical
question as soon as you needed?
','138','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50501','','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q20.  Wait time includes time spent in the waiting room and exam room. In the
last 6 months, how often did your child see this provider within 15 minutes of his or her appointment
time?
','139','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50502','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q21.   In the last 6 months, how often did this provider explain things about your
child’s health in a way that was easy to understand?
','140','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50503','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q22.   In the last 6 months, how often did this provider listen carefully to you?
','141','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50504','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q23.   In the last 6 months, did you and this provider talk about any questions or concerns you had about your child’s health?
','142','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50505','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q24.   In the last 6 months, how often did this provider give
you easy to understand information about these health questions or concerns?
','143','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50506','','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q25.   In the last 6 months, how often did this provider seem to know the
important information about your child’s medical history?
','144','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50507','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q26.   In the last 6 months, how often did this provider show respect for what you
had to say?
','145','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50508','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q27.   In the last 6 months, how often did this provider spend enough time with
your child?
','146','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50509','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q28.   In the last 6 months, did this provider order a blood test, x-ray, or other test
for your child?
','147','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50510','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q29.   In the last 6 months, when this provider
ordered a blood test, x-
ray, or other test for your child, how often did
someone from this provider’s office follow up to give you those results?
','148','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50511','','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q30.   Using any number from 0 to 10, where 0 is the worst provider possible and 10
is the best provider
possible, what number would you use to rate this provider?
','149-150','0 = 0 Worst provider possible
1 = 1
2 = 2
3 = 3
4 = 4
5 = 5
6 = 6
7 = 7
8 = 8
9 = 9
10 = 10 Best provider possible
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50512','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q31.   In the last 6 months, did you and anyone in this provider’s office talk about
your child’s learning ability?
','151','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50513','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q32.   In the last 6 months, did you and anyone in this
provider’s office talk about
the kinds of behaviors that are normal for your child
at this age?
','152','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50514','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q33.   In the last 6 months, did you and anyone in this
provider’s office talk about how your child’s body is growing?
','153','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50515','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q34.   In the last 6 months, did you and anyone in this provider’s office talk about your child’s moods and emotions?
','154','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50516','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q35.   In the last 6 months, did you and anyone in this provider’s office talk about
things you can do to keep your child from getting injured?
','155','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50517','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q36.   In the last 6 months, did anyone in this provider’s office give you information about how to keep your child from getting injured?
','156','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50518','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q37.   In the last 6 months, did you and anyone in this
provider’s office talk about how much time your child spends on a computer
and in front of a TV?
','157','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50519','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q38.   In the last 6 months, did you and anyone in this provider’s office talk about
how much or what kind of food your child eats?
','158','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50520','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q39.   In the last 6 months, did you and anyone in this
provider’s office talk about
how much or what kind of exercise your child gets?
','159','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50521','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q40.   In the last 6 months, did you and anyone in this provider’s office talk about how your child gets along with others?
','160','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50522','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q41.   In the last 6 months, did you and anyone in this
provider’s office talk about whether there are any problems in your household that might
affect your child?
','161','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50523','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q42.   In the last 6 months, how often were clerks and
receptionists at this
provider’s office as helpful as you thought they
should be?
','162','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50524','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q43.  In the last 6 months, how often did clerks and receptionists at this provider’s office treat you with courtesy and respect?
','163','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50525','Y','Y')
insert into #x values ('Child 6 Month Survey 2.0', 'Q44.   In general, how would you rate your child’s overall health?
','164','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','50526','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q45.   In general, how would you rate your child’s overall mental or emotional health?
','165','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','50527','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q46. What is your child’s age?
o   Less than 1 year old
','166-167','0 = Less than 1 year old
Enter reported age if one year or older
H = Multiple mark
M = Missing
','','50528','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q47.   Is your child male or female?
','168','1 = Male
2 = Female
H = Multiple mark
M = Missing
','','50529','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q48.   Is your child of Hispanic or
Latino origin or descent?
','169','1 = Yes, Hispanic or Latino
2 = No, not Hispanic or Latino
H = Multiple mark
M = Missing
','','50530','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q49a. What is your child’s race?
Mark one or more.
o  White
','170','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325.','50531a
52325a','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q49b. What is your child’s race?
Mark one or more.
o  Black or African
American
','171','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325.','50531b
52325b','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q49c. What is your child’s race?
Mark one or more.
o   Asian
','172','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325.','50531c
52325c','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q49d. What is your child’s race?
Mark one or more.
o Native Hawaiian or
Other Pacific Islander
','173','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325.','50531d
52325d','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q49e. What is your child’s race?
Mark one or more.
o  American Indian or
Alaska Native
','174','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325.','50531e
52325e','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q49f.  What is your child’s race?
Mark one or more.
o  Other
','175','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325. 50531 does not have a scale value for Other; Code 0 if question 50531.','52325f','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q50.   What is your age?
','176','0 = Under 18
1 = 18 to 24
2 = 25 to 34
3 = 35 to 44
4 = 45 to 54
5 = 55 to 64
6 = 65 to 74
7 = 75 or older
H = Multiple mark
M = Missing
','','50532','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q51.   Are you male or female?
','177','1 = Male
2 = Female
H = Multiple mark
M = Missing
','','50533','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q52.  What is the highest grade or level of school that you have completed?
','178','1 = 8th grade or less
2 = Some high school, but did not graduate
3 = High school graduate or GED
4 = Some college or 2-year degree
5 = 4-year college graduate
6 = More than 4-year college degree
H = Multiple mark
M = Missing
','','50534','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q53.   How are you related to the child?
','179','1 = Mother or father
2 = Grandparent
3 = Aunt or Uncle
4 = Older brother or sister
5 = Other relative
6 = Legal guardian
7 = Someone else
H = Multiple mark
M = Missing
','','50535','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q54.   Did someone help you complete this survey?
','180','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','50536','Y','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q55a. How did that person help you? Mark one or more.
o   Read the questions to me
','181','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50537a','','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q55b.  How did that person help you? Mark one or more.
o    Wrote down the answers I gave
','182','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50537b','','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q55c.   How did that person help you? Mark one or more.
o    Answered the questions for me
','183','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50537c','','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q55d.  How did that person help you? Mark one or more.
o   Translated the questions into my language
','184','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50537d','','')
insert into #x values ('Child 6 Month Survey 2.0', 'Q55e.  How did that person help you? Mark one or more.
o   Helped in some other way
','185','0 = Not Selected
1 = Selected
S = Appropriately skipped

','','50537e','','')

insert into #x values ('Child 6 Month Survey 3.0', 'Q1.     Our records show that your child got care from
the provider named below in the last 6 months. Is that right?
','120','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','50483','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q2.     Is this the provider you usually see if your child needs a check-up or gets sick or hurt?
','121','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50484','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q3.     How long has your child been going to this
provider?
','122','1 = Less than 6 months
2 = At least 6 months but less than 1 year
3 = At least 1 year but less than 3
years
4 = At least 3 years but less than 5 years
5 = 5 years or more
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50485','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q4.     In the last 6 months, how many times did your child visit this provider for care?
','123','1 = None
2 = 1 time
3 = 2
4 = 3
5 = 4
6 = 5 to 9
7 = 10 or more times
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50486','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q5.     In the last 6 months, did you ever stay in the exam room with your child during a visit to this provider?
','124','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50487','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q6.     Did this provider give you enough information about
what was discussed during the visit when you were not there?
','125','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50488','','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q7.     Is your child able to talk with providers about his or her health care?
','126','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50489','','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q8.     In the last 6 months, how often did this provider explain things in a way
that was easy for your child to understand?
','127','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50490','','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q9.     In the last 6 months, how often did this provider listen carefully to your child?
','128','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50491','','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q10.   Did this provider tell you that you needed to do anything to follow up on the care your child got during the visit?
','129','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50492','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q11.   Did this provider give you enough information about
what you needed to do to follow up on your child’s care?
','130','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50493','','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q12.   In the last 6 months, did you contact this provider’s office to get an appointment for your child for an illness, injury, or condition that needed
care right away?
','131','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50494','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q13.   In the last 6 months, when you contacted this
provider’s office to get an
appointment for care your child needed right away,
how often did you get an appointment as soon as your child needed?
','132','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50495','','Y')
insert into #x values ('Child 6 Month Survey 3.0', 'Q14.   In the last 6 months, did you make any appointments for a check-
up or routine care for your child with this provider?
','133','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50496','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q15.   In the last 6 months, when you made an
appointment for a check-
up or routine care for your child with this provider,
how often did you get an appointment as soon as your child needed?
','134','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50497','','Y')
insert into #x values ('Child 6 Month Survey 3.0', 'Q16.   In the last 6 months, did you contact this provider’s
office with a medical question about your child during regular office hours?
','135','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50498','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q17.   In the last 6 months, when you contacted this provider’s office during regular office hours, how
often did you get an answer to your medical question that same day?
','136','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50499','','Y')
insert into #x values ('Child 6 Month Survey 3.0', 'Q18.   In the last 6 months, how often did this provider explain things about your
child’s health in a way that was easy to understand?
','137','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50503','Y','Y')
insert into #x values ('Child 6 Month Survey 3.0', 'Q19.   In the last 6 months, how often did this provider listen carefully to you?
','138','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50504','Y','Y')
insert into #x values ('Child 6 Month Survey 3.0', 'Q20.   In the last 6 months, how often did this provider seem to know the
important information about your child’s medical history?
','139','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50507','Y','Y')
insert into #x values ('Child 6 Month Survey 3.0', 'Q21.   In the last 6 months, how often did this provider show respect for what you
had to say?
','140','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50508','Y','Y')
insert into #x values ('Child 6 Month Survey 3.0', 'Q22.   In the last 6 months, how often did this provider spend enough time with
your child?
','141','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50509','Y','Y')
insert into #x values ('Child 6 Month Survey 3.0', 'Q23.   In the last 6 months, did this provider order a blood test, x-ray, or other test
for your child?
','142','1 = Yes
2 = No
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50510','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q24.   In the last 6 months, when this provider
ordered a blood test, x-
ray, or other test for your child, how often did
someone from this provider’s office follow up to give you those results?
','143','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50511','','Y')
insert into #x values ('Child 6 Month Survey 3.0', 'Q25.   Using any number from 0 to 10, where 0 is the worst provider possible and 10
is the best provider
possible, what number would you use to rate this provider?
','144-145','0 = 0 Worst provider possible
1 = 1
2 = 2
3 = 3
4 = 4
5 = 5
6 = 6
7 = 7
8 = 8
9 = 9
10 = 10 Best provider possible
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50512','Y','Y')
insert into #x values ('Child 6 Month Survey 3.0', 'Q26.   In the last 6 months, how often were clerks and
receptionists at this
provider’s office as helpful as you thought they
should be?
','146','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50524','Y','Y')
insert into #x values ('Child 6 Month Survey 3.0', 'Q27.  In the last 6 months, how often did clerks and receptionists at this provider’s office treat you with courtesy and respect?
','147','1 = Never
2 = Sometimes
3 = Usually
4 = Always
S = Appropriately skipped
H = Multiple mark
M = Missing
','','50525','Y','Y')
insert into #x values ('Child 6 Month Survey 3.0', 'Q28.   In general, how would you rate your child’s overall health?
','148','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','50526','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q29.   In general, how would you rate your child’s overall mental or emotional health?
','149','1 = Excellent
2 = Very good
3 = Good
4 = Fair
5 = Poor
H = Multiple mark
M = Missing
','','50527','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q30. What is your child’s age?
o   Less than 1 year old
','150-151','0 = Less than 1 year old
Enter reported age if one year or older
H = Multiple mark
M = Missing
','','50528','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q31.   Is your child male or female?
','152','1 = Male
2 = Female
H = Multiple mark
M = Missing
','','50529','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q32.   Is your child of Hispanic or
Latino origin or descent?
','153','1 = Yes, Hispanic or Latino
2 = No, not Hispanic or Latino
H = Multiple mark
M = Missing
','','50530','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q33a. What is your child’s race?
Mark one or more.
o  White
','154','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325.','50531a
52325a','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q33b. What is your child’s race?
Mark one or more.
o  Black or African
American
','155','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325.','50531b
52325b','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q33c. What is your child’s race?
Mark one or more.
o   Asian
','156','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325.','50531c
52325c','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q33d. What is your child’s race?
Mark one or more.
o Native Hawaiian or
Other Pacific Islander
','157','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325.','50531d
52325d','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q33e. What is your child’s race?
Mark one or more.
o  American Indian or
Alaska Native
','158','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325.','50531e
52325e','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q33f.  What is your child’s race?
Mark one or more.
o  Other
','159','0 = Not Selected
1 = Selected
','A survey will have either 50531 or 52325. 50531 does not have a scale value for Other; Code 0 if question 50531.','52325f','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q34.   What is your age?
','160','0 = Under 18
1 = 18 to 24
2 = 25 to 34
3 = 35 to 44
4 = 45 to 54
5 = 55 to 64
6 = 65 to 74
7 = 75 or older
H = Multiple mark
M = Missing
','','50532','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q35.  Are you male or female?
','161','1 = Male
2 = Female
H = Multiple mark
M = Missing
','','50533','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q36.  What is the highest grade or level of school that you have completed?
','162','1 = 8th grade or less
2 = Some high school, but did not graduate
3 = High school graduate or GED
4 = Some college or 2-year degree
5 = 4-year college graduate
6 = More than 4-year college degree
H = Multiple mark
M = Missing
','','50534','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q37.   How are you related to the child?
','163','1 = Mother or father
2 = Grandparent
3 = Aunt or Uncle
4 = Older brother or sister
5 = Other relative
6 = Legal guardian
7 = Someone else
H = Multiple mark
M = Missing
','','50535','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q38.   Did someone help you complete this survey?
','164','1 = Yes
2 = No
H = Multiple mark
M = Missing
','','50536','Y','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q39a. How did that person help you? Mark one or more.
o   Read the questions to me
','165','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50537a','','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q39b.  How did that person help you? Mark one or more.
o    Wrote down the answers I gave
','166','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50537b','','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q39c.   How did that person help you? Mark one or more.
o    Answered the questions for me
','167','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50537c','','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q39d.  How did that person help you? Mark one or more.
o   Translated the questions into my language
','168','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50537d','','')
insert into #x values ('Child 6 Month Survey 3.0', 'Q39e.  How did that person help you? Mark one or more.
o   Helped in some other way
','169','0 = Not Selected
1 = Selected
S = Appropriately skipped
','','50537e','','')


update #x set instrument=replace(instrument,'Adult','A')
update #x set instrument=replace(instrument,'Child','C')
update #x set instrument=replace(instrument,'survey','')
update #x set instrument=replace(instrument,' month','M')
update #x set instrument=replace(instrument,'  ',' ')

select instrument, count(*) from #x group by instrument



select distinct instrument from #x

select distinct instrument, left(qstncore,6) as qstncore, left(variable_dsc, charindex('.',variable_dsc))
from #x
where variable_dsc like 'Q1.%'



select instrument, count(*)
from #x 
where instrument in ('Child 6 Month Survey 2.0','Child 6 Month Survey PCMH 2.0')
group by instrument

select qstncore, instrument, left(variable_dsc, charindex('.',variable_dsc)) from #x where qstncore in ('44121','44127','50344','50541','50226','39113','46265','50483','50500','50629')


select ' '+q+'  = case isnull('+qstncore+',-9) when -9 then ''M'' when -8 then ''H'' else '+qstncore+'%10000 end,'
from (
select qstncore, instrument, left(variable_dsc, charindex('.',variable_dsc)-1) as q, x_id
from #x 
where instrument  = 'C 6M 3.0') x

select *,left(variable_dsc, charindex('.',variable_dsc)-1) as q
from #x where instrument  = 'C 6M 3.0'


select 'update #results set '+q+'  = ''S''  where '+q+'  = ''M''  and (Q1=''2'' or Q4=''1'')'
	from (select qstncore, instrument, left(variable_dsc, charindex('.',variable_dsc)-1) as q, x_id
	from #x 
	where instrument  = 'c 6M 3.0') x
order by x_id
