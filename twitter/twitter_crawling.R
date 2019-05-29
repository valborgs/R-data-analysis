# Date: 2019.05.12
# Author: Minsic Eom
# Project: twitter keyword crawling, text mining, visualization

# Ʈ���� ũ�Ѹ�, �ؽ�Ʈ���̴�, �ð�ȭ�� ���� ��Ű�� ��ġ
install.packages('twitteR')
install.packages('httr')
install.packages("base64enc")
install.packages("curl")
install.packages("rJava")
install.packages("KoNLP")
install.packages("wordcloud")
library(twitteR)
library(httr)
library(base64enc)
library(curl)
library(rJava)
library(KoNLP)
library(wordcloud)

# OAuth���������� ���� Ʈ���� �� Ű�� ��ū
consumer_key <- ""
consumer_secret <- ""

access_token <- ""
access_secret <- ""

# Ʈ���� OAuth�������� ����
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

# �˻� Ű���� ����
keyword <- enc2utf8("")

# ������ Ű����� Ʈ���ͷκ��� ������ ũ�Ѹ��� �Ͽ� ������ ����
tData <- searchTwitter(keyword, n=500, lang="ko")

# ũ�Ѹ��� �����͸� ���� ������ ������ ���������� ��ȯ
tData.df <- twListToDF(tData)

# ũ�Ѹ� �� �����͸� �ؽ�Ʈ ���Ϸ� ����
write(tData.df$text, "tData.txt")

# �ؽ�Ʈ ������ ���پ� �о�鿩 ������ ����
twitterPosts <- readLines("tData.txt")

# �����Ϳ��� ���縸�� ����
twitterWords <- sapply(twitterPosts,extractNoun,USE.NAMES=F)

# ����� �����Ϳ��� ��, ����, �����, �� ���� ���ʿ��� �ܾ���� ���� ��Ŵ
interest<-gsub("[[:punct:][:digit:][:space:]]", "", unlist(twitterWords))
interest<-gsub("https", "", unlist(interest))
interest<-gsub("@", "", unlist(interest))

# ������ �ؽ�Ʈ �����͸� �ؽ�Ʈ ���Ϸ� ����
write(interest, "twinterest.txt")

# �ܾ� ���̰� 3�� ���� ū �ܾ �з�
interest <- Filter(function(x) {nchar(x) > 3}, interest)

# ������ �� �м�
word_count <- table(interest)
# �󵵼� ���� 30�� ���
head(sort(word_count, decreasing = T), 30)
# �м� ��� �ؽ�Ʈ ���Ϸ� ����
write(word_count, "wordcount.txt")

# �ּ� �󵵼� 5 �̻��� �ܾ���� ����Ŭ����� �ð�ȭ
palette <- brewer.pal(8, "Set2")
wordcloud(names(word_count), freq=word_count, rot.per = 0.25, min.freq = 5, 
          random.order = F, random.color = T, colors=palette)