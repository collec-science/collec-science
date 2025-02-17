update metadata
set metadata_schema = regexp_replace(metadata_schema::varchar, 'N/A', '','ig')::json;
update metadata
set metadata_schema = regexp_replace(metadata_schema::varchar, 'N\\/A', '','ig')::json;
