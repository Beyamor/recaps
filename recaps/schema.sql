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

insert into recappers (name, header) values ("Beyamor", "http://i763.photobucket.com/albums/xx276/l6t4g1/beyamorisms.jpg");
insert into recappers (name, header) values ("bbain", "http://i.imgur.com/7JkKE.jpg");
insert into recappers (name, header) values ("ShadeOfLight", "http://i.imgur.com/vDz3T.jpg");
insert into recappers (name, header) values ("StriderHoang", "http://i763.photobucket.com/albums/xx276/l6t4g1/striderisms.jpg");
insert into recappers (name, header) values ("Wrenchfarm", "http://i763.photobucket.com/albums/xx276/l6t4g1/wrenchisms.jpg");
insert into recappers (name, header) values ("MacManus", "http://i.imgur.com/vVn2aMv.jpg?1");
insert into recappers (name, header) values ("smurfee mcfee", "http://i224.photobucket.com/albums/dd51/smurfee_mcgee/mcgeeisms2.jpg");
insert into recappers (name, header) values ("PhilKenSebben", "http://i.imgur.com/pLuvV.jpg");
insert into recappers (name, header) values ("Jinx01", "http://www.destructoid.com//ul/user/2/25438-255803-cbjinxisms02jpg-620x.jpg");
insert into recappers (name, header) values ("TheManchild", "http://i230.photobucket.com/albums/ee86/joelphosis/mangasms.jpg~original");
insert into recappers (name, header) values ("Glowbear", "http://i.imgur.com/v9S1BQf.jpg");
insert into recappers (name, header) values ("Crackity Jones", "http://i.imgur.com/ocYFFJl.jpg");
insert into recappers (name, header) values ("Dreamweaver", "http://i.imgur.com/EQvAXeu.jpg");
insert into recappers (name, header) values ("Pixelated", "http://i.imgur.com/7jEuSni.jpg");
