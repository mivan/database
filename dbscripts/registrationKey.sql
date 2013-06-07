-- Insert a single user PostBooks registration key if one does not exist
insert into metric (metric_name, metric_value) 
select 'RegistrationKey', '1GEHT-CTWEJ-ZGY8Z-MXJZK-ECVCQ'
where not exists (select metric_id from metric where metric_name = 'RegistrationKey');