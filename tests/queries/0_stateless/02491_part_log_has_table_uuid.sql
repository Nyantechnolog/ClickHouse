create table data_02491 (key Int) engine=MergeTree() order by tuple();
insert into data_02491 values (1);
optimize table data_02491 final;
truncate table data_02491;

system flush logs;
with (select uuid from system.tables where database = currentDatabase() and table = 'data_02491') as table_uuid_
select event_type, merge_reason from system.part_log
where
    database = currentDatabase() and
    table = 'data_02491' and
    table_uuid = table_uuid_ and
    table_uuid != toUUIDOrDefault(Null)
order by event_time_microseconds;

drop table data_02491;
