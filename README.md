# wrdoclet-solr-docker

solr docker image for wrdoclet (https://github.com/WinRoad-NET/wrdoclet) 

在构建docker image之前请先下载solr-4.7.1.tgz (http://archive.apache.org/dist/lucene/solr/4.7.1/solr-4.7.1.tgz)到本地，构建docker image需要用到该文件。

docker image 包含了solr, 问道前端页面 以及 python2.7
本地docdata目录会挂载到docker的/usr/share/wrdocletdocdata/目录，可以把生成的文档放到该目录中。随后通过solrPublish.py发布到问道。

假设docker宿主机IP是47.98.229.120，宿主机的8080端口映射到docker的8080端口

那么可以通过 http://47.98.229.120:8080/wrdoclethostsite/ 访问问道前端页面

发布接口文档的方法：
- 进入容器
```
docker exec -i -t wrdoclet /bin/bash
```
- 执行发布 （其中'2018.02.13 23:19:37'为生成文档时的buildid)
```
python2.7 /usr/local/solrPublish.py -i "/usr/share/wrdocletdocdata/wrdoclet-gh-pages/apidocs-demosite/" -s http://47.98.229.120:8080/solr/apidocs -b '2018.02.13 23:19:37'
```
