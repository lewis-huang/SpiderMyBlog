

 /*----------------
 
 db schema for Myblog :

1. article header table : article_url, title, update_date 
2. article tags list table: article_url, tag_name


 
 
 *-------------*/
 
 create table article_header (article_url nvarchar(256), title nvarchar(200), update_date nvarchar(200)) ;
 create table article_tag(article_url nvarchar(256), tag_name nvarchar(50)) ;
 
 select *from article_header order by update_date desc 
 select *from article_header order by articleId ASC
  
  
  -- daily log table to save the page view count for each day
  
  CREATE TABLE article_page_view_daily (articleId int, date_load datetime, page_view_count int )
  
  drop procedure  article_page_view_update ;
  DELIMITER //
  
  CREATE PROCEDURE article_page_view_update (
	 ArticleUrl VARCHAR(256),
     Title NVARCHAR(200),
     UpdateDate NVARCHAR(200),	
     PageViewCnt Int 
    )
  BEGIN 
	
    DECLARE ArticleIdX INT default 0;
    
    IF ( NOT EXISTS(SELECT * FROM article_header WHERE article_url = ArticleUrl ) ) Then    
		INSERT INTO article_header(article_url, title, update_date) VALUES ( ArticleUrl, Title, UpdateDate) ;
	END IF;
	
    
    set  ArticleIdX = ( SELECT articleId 
    FROM article_header 
    WHERE article_url = ArticleUrl );
    
    SELECT articleId 
    FROM article_header 
    WHERE article_url collate utf8_general_ci = ArticleUrl  ;
    
    
    SELECT ArticleIdX , ArticleUrl, Title, UpdateDate, PageViewCnt ;
    IF (NOT EXISTS(SELECT * FROM article_page_view_daily where articleId = ArticleId )) Then
	INSERT INTO article_page_view_daily(articleId,date_load,page_view_count) 
		VALUES(ArticleIdX, now(), PageViewCnt);
	ELSE 
		UPDATE article_page_view_daily SET page_view_count = PageViewCnt        
        WHERE articleId = ArticleIdX ;
	END IF ;
    
  
  END //
  DELIMITER ;
  
  
  
CREATE PROCEDURE article_page_view_update
(
	 ArticleUrl NVARCHAR(256),
     Title NVARCHAR(200),
     UpdateDate NVARCHAR(200),	
     PageViewCnt Int 
    )
BEGIN 
	
    DECLARE ArticleId INT ;
     
    
END //
DELIMITER ;
  
  
  
  
  DECLARE ArticleUrl NVARCHAR(200) ;  
  DECLARE Title NVARCHAR(200) ;
  DECLARE UpdateDate NVARCHAR(200) ;
  DECLARE PageViewCnt INT ;
  
  SET @ArticleUrl = 'www.baidu.com';
  SET @Title= 'Connecting Baidu.com' ;
  SET @UpdateDate= '2018-04-03';
  SET @PageViewCnt = 500 ;
  
  
   CALL article_page_view_update (@ArticleUrl,@Title,@UpdateDate,@PageViewCnt) ;
  
  
  SET @ArticleUrl = 'www.baidu.com';
  SELECT * 
  FROM article_header 
  WHERE article_url = @ArticleUrl ;
  
  SELECT ah.*, ahc.*
  FROM article_page_view_daily ahc
	INNER JOIN article_header ah on ahc.articleId = ah.articleId 
    
SELECT * 
  FROM article_header WHERE article_url = 'www.baidu.com';
  SELECT * FROM article_page_view_daily ;
  
  
  delete from  article_page_view_daily ;
 --  truncate table article_header ;
 
 ALTER TABLE article_header ADD 
 
 Alter Table article_header Add articleId Int Auto_Increment Primary Key 
 Alter Table article_header Add articleId Int Auto_Increment
 
 
 SELECT article, ROW_NUMBER() OVER (PARTITION BY article_url Order By articleId ASC) AS RN
 FROM article_header 
 
 SELECT SUM(articleId) OVER() AS SUM
 FROM article_header ;
 
 
 
 
 
 SELECT article_url,count(articleId) as articles
 FROM article_header 
 GROUP BY article_url 
 HAVING count(articleId) > 1 
 
 
SELECT * 
  FROM article_header
  
  
 
