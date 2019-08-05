set search_path = gacl;
alter table logingestion add column is_expired boolean default false;
alter table logingestion alter column datemodif type timestamp;
drop table login_oldpassword cascade;
create index log_commentaire_idx on log using btree ( commentaire);
create unique index logingestion_login_idx on logingestion using btree(login);
alter table logingestion alter column is_clientws drop not null;
create index log_ip_idx on log using btree (ipaddress);
