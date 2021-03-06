create database news
go
use news
go

create table [user](
	u_id int identity primary key,
	create_date datetime,
	write_date datetime,
	u_name nvarchar(100),
	u_username varchar(50) unique,
	u_password varchar(50),
	u_img nvarchar(100),
	u_email varchar(100),
	u_birthday datetime,
	u_sex nvarchar(20),
	u_status bit,
	role_id int
)

create table [role](
	role_id int identity primary key,
	create_date datetime,
	write_date datetime,
	role_name varchar(100),
	role_des nvarchar(100)
)

create table category(
	cate_id int identity primary key,
	create_date date,
	create_uid int,
	write_date date,
	write_uid int,
	parent_id int,
	cate_alias varchar(100),
	cate_name nvarchar(100),
	cate_order int
)

create table tbl_news(
	news_id int identity primary key,
	news_type nvarchar(200),
	news_title nvarchar(200),
	news_alias varchar(200),
	news_url varchar(500),
	news_image_sprite varchar(100),
	news_file_vtt varchar(500),
	news_author varchar(100),
	news_source nvarchar(100),
	news_date nvarchar(100),
	news_infor nvarchar(250),
	news_full ntext,
	news_check char(1),
	news_img varchar(250),
	news_view int,
	news_taglist nvarchar(250),
	news_keyword nvarchar(250),
	u_id int,
	cate_id int
)

create table assessment(
	assess_id int identity primary key,
	parent_id int,
	u_id int,
	news_id int,
	assess_date nvarchar(100),
	assess_context nvarchar(250),
	assess_like int
)

/*-------PROC: User -----*/
/*select all*/
create proc sp_selectUserAll
as
select * from [user] inner join [role] on [user].role_id = [role].role_id
go

/*select by Username*/
create proc sp_selectUserByUsername
@username nvarchar(50)
as
select * from [user] inner join [role] on [user].role_id = [role].role_id where [user].u_username like N'%'+@username+'%'
go

/*select by Id*/
create proc sp_selectUserById
@id int
as
select * from [user] inner join [role] on [user].role_id = [role].role_id where [user].u_id = @id
go

/*select by Date*/
create proc sp_selectUserByDate
@date datetime
as
select * from [user] inner join [role] on [user].role_id = [role].role_id where [user].create_date =@date
go

/*select by sex*/
create proc sp_selectUserBySex
@sex nvarchar(20)
as
select * from [user] inner join [role] on [user].role_id = [role].role_id
where [user].u_sex = @sex
go 

/*select by role id*/
create proc sp_selectUserByRole
@role_id int
as
select * from [user] inner join [role] on [user].role_id = [role].role_id
where [user].role_id = @role_id
go
 
/*Insert User*/
create proc sp_insertUser
@create_date datetime,
@u_name nvarchar(100),
@u_username varchar(50),
@u_password varchar(50),
@u_img nvarchar(100),
@u_email varchar(100),
@u_birthday datetime,
@u_sex nvarchar(20),
@role_id int,
@status bit
as
insert into [user] values(@create_date,null, @u_name,@u_username,@u_password,@u_img,@u_email,@u_birthday,@u_sex,@role_id, @status)
go

/*Update User*/
create proc sp_updateUser
@write_date datetime,
@u_name nvarchar(100),
@u_username varchar(50),
@u_new_password varchar(50),
@u_img nvarchar(100),
@u_email varchar(100),
@u_birthday datetime,
@u_sex nvarchar(20),
@role_id int,
@status bit
as
update [user] set write_date = @write_date, u_password = @u_new_password,u_name=@u_name,u_img=@u_img,u_email=@u_email,u_birthday=@u_birthday,u_sex=@u_sex,role_id=@role_id, u_status = @status where u_username=@u_username
go

/*Delete User by username*/
create proc sp_deleteUserByUsername
@username varchar(50)
as
delete from [user] where u_username = @username
go


/*Delete User by id*/
create proc sp_deleteUserById
@id int
as
delete from [user] where u_id = @id
go

/*-------PROC: Role -----*/
create proc sp_selectRoleAll
as
select * from [role]
go

create proc sp_deleteRole
@role_id int
as
delete from [role] where role_id=@role_id
go

create proc sp_inserRole
@create_date datetime,
@role_name varchar(100),
@role_des nvarchar(100)
as
insert into [role] values(@create_date,null,@role_name,@role_des)
go

/*exec sp_inserRole @create_date = '2015-04-04', @role_name = 'admin' ,@role_des='avx'
create proc sp_insertRole1
@create_date1 date,
@create_uid1 int,
@role_name1 varchar(100),
@role_des1 nvarchar(100)
as
DECLARE @STATEMENT NVARCHAR(MAX),@ParamDefinition NVARCHAR(MAX), @SqlStr NVARCHAR(MAX)
SET @SqlStr = N'insert into [role] values(@create_date, @create_uid, null, null, @role_name, N@role_des)'
SET @ParamDefinition = N'@create_date date, @create_uid int, @role_name varchar(100), @role_des nvarchar(100)'
EXEC SP_EXECUTESQL
@STATEMENT = @SqlStr,
@params = @ParamDefinition,
@create_date = @create_date1,
@create_uid = @create_uid1,
@role_name = @role_name1,
@role_des = @role_des1
go*/

create proc sp_updateRole
@role_id int,
@write_date datetime,
@role_name varchar(100),
@role_des nvarchar(100)
as
update [role] set write_date = @write_date, role_name=@role_name,role_des=@role_des where role_id=@role_id
go

/*-------PROC: Category -----*/
create proc sp_selectCategoryAll
as
select * from category order by cate_order ASC
go

/*insert cate*/
create proc sp_insertCate
@create_date date,
@create_uid int,
@parent_id int,
@cate_alias varchar(100),
@cate_name nvarchar(100),
@cate_order int
as
insert into category values(@create_date, @create_uid, null, null, @parent_id,@cate_alias,@cate_name,@cate_order)
go

/*Update cate*/
create proc sp_updateCate
@cate_id int,
@write_date date,
@write_uid int,
@parent_id int,
@cate_alias varchar(100),
@cate_name nvarchar(100),
@cate_order int
as
update category set write_date = @write_date, write_uid = @write_uid, parent_id = @parent_id, cate_alias=@cate_alias,cate_name=@cate_name,cate_order=@cate_order where cate_id = @cate_id
go

/*Delete cate*/
create proc sp_deleteCate
@cate_id int
as
delete from category where cate_id = @cate_id
go

/*-----------BEGIN:PROC_NEWS-------*/

/*Select All News*/
create proc sp_selectNewsAll
as
select * from tbl_news inner join category on tbl_news.cate_id = category.cate_id inner join [user] on tbl_news.u_id = [user].u_id
go

/*Insert News*/
create proc sp_insertNews
	@news_title nvarchar(200),
	@news_alias varchar(200),
	@news_url varchar(500),
	@news_image_sprite varchar(100),
	@news_file_vtt varchar(500),
	@news_author varchar(100),
	@news_source nvarchar(100),
	@news_date nvarchar(100),
	@news_infor nvarchar(250),
	@news_full ntext,
	@news_check char(1),
	@news_img varchar(250),
	@news_view int,
	@news_taglist nvarchar(250),
	@news_keyword nvarchar(250),
	@u_id int,
	@cate_id int,
	@news_type nvarchar(200)
	as
insert into tbl_news values(@news_title,@news_alias,@news_url,@news_image_sprite,@news_file_vtt,@news_author,@news_source,@news_date,@news_infor,@news_full,@news_check,@news_img,@news_view,@news_taglist,@news_keyword,@u_id,@cate_id,@news_type)
go

/*Update News*/
create proc sp_updateNews
	@news_id int,
	@news_title nvarchar(200),
	@news_alias varchar(200),
	@news_url varchar(500),
	@news_image_sprite varchar(100),
	@news_file_vtt varchar(500),
	@news_author varchar(100),
	@news_source nvarchar(100),
	@news_infor nvarchar(250),
	@news_full ntext,
	@news_check char(1),
	@news_img varchar(250),
	@news_view int,
	@news_taglist nvarchar(250),
	@news_keyword nvarchar(250),
	@u_id int,
	@cate_id int,
	@news_type nvarchar(200)
	as
update tbl_news set news_title=@news_title,news_alias=@news_alias,news_url=@news_url,
news_image_sprite=@news_image_sprite,news_file_vtt=@news_file_vtt,news_author=@news_author,news_source=@news_source,
news_infor=@news_infor,news_full=@news_full,news_check=@news_check,news_img=@news_img,news_view=@news_view,news_taglist=@news_taglist,
news_keyword=@news_keyword,u_id=@u_id,cate_id=@cate_id, news_type = @news_type
WHERE news_id = @news_id
go

/*Search by id*/
create proc sp_searchNewsById
@id int
as
select * from tbl_news inner join 
category on tbl_news.cate_id = category.cate_id inner join [user] on tbl_news.u_id = [user].u_id where tbl_news.news_id = @id
go

/*Search by Title*/
create proc sp_searchNewsByTitle
@title nvarchar(200)
as
select * from tbl_news inner join 
category on tbl_news.cate_id = category.cate_id inner join [user] on tbl_news.u_id = [user].u_id where tbl_news.news_title like N'%'+@title+'%'
go

/*Search by Date*/
create proc sp_searchNewsByDate
@date nvarchar(100)
as
select * from tbl_news inner join 
category on tbl_news.cate_id = category.cate_id inner join [user] on tbl_news.u_id = [user].u_id where tbl_news.news_date like N'%'+@date+'%'
go

/*Search by View*/
create proc sp_searchNewsByView
@view int
as
select * from tbl_news inner join 
category on tbl_news.cate_id = category.cate_id inner join [user] on tbl_news.u_id = [user].u_id where tbl_news.news_view = @view
go

/*Search by Keyword*/
create proc sp_searchNewsByKey
@key nvarchar(250)
as
select * from tbl_news inner join 
category on tbl_news.cate_id = category.cate_id inner join [user] on tbl_news.u_id = [user].u_id where tbl_news.news_keyword like N'%'+@key+'%'
go

/*Search by User*/
create proc sp_searchNewsByUser
@user varchar(50)
as
select * from tbl_news inner join 
category on tbl_news.cate_id = category.cate_id inner join [user] on tbl_news.u_id = [user].u_id where [user].u_username = @user
go

/*Search by Tag*/
create proc sp_searchNewsByTag
@tag nvarchar(250)
as
select * from tbl_news inner join 
category on tbl_news.cate_id = category.cate_id inner join [user] on tbl_news.u_id = [user].u_id where tbl_news.news_taglist like N'%'+@tag+'%'
go

/*Search by Category*/
create proc sp_searchNewsByCate
@cate_id int
as
select * from tbl_news inner join 
category on tbl_news.cate_id = category.cate_id inner join [user] on tbl_news.u_id = [user].u_id where tbl_news.cate_id = @cate_id 
go

/*Search by NewsType*/
create proc sp_searchNewsByNewsType
@news_type nvarchar(200)
as
select * from tbl_news inner join 
category on tbl_news.cate_id = category.cate_id inner join [user] on tbl_news.u_id = [user].u_id where tbl_news.news_type = @news_type 
go

/*Search by CateAlias*/
create proc sp_selectNewsByCateAlias
@alias varchar(100)
as
select * from tbl_news inner join 
category on tbl_news.cate_id = category.cate_id inner join [user] on tbl_news.u_id = [user].u_id where category.cate_alias=@alias
go

/*Search by NewsID*/
create proc sp_selectNewsByNewsID
@id int
as
select * from tbl_news inner join 
category on tbl_news.cate_id = category.cate_id inner join [user] on tbl_news.u_id = [user].u_id where tbl_news.news_id = @id
go


/*Delete News*/
create proc sp_deleteNews
@news_id int
as
delete from tbl_news
where news_id=@news_id
go

select * from [user]
