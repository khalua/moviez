create table movies(
id serial4 primary key,
title varchar(30) not null,
rated varchar(10),
year smallint,
director varchar(50),
plot text
);