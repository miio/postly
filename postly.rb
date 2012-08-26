# -*- encoding: utf-8 -*-
#!/usr/env/ruby
require "twitter"
require "readline"
require "pp"
require "term/ansicolor"
require "./postly_config.rb"
include Term::ANSIColor
print magenta,"-------------------login now...------------------" + "\n" + reset

#gem,インデント,その他諸々なんてなかったんや...なかったんや...

puts "gemとかインデントなんてなかったんや"
print yellow,"-------------------------------------------------" + "\n" + reset
sleep 2
system("clear")
#Twitterユーザーデータ格納とか、初期定義しておきたいじゃん
username = Twitter.user.screen_name

loop do
  #ポスト入力開始
  #常時表示しておきたい部分
  #ポスト待ってくれ...!!!
  print yellow,"-------------------------------------------------" + "\n" + reset
  print   cyan,"---------------Command or Post Here--------------" + "\n" + reset
  print yellow,"  [:h]HELP   [:q/:kisei/:health/:reply]Command   " + "\n" + reset
  print yellow,"-------------------------------------------------" + "\n" + reset
  #ツイート処理
  begin
    #ポスト入力待ち
    akari = Readline.readline("> ",true)
    #共通処理(終了優先) 
    if akari == ":q" then
      exit()
    elsif akari ==":clear"
      system ("clear")
      #ブランクツイートエラー処理
    elsif akari == ""
      system("clear")
      print red,"-------------------Tweet Failed!-----------------" + "\n" + reset
      print blue,"------------------Error Details------------------" + "\n" + reset
      puts "Twitter not supported blank tweet."
      print yellow,"-------------------------------------------------" + "\n" + reset   
      #ヘルプ処理
    elsif akari == ":h"
      system("clear")
      puts "***************** Postly comannds ***************"
      puts "[:health] API health check"
      puts "[:reply] Reply (Require Reply-to-tweet-id)"
      puts "[:kisei] 規制されてるんだがぁ〜〜〜？"
      puts "[:q] exit of postly."
      #規制占い処理
    elsif akari == ":kisei" then
      system("clear")
      uranaikisei = ["勉強しろ", "休もう", "高校落ちるぞ", "垢消せ"]
      print red,"規制されているあなたへ ↓" + "\n"
      print reset
      print magenta,uranaikisei.sample + "\n"
      print reset
    elsif akari == ":clear" then
      system ("")
      #リプライ処理
    elsif akari == ":reply" then
      begin
        system("clear")
        repid = Readline.readline("Reply to Tweet ID> ",true)
        akarin = Readline.readline("Tweet > ",true)
        Twitter.update(akarin, :in_reply_to_status_id =>repid)
      rescue => errorrep
        #ツイート失敗
        print red,"------------------Tweet Failed!----------------" + "\n" + reset
        puts "Sorry, not posted " + '"' + akarin + '"'
        print reset
        #エラー詳細
        print blue,"-----------------Error Details------------------" + "\n"
        print reset
        puts errorrep
      else
        #ポスト処理
        print magenta,"-------------------post now...------------------" + "\n" + reset
        #ツイート成功
        print green,"-----------------Tweet Successful----------------" + "\n"
        print reset
        print "Posted on Twitter " + '"' + akarin + '"' +  "\n"
      end
      #規制チェッカ処理
    elsif akari == ":health" then
      system("clear")
      apilimit = Twitter.rate_limit_status.remaining_hits.to_i
      print cyan,"--------------------API Health-------------------" + "\n"
      print reset
      #API制限判定+表示
      if apilimit < 50 then
        print red,underscore,"DANGER" + "\n" + reset
        print "残り" + apilimit.to_s + "回です。" + "\n"
        print "規制される可能性があります。" + "\n"
      elsif apilimit < 150 then
        print yellow,underscore,"ATTENTION" + "\n" + reset
        print "残り" + apilimit.to_s + "回です。" + "\n"
        print "API制限には若干余裕があります。今後の投稿にご注意ください。" + "\n"
      elsif apilimit < 350 then
        print green,underscore,"HEALTHY" + "\n" + reset
        print "残り" + apilimit.to_s + "回です。" + "\n"
        print "API制限には余裕があります。" + "\n"
      else
        print "API回数のチェックに失敗しました。"
        print "API残回数:" + apilimit.to_s + "\n"
      end
      #ポスト処理
    else
      system("clear")
      print magenta,"-------------------post now...------------------" + "\n" + reset
      #文字数チェック
      longakari = akari.length
      nokoriakari = longakari - 140
      if longakari < 140 then
        Twitter.update(akari)
        print reset
        #文字数超過パス
        print green,"-----------------Tweet Successful----------------" + "\n"
        print reset
        print "Posted on Twitter " + '"' + akari + '"' +  "\n"
        #文字数超過エラー
      else
        print red,"------------------Tweet Failed!----------------" + "\n"
        print reset
        print yellow,"-You Tweet is longer--------" + " -" + nokoriakari.to_s + " ---- " + longakari.to_s + " " + "------" "\n"
        print reset
      end
    end
  rescue => errorz
    #ツイート失敗
    print red,"------------------Tweet Failed!----------------" + "\n" + reset
    puts "Sorry, not posted " + '"' + akari + '"'
    print reset
    #エラー詳細
    print blue,"-----------------Error Details------------------" + "\n"
    print reset
    puts errorz
  end
end
#最終終了処理(いらない)
print reset
puts cyan,"----------------------------------------------" 
print reset
