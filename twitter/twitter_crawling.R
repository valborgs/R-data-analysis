# Date: 2019.05.12
# Author: Minsic Eom
# Project: twitter keyword crawling, text mining, visualization

# 트위터 크롤링, 텍스트마이닝, 시각화를 위한 패키지 설치
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

# OAuth공개인증을 위한 트위터 앱 키와 토큰
consumer_key <- ""
consumer_secret <- ""

access_token <- ""
access_secret <- ""

# 트위터 OAuth공개인증 설정
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

# 검색 키워드 설정
keyword <- enc2utf8("")

# 설정한 키워드로 트위터로부터 데이터 크롤링을 하여 변수에 저장
tData <- searchTwitter(keyword, n=500, lang="ko")

# 크롤링된 데이터를 담은 변수를 데이터 프레임으로 변환
tData.df <- twListToDF(tData)

# 크롤링 된 데이터를 텍스트 파일로 저장
write(tData.df$text, "tData.txt")

# 텍스트 파일을 한줄씩 읽어들여 변수에 저장
twitterPosts <- readLines("tData.txt")

# 데이터에서 명사만을 추출
twitterWords <- sapply(twitterPosts,extractNoun,USE.NAMES=F)

# 추출된 데이터에서 점, 숫자, 빈공간, 그 외의 불필요한 단어들을 제거 시킴
interest<-gsub("[[:punct:][:digit:][:space:]]", "", unlist(twitterWords))
interest<-gsub("https", "", unlist(interest))
interest<-gsub("@", "", unlist(interest))

# 정제된 텍스트 데이터를 텍스트 파일로 저장
write(interest, "twinterest.txt")

# 단어 길이가 3개 보다 큰 단어만 분류
interest <- Filter(function(x) {nchar(x) > 3}, interest)

# 데이터 빈도 분석
word_count <- table(interest)
# 빈도수 상위 30개 출력
head(sort(word_count, decreasing = T), 30)
# 분석 결과 텍스트 파일로 저장
write(word_count, "wordcount.txt")

# 최소 빈도수 5 이상인 단어들을 워드클라우드로 시각화
palette <- brewer.pal(8, "Set2")
wordcloud(names(word_count), freq=word_count, rot.per = 0.25, min.freq = 5, 
          random.order = F, random.color = T, colors=palette)
