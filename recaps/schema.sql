drop table if exists posted_entries;
create table posted_entries (
	id integer primary key autoincrement,
	recapper text not null,
	category text not null,
	subcategory text,
	description text not null,
	link text not null,
	foreign key(recapper) references recappers(name)
);

drop table if exists recappers;
create table recappers (
	name text primary key,
	header text not null
);

drop table if exists recaps;
create table recaps (
	id integer primary key autoincrement,
	save_time timestamp default current_timestamp,
	recapper text not null,
	content text not null,
	manual boolean not null,
	foreign key(recapper) references recappers(name)
);

insert into recappers ("name", "header") values
	("Beyamor", "http://i763.photobucket.com/albums/xx276/l6t4g1/beyamorisms.jpg");
