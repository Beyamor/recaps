drop table if exists posted_entries;
create table posted_entries (
	id integer primary key autoincrement,
	recapper text not null,
	category text not null,
	subcategory text,
	description text not null
);
