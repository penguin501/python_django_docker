
# Docker版テスト環境構築手順

## 必須アプリ(winもmacも)
・docker  
・docker-compose  
・お好きなエディタ  

## 組み立て方
1. 初めからプロジェクトを作る場合は下にあるオリジナル手順を実施（英語）
2. CRMのgit(develop)からworkdir内にcloneする(treeの通り)
3. build/nginx/site-enabled/djangoのstaticを修正する
4. docker-composeファイルがあるディレクトリで下記のコマンドを実施

```
$ docker-compose build
$ docker-compose up -d
```

5. ブラウザより 0.0.0.0:8000 にアクセス

## 追加説明
docker-composeとdockerfileによってボリュームを切っているので  
移動させる場合は適宜変更すること  

## デバックについて
sshが必要、DockerFileにapt-getでopen-ssh-serverを入れる記述を追加  
docker-compoesにportを開ける 3000:22 (ホスト:コンテナ)  

またローカルライブラリーも合わせる必要があるので、仮想環境が望ましい  
（djangoやDB系のライブラリが必要)  
  

original git
https://github.com/pedroresende/docker-django

## DB設定
workdir配下のdjangoプロジェクトのsetting.pyにDB設定項目があり、  
その値をmysqlに登録する  
  
コンテナを起動した後
```
docker exec -it <コンテナ名> mysql -uroot -p
```
  
CRMがアクセスするユーザを作成する  
crmdev  
```
CREATE USER 'crmdev'@'%' IDENTIFIED BY 'crmdev';
GRANT ALL ON djangocrmtest.* TO 'crmdev'@'%' IDENTIFIED BY 'crmdev';
FLUSH PRIVILEGES;
```
  
ログインを確認する  
```
docker exec -it <コンテナ名> mysql -ucrmdev -p
```

pythonコンテナよりmigrateを実行する  
```
docker exec -it <コンテナ名> python manage.py migrate
```

## static設定
nginxディレクトリ配下のdjangoファイルにaliasとして稼動時に存在するstaticパスを入れる
adminは同時に登録できない？（aliasを複数切れない）