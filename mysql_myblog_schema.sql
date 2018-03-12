

 /*----------------
 
 db schema for Myblog :

1. article header table : article_url, title, update_date 
2. article tags list table: article_url, tag_name


 
 
 *-------------*/
 
 create table article_header (article_url nvarchar(256), title nvarchar(200), update_date nvarchar(200)) ;
 create table article_tag(article_url nvarchar(256), tag_name nvarchar(50)) ;