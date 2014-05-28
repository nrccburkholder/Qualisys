create procedure DB_storage_overview
AS
declare @db_name varchar(50),
        @sp varchar(50),
        @dbcount int,
        @filecount int,
        @filegcount int
 
 
SET NOCOUNT ON
declare @DBNames table (name varchar(100) primary key)
INSERT INTO @DBNames
select name 
from master..sysdatabases
where databasepropertyex(name,'status') not in 
	('SUSPECT', 'OFFLINE', 'RESTORING', 'RECOVERING') and 
	has_dbaccess(name) = 1
 
/*
***********************************************************************
* Create temporary tables needed to hold space information
***********************************************************************
*/
 
create table #dbspace  (database_name sysname,
                        total_space decimal(35,2),
                        used_db_space decimal(35,2) NULL,
                        total_log_space decimal(35,2))
create table #logspace (database_name sysname,
                        auto_grow int NULL,
                        log_space decimal(35,2),
                        pct_used decimal(35,2) NULL,
                        status int)
create table #dbgrowth  (database_name sysname NULL,
                        auto_grow char(1) NULL)
create table #loggrowth (database_name sysname NULL,
                        auto_grow int NULL)
create table #disk_free (diskname  varchar(50) null,
                         freespace decimal(35,2) null)
create table #sql_space (diskname varchar(50) null,
                         dbname   sysname     null,
                         logspace decimal(35,2) null,
                         sqlspace decimal(35,2) null)
create table #file_count (filecount int null,
                          filegroupcount int null)
 
/* initialize server counters */
select 
    @dbcount = 0
select 
    @filecount = 0
select
    @filegcount = 0
 
/* get information for disk free space */
 
insert 
    into #disk_free exec ('master.dbo.xp_fixeddrives')
 
/*
**********************************************************************
* Open database cursor and loop through all databases on server to
* collect their database space information
***********************************************************************
*/
 SELECT TOP 1 @db_name=name
 FROM @DBNames

 WHILE @@ROWCOUNT>0
 BEGIN
    insert 
        into #file_count 
    EXEC ('use [' + @db_name + '] 
    select  
        file_count = 
        (select 
            count(*) 
         from 
            sysfiles), 
        file_group_count = 
        (select 
            count(*) 
         from 
            sysfilegroups)')
     
    select 
        @filecount = @filecount + filecount from #file_count
    select 
        @filegcount = @filegcount + filegroupcount from #file_count
    truncate table 
        #file_count
 /*
**********************************************************************
* Collect database space
***********************************************************************
*/

    insert 
        into #dbspace (database_name,total_space,used_db_space,total_log_space) 
        EXEC ('use [' + @db_name + '] 
        select 
            db_name = db_name(),
            total_space = 
            (select 
                sum(convert(decimal(35,2),size)) / convert( float, (1048576 / 
                (select low from master.dbo.spt_values where number = 1 and 
       type = ''E'')))
             from dbo.sysfiles),
             total_db_used = 
             (select 
                (sum(convert(decimal(35,2),reserved)) * 
                (select low 
                 from 
                    master.dbo.spt_values 
                 where 
                    number = 1 and 
                    type = ''E''))/1024/1024 
               from 
                sysindexes
     where
       indid in (0,1,255)),
               total_log_space = 
               (select 
                sum(convert(decimal(35,2),size)) / convert( float, (1048576 / 
                (select 
                    low 
                from 
                    master.dbo.spt_values 
                where 
                    number = 1 and 
                    type = ''E''))) 
                from 
                    dbo.sysfiles 
                where (status & 0x40)=0x40)' )

    -- end collection of database space
    
    insert 
        into #dbgrowth (auto_grow) 
        EXEC ('use [' + @db_name + '] 
        select 
            count(*) - 
            ISNULL((select count(*) 
            from 
                sysfiles 
            where 
                growth = 0 and 
                groupid=FILEGROUP_ID(''PRIMARY'')),0) 
        from 
            sysfiles 
        where 
            groupid=FILEGROUP_ID(''PRIMARY'')')
        
    insert 
        into #loggrowth (auto_grow) 
        EXEC ('use [' + @db_name + '] 
        select 
            count(*) - 
            ISNULL((select count(*) 
            from 
                sysfiles 
            where 
                growth = 0 and 
                (status&0x40)=0x40),0) 
        from 
            sysfiles 
        where (status&0x40)=0x40')
        
    update 
        #dbgrowth 
    set database_name = @db_name 
    where 
        database_name is NULL
        
    update 
        #loggrowth 
    set database_name = @db_name 
    where 
        database_name is NULL
 
    insert 
        into #sql_space 
    EXEC ('use [' + @db_name + '] 
    select 
        upper(substring(a.filename,1,2)),
        DB_NAME(),
        log_space = case groupid when 0 then sum(convert(decimal(35,2),size)) else 0 end, 
        sql_space = case groupid when 0 then 0 else sum(convert(decimal(35,2),size)) end 
    from sysfiles a 
    group by 
        upper(substring(a.filename,1,2)),groupid')

	 DELETE
	 FROM @DBNames
	 WHERE name=@db_name
 
	 SELECT TOP 1 @db_name=name
	 FROM @DBNames

 
 end
 
/*
**********************************************************************
* Get log info
***********************************************************************
*/
 
insert 
    into #logspace (database_name,log_space,pct_used,status)
select  
    db_name = a.instance_name,
    log_size_mb = convert(decimal(15,2),a.cntr_value) / 1024,
    log_pct_used = 100 * convert(decimal(15,2),b.cntr_value) / a.cntr_value,
    status = 0
from
    master..sysperfinfo a,
    master..sysperfinfo b
where   
    a.object_name = 'SQLServer:Databases' and
    b.object_name = 'SQLServer:Databases' and
    a.counter_name = 'Log File(s) Size (KB)' and
    b.counter_name = 'Log File(s) Used Size (KB)' and
    a.instance_name <> '_Total' and
    b.instance_name <> '_Total' and
    a.instance_name = b.instance_name
 
/*
***********************************************************************
* Display server counts of databases, files, and filegroups 
***********************************************************************
*/
 
select 
    @dbcount = count(*) 
from 
    master..sysdatabases
--    
--select 
--    database_count = convert(varchar,@dbcount  )
--    
--select 
--    file_count = convert(varchar,@filecount  )
--select 
--    file_group_count = convert(varchar,@filegcount + @dbcount )

/*
***********************************************************************
* Display totals of all database and log space
***********************************************************************
*/ 
--select 
--    'Total Database' = 
--        sum(convert(decimal(35,2),total_space)) - 
--        sum(convert(decimal(35,2),total_log_space)),
--    'Total Log' = 
--        sum(convert(decimal(35,2),total_log_space))
--from   
--    #dbspace a,
--    #logspace b
--where  
--    a.database_name = b.database_name
 
/*
***********************************************************************
* Display information for logs
***********************************************************************
*/
-- 
--select 
--    database_name = a.database_name,
--    total_log_space,
--    log_can_grow = case
--                       when d.auto_grow > 0 then 'Yes'
--                       when d.auto_grow = 0 then 'No'
--                      end,
--    total_log_space_used = convert(decimal(35,2),(a.total_log_space * (pct_used/100))),
--    total_free_log_space = convert(decimal(35,2),(total_log_space - 
--    (a.total_log_space * (pct_used/100)))),
--    percent_log_used = pct_used
--from
--    #dbspace a,
--    #logspace b,
--    #loggrowth d
--where
--    a.database_name = b.database_name and
--    b.database_name = d.database_name
--order by 
--    database_name

/*
***********************************************************************
* Display information for databases
***********************************************************************
*/
 
select 
    database_name = a.database_name,
    total_space,
    total_db_space = total_space - total_log_space,
    db_can_grow = case
                      when c.auto_grow > 0 then 'Yes'
                      when c.auto_grow = 0 then 'No'
                     end,
    total_space_used = convert(decimal(35,2),
    (used_db_space + (a.total_log_space * (pct_used/100)))),
    total_db_space_used = used_db_space,
    total_free_space = convert(decimal(35,2),(total_space - 
    (used_db_space + (a.total_log_space * (pct_used/100))))),
    total_free_db_space = (total_space - total_log_space) - used_db_space,
    percent_db_used = convert(decimal(35,2),
    (100 * (used_db_space / (total_space - total_log_space))))
from
    #dbspace a,
    #logspace b,
    #dbgrowth c
where
    a.database_name = b.database_name and
    a.database_name = c.database_name
order by 
    database_name
 

/*
***********************************************************************
* Display information for server hard drives
***********************************************************************
*/
 
--select 
--    a.diskname, 
--    total_sql_mb  = 
--        isnull(convert(decimal(35,2),
--        round((sum(convert(decimal(35,2),b.sqlspace * 8)) / 1024),2)),0),
--    total_log_mb  = 
--        isnull(convert(decimal(35,2),
--        round((sum(convert(decimal(35,2),b.logspace * 8)) / 1024),2)),0),
--    total_free_mb = isnull(max(freespace),0)
--from 


/*
***********************************************************************
* Clean up work
***********************************************************************
*/
 
drop table #dbspace
drop table #logspace
drop table #dbgrowth
drop table #loggrowth
drop table #disk_free
drop table #sql_space
drop table #file_count


