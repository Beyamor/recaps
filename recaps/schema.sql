drop table if exists posted_entries;
create table posted_entries (
	id integer primary key autoincrement,
	recapper text not null,
	category text not null,
	subcategory text,
	description text not null,
	url text not null
);

drop table if exists recappers;
create table recappers (
	id integer primary key autoincrement,
	name text not null,
	header text not null
);

insert into recappers ("name", "header") values
	("Beyamor", "http://i763.photobucket.com/albums/xx276/l6t4g1/beyamorisms.jpg");
