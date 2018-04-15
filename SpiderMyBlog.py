# coding:utf-8

import requests
import re
import mysql.connector
from urllib import parse
from bs4 import BeautifulSoup
from mysql.connector import errorcode, Error

class UrlManager(object):
    def __init__(self):
        self.new_urls = set()# 未爬取 URL 集合
        self.old_urls = set()# 已爬取 URL 集合

    def has_new_url(self):
        '''
        判断是否有未爬取的 URL
        :return:
        '''
        return self.new_url_size() !=0

    def get_new_url(self):
        '''
        获取一个未爬取的 URL
        :return:
        '''
        new_url = self.new_urls.pop()
        self.old_urls.add(new_url)
        return new_url

    def add_new_url(self,url):
        '''
        将新的 URL 添加到未爬取的 URL 集合中
        :param url:
        :return:
        '''
        if url is None:
            return
        if url not in self.new_urls and url not in self.old_urls:
            self.new_urls.add(url)

    def add_new_urls(self,urls):
        '''
        将新的 URL 添加到未爬取的 URL 集合中
        :param urls: url 集合
        :return:
        '''

        if urls is None or len(urls) ==0:
            return
        for url in urls:
            self.add_new_url(url)

    def new_url_size(self):
        '''
        获取未爬取 URL 集合的大小
        :return:
        '''
        return len(self.new_urls)

    def old_url_size(self):
        '''
        获取已经爬取 URL 集合的大小
        :return:
        '''
        return len(self.old_urls)



# coding:utf-8


class HtmlDownloader(object):
    def download(self, url: object) -> object:
        if url is None:
            return None
        user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT'
        headers = {'User-Agent':user_agent}
        r = requests.get(url,headers=headers,timeout = 10 )

        if r.status_code == 200 :
            r.encoding = 'utf-8'

            return r.text
        return None



class HtmlParser(object):

        def parser(self,page_url,html_cont):
            '''
            用于解析网页内容，抽取 URL 和 数据
            :param page_url: 下载页面的 URL
            :param html_cont: 下载的网页内容
            :return: 返回 URL 和数据
            '''

            if page_url is None or html_cont is None:
                return
            soup = BeautifulSoup(html_cont,'html.parser')
            new_urls=self._get_new_urls(page_url,soup)

            new_datas = []
            for urli in new_urls :
                new_data=self._get_new_data(urli,soup)
                new_datas.append(new_data)
            return new_urls,new_datas

        def _get_new_urls(self,page_url,soup):
            '''
            抽取新的 URL 集合
            :param page_url:下载页面的 URL
            :param soup: soup
            :return: 返回新的 URL 集合
            '''
            new_urls = set()
            # 抽取符合要求的  a 标记
            links = soup.find_all('a',href=re.compile('https://blog.csdn.net/wujiandao/article/details/[0-9]*'))
            for link in links:
                # 提取 href 属性
                new_url = link['href']
                # 拼接成完整网址

                new_urls.add(new_url)
               # print(new_url)
            return new_urls

        def _get_new_data(self,page_url,soup):
            '''
            抽取有效数据
            :param page_url: 下载页面的 URL
            :param soup:
            :return: 返回有效数据
            '''

            data = {}

            try:
                Htmldownloader = HtmlDownloader()
            except Error as e:
                print(e)

            data['article_url'] = page_url
            html =  Htmldownloader.download(page_url)
            ind_soup = BeautifulSoup(html, 'html.parser')
            title = ind_soup.find_all("h1",class_="csdn_top")
            data['title']=title[0].string
            updated = ind_soup.find_all("span",class_="time")
            data['update_date'] = updated[0].string
            pageview = ind_soup.find_all("span",class_="txt")
            data['pageviewcnt']= pageview[0].string
            print(data)
            return data

# coding:utf-8
import codecs

class DataOutput(object):

    def __init__(self):
        self.datas=[]
        self.cnx = mysql.connector.connect(user='huangyun',password='huangyun',host='192.168.51.101',database='pythondb')
        self.cursor = self.cnx.cursor()
    def store_data(self,data):
        if data is None:
            return
        for data_shard in data:
            args = [ str(data_shard["article_url"]),str(data_shard["title"]),str(data_shard["update_date"]),int(str(data_shard["pageviewcnt"]))]
            procname = "article_page_view_update"
            try:
                return_reset = self.cursor.callproc(procname,args)
            #add_content =  " insert into article_header(article_url,title,update_date) values('%s','%s','%s' )" % (data_shard["article_url"],data_shard["title"],data_shard["update_date"])
            #(%(article_url)s, %(article_title)s, %(article_update_date)s )
            # {"article_url":data_shard["article_url"],"article_title":data_shard["title"],"article_update_date":data_shard["update_date"]}
            # content = (data_shard["article_url"],data_shard["title"],data_shard["update_date"])
            #self.cursor.execute(add_content )

            except Error as e:
                print(e)
            finally:
                self.cnx.commit()

    def output_html(self):
        fout = codecs.open('baike.html','w')
        fout.write("<html>")
        fout.write("<body>")
        fout.write("<table>")
        for data in self.datas:
            fout.write("<tr>")
            fout.write("<td>%s</td>"%data['url'])
            fout.write("<td>%s</td>" %data['title'])
            fout.write("<td>%s</td>" %data['summary'])
            fout.write("</tr>")
            self.datas.remove(data)
        fout.write("</table>")
        fout.write("</body>")
        fout.write("</html>")
        fout.close()


class SpiderMan(object):
    def __init__(self):
        self.manager = UrlManager()
        self.downloader = HtmlDownloader()
        self.parser = HtmlParser()
        self.output = DataOutput()

    def crawl(self,root_url):
        # 添加入口 URL
        self.manager.add_new_url(root_url)
        for i in range(2,80):
            url_to_be_download = "https://blog.csdn.net/wujiandao/article/list/" + str(i)
            self.manager.add_new_url(url_to_be_download)
        # 判断 URL 管理器中是否有新的 url, 同时判断抓取了多少个 URL
        while(self.manager.has_new_url()):
            try:
                # 从 URL 管理器获取新的 URL
                new_url = self.manager.get_new_url()
                # 从 HTML 下载器下载网页
                html = self.downloader.download(new_url)
                # HTML 解析器抽取网页数据
                new_urls,datas = self.parser.parser(new_url,html)
                # 将抽取的 URL 添加到 URL 管理器中
                # self.manager.add_new_urls(new_urls)
                # 数据存储器存储文件
                self.output.store_data(datas)
                message = "已经抓取 {s} 个链接".format(s= self.manager.old_url_size())
                print(message)
            except Exception:
                print("failed to get content")
                print ( errorcode)


       # self.output.output_html()


if __name__ =="__main__":
    spider_man=SpiderMan()
    spider_man.crawl("https://blog.csdn.net/wujiandao/article/list")

