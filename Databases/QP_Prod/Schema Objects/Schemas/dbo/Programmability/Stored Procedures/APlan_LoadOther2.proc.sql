create procedure APlan_LoadOther2
  @From varchar(30) , @Where varchar(255) = 'samptype=''D'''
as
if (isnull(OBJECT_ID('tempdb..#mrd'),0) = 0) 
begin
  RAISERROR ('#mrd does not exist. Please create first', 16, 1)
  return
end  

if (isnull(OBJECT_ID(@From),0) = 0)
begin
  set @where = '"'+@from +'" does not exist. Please verify name.'
  RAISERROR (@where, 16, 1)
  return  
end

begin
  declare @strField varchar (30), @sql varchar(5000)
  declare curMissing cursor for --do we need to add any fields to #mrd?
  select name+case when xtype = 56 then ' int' when xtype = 61 then ' datetime' when xtype =167 then ' varchar ('+cast(length as varchar(3))+')' when xtype = 175 then ' char ('+cast(length as varchar(3))+')' else ' int' end  from syscolumns where id in (select object_ID(@From))
    and name not in (select name from tempdb..syscolumns where id in (select OBJECT_ID('tempdb..#mrd'))) order by name
  set @sql = '0'
  open curMissing
  Fetch next from curMissing  into @strField  
  if @@fetch_status = 0 
  begin  
    set @sql = 'alter table #mrd add '+@strField
    Fetch next from curMissing  into @strField
  end

  while @@fetch_status=0
  begin
    set @sql = @sql+','+@strField
    Fetch next from curMissing  into @strField
  end
  close curMissing
  deallocate curMissing
  if @sql <> '0' 
  begin
    print (@sql)
    execute (@sql)
  end
  --determine which fields are common to both tables
  declare curMissing cursor for
    select name from tempdb..syscolumns where id in (select OBJECT_ID('tempdb..#mrd')) 
      and name  in (select name from syscolumns where id in(select object_ID(@From))) order by name
 

  open curMissing
  set @sql = '0'
  Fetch next from curMissing  into @strField  
  if @@fetch_status = 0 
  begin  
    set @sql = @strField
    Fetch next from curMissing  into @strField
  end

  while @@fetch_status=0
  begin
    set @sql = @sql+','+@strField
    Fetch next from curMissing  into @strField
  end
  close curMissing
  deallocate curMissing
  if @sql <> '0' 
  begin 
    print 'insert into #mrd ('+@sql+')  (select '+@sql+' from '+@From+' where '+@Where+')'
    execute('insert into #mrd ('+@sql+')  (select '+@sql+' from '+@From+' where '+@Where+')')
  end
end


