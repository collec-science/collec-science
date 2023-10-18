# Give consultation rights to all users

If a user has only the right to consult (*consult*), if he/she can view all the samples, he/she cannot however consult the metadata or the associated documents (except the last published one).

It is however possible to activate the visualization of the metadata for all the samples, whatever the collection considered.

## Before version 2.9

Manually insert the following record in the dbparam table:

~~~
insert into col.dbparam (dbparam_name, dbparam_value)
values ('consult_sees_all', '1');
~~~

## As of version 2.9

Edit the application settings (administration menu), and change the value *consultSeesAll* to 1.


*Translated with www.DeepL.com/Translator (free version)*