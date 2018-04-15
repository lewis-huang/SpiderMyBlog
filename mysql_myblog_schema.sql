

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
    IF (NOT EXISTS( SELECT * FROM article_page_view_daily where articleId = ArticleIdX AND date(date_load) = date(current_date()) ) ) Then
	INSERT INTO article_page_view_daily(articleId,date_load,page_view_count) 
		VALUES(ArticleIdX, now(), PageViewCnt);
	ELSE 
		UPDATE article_page_view_daily SET page_view_count = PageViewCnt        
        WHERE articleId = ArticleIdX ;
	END IF ;
    
  
  END //
  DELIMITER ;
  
  select date(current_date())
  
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
  
  
  
   
  
  SET @ArticleUrl = 'www.baidu.com';
  SET @Title= 'Connecting Baidu.com' ;
  SET @UpdateDate= '2018-04-03';
  SET @PageViewCnt = 600 ;
  
  
   CALL article_page_view_update (@ArticleUrl,@Title,@UpdateDate,@PageViewCnt) ;
  
  
  SET @ArticleUrl = 'www.baidu.com';
  SELECT * 
  FROM article_header 
  WHERE article_url = @ArticleUrl ;
  
  
  
  SELECT 
    ah.*, ahc.*
FROM
    article_page_view_daily ahc
        INNER JOIN
    article_header ah ON ahc.articleId = ah.articleId
    where article_url = 'https://blog.csdn.net/wujiandao/article/details/6855567'
    
    
SELECT * 
  FROM article_header ;
  
 select max(articleId) from article_header ;
  
  SELECT * FROM article_page_view_daily 
  order by articleId 
  
  
  delete from  article_page_view_daily ;
  truncate table article_header ;
 
 ALTER TABLE article_header ADD 
 
 Alter Table article_header Add articleId Int Auto_Increment Primary Key 
 Alter Table article_header Add articleId Int Auto_Increment
 
 
 SELECT article, ROW_NUMBER() OVER (PARTITION BY article_url Order By articleId ASC) AS RN
 FROM article_header 
 
 SELECT SUM(articleId) OVER() AS SUM
 FROM article_header ;
 
 
 
 set session transaction isolation level read uncommitted
 
 SELECT article_url,count(articleId) as articles
 FROM article_header 
 GROUP BY article_url 
 HAVING count(articleId) > 1 
 
 
SELECT * 
  FROM article_header
  
  
  
SELECT  ARH.article_url, ARH.title, ARH.update_date,  DPV.date_load, DPV.page_view_count 
FROM article_header ARH 
	INNER JOIN article_page_view_daily DPV ON ARH.articleId = DPV.articleId
WHERE page_view_count > 1000 and article_url like '%wujiandao%'   
ORDER BY DPV.page_view_count DESC     
LIMIT 100   




SET @BeginDate = Date(Current_Date()) 
SELECT  Date_Add(Date(Current_Date()) , Interval  -10 DAY) 

SELECT Date_Add('2018-02-01', Interval 1 DAY)

SET @NUMBER_VAR = 1 
 SELECT DATE_ADD('2018-02-01', INTERVAL @NUMBER_VAR DAY)
 
 
SELECT * 
FROM article_page_view_daily


SELECT AH.title, A.*, B.* , A.page_view_count  -  B.page_view_count  AS IncrementalCount
FROM (
		SELECT articleId, DATE(date_load) AS Date_load, page_view_count 
        FROM article_page_view_daily 
        WHERE articleId in (SELECT articleId from article_header WHERE article_url like '%wujiandao%' )
			AND DATE(date_load) = '2018-04-15' 
) A 
	LEFT JOIN (
					SELECT articleId, DATE(date_load) AS Date_load, page_view_count 
					FROM article_page_view_daily 
					WHERE articleId in (SELECT articleId from article_header WHERE article_url like '%wujiandao%' )
						AND DATE(date_load) = '2018-04-05' 
				) B
	ON A.articleId = B.articleId 
    
    INNER JOIN article_header AH ON AH.articleId = A.articleId
ORDER BY     
    IncrementalCount DESC





 
