# Rename a metadata field

## Presentation

The metadata describing the samples are stored in a field in JSON format. If it allows a great flexibility (possibility of adding fields very easily), it also has its own limits.

The editor used in the software to modify the metadata will completely rewrite the content of the JSON field. If the field contained a previously unknown field in the model, it will be lost.
In order to modify the name of a field, we must therefore proceed in several steps.

Let's imagine that we want to rename the field "espece" to "species".

### First step: rename the field in the database

With an SQL editor, we will first check the renaming operation before executing it: 

~~~
select sample_id, metadata, metadata -> 'espece',
jsonb_insert(metadata::jsonb, '{"species"}'::text[], (metadata->'espece' )::jsonb) - 'espece'
from col.sample 
where metadata ->> 'espece' is not null;
~~~

The query allows to add a field "species" whose content is 'espece' (*jsonb_insert*), then to remove the field 'espece' (- 'espece').

To update the data, you just have to modify the query as follows: 

~~~
update col.sample 
set metadata = jsonb_insert(metadata::jsonb, '{"species"}'::text[], (metadata->'espece' )::jsonb) - 'espece'
where metadata ->> 'espece' is not null;
~~~

### Second step: modify the corresponding metadata template(s)

In the software, edit the metadata template(s) to rename the 'espece' field to 'species'.

You can quickly view the list of metadata templates that contain the relevant label:

~~~
select metadata_id, metadata_name, metadata_schema
from col.metadata
where metadata_schema::text like '%espece%';
~~~

Translated with www.DeepL.com/Translator (free version)