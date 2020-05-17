DEFAULT_INTRODUCTION = "はじめまして。よろしくお願いします。"
INTRODUCTIONS = [
  "まだまだ下手くそですが迷惑だけはかけないように練習中です！\nよろしくお願いします",
  "楽しくゴルフしたいです！",
  "楽しくラウンドを出来る方募集です＾＾\nお酒も好きなので、ゴルフ終わりのいっぱいとかご一緒したいですね！",
  "平日、ラウンド出来る方よろしくお願いします。",
  "単純にラウンドできるかたがいたらよろしくお願いします。",
  "ゴルフシーズン到来！ 気軽に楽しくラウンドしたいですね",
  "楽しいゴルフがしたいです！よろしくお願いします。",
  "数年ぶりに再開します^_^ お誘いお待ちしてます",
  "ご迷惑をお掛けしないように猛ダッシュするので暖かい目でお願いします^_^\nラウンド中は楽しくワイワイしたい派です",
  "ゴルフはするのも見るのも大好きです。よろしくお願いします。",
  "明るく楽しくラウンド⛳️できる方なら大歓迎です。腕前は問いません。",
  "男女一緒にエンジョイ出来ればなと思ってます。",
  "一緒にラウンドできる方を探してます。宜しくお願い致します。\n女性の方だと尚更嬉しいです！",
  "コースに行きたいのですが1人では不安なのでゴルフ仲間が欲しいです。",
  "一緒に楽しく回れる方と仲良くなりたいです！ よろしくお願いします。",
  "楽しくゴルフがしたいです。宜しくお願い致します。",
  "はじめまして！ ゴルフ仲間が欲しくて登録しました！",
  "上達を目指して集中的にラウンドしませんか？",
  "まだまだ、下手ですが一緒に練習したりラウンドできる同性のゴルファーさんがいればいいな〜と思っています。",
  "練習しなくっちゃ。",
  "最近ようやくドライバーがまっすぐ飛ぶようになりました",
  "もう少し回数をラウンドしたくて女子の方とゴルフ友達になりたくて登録しました。明るくラウンドしたいです",
  "ゴルフ仲間が減ってしまい一緒にラウンド行ったり、打ちっ放しいったり、帰りに飲みに行ける人が同世代で欲しいです！ ",
  "ゴルフがめっちゃ大好きで、毎週末行きたいのですが、そんなに仲間がいないので。 スコアは波があります。",
  "ゴルフ大好きです 下手くそですが、よろしくお願いします！",
  "気軽なゴルフ仲間が欲しいと思っています。",
  "回数重ねて上達したいと思っております。\nぜひ仲良くしてください。",
  "楽しくゴルフ出来る友達を作りたいです。",
  "フットワーク軽いので、ゴルフ出来るなら年中何処でも参上します。",
  "月１ゴルファーです。 下手ですが宜しくお願い致します。",
  "最近ゴルフにはまってます。一緒に言ってくれるかた募集です。",
  "うまくありませんが、ゴルフにハマっております。楽しくゴルフをしたいです。",
  "平日に楽しくゴルフに行ける方…是非ご一緒出来たら嬉しいです。宜しくお願いします。",
  "なるべく安く楽しいゴルフをしたいです。",
  "ワイワイやりましょう(^^)",
  "楽しくやりつつも真剣にラウンド出来たらいいなぁ〜なんて思ってます^o^\n実力もまだまだですが仲間と日々奮闘中ですw\nこんな感じですが是非宜しくお願いします！",
  "まだまだ下手ですが楽しくラウンドできる仲間が欲しいです。",
  "あまり上手くありませんが、楽しいラウンドを心がけています。\nご一緒する機会がありましたら、宜しくお願いします。",
  "ゴルフは楽しくがモットーです♪ スコアは後からついてくる！はず... 宜しくお願いいたします。",
  "楽しいゴルフができれば嬉しいです。 よろしくお願いしますっ！",
  "ゴルフ大好きです。気配りができる楽しいプレーを心掛けています。",
  "楽しければそれでよしゴルフです、雨は苦手です！",
  "週末に楽しくラウンドできればと。",
  "２か月に1回ぐらいプレー 車なし、電車とクラブバスで現地に",
  "平日回れる友人がいないので、平日回れる人がいたらうれしいです。スコアは100くらいです。 よろしくお願いします。",
  "新しい方々との出会いを楽しみたいと思います。 ",
  "平日に一緒にラウンドや練習が行けて、楽しく出来る友だちを探してます。",
  "楽しくゴルフを出来る友達を探してます。",
  "楽しくラウンドがモットーです。",
  "ラウンド仲間が出来ればと思ってます(^^) "
]

# guest user
User.create!(
  username: "ゲスト",
  email: "guest@example.com",
  password:              "guestpassword",
  password_confirmation: "guestpassword",
  confirmed_at: Time.zone.now,
  confirmation_sent_at: Time.zone.now,
  guest: true,
  introduction: DEFAULT_INTRODUCTION
)

BIRTHDAY_START = Date.parse("1950/01/01")
BIRTHDAY_END = Date.parse("2000/12/31")
# general user
50.times do |n|
  username = Faker::Japanese::Name.last_name
  email = "sample#{n+1}@example.com"
  password = "password"
  sex = rand(0..2)
  birth_date = Random.rand(BIRTHDAY_START .. BIRTHDAY_END)
  prefecture_id = rand(1..47)
  introduction = INTRODUCTIONS.fetch(n, DEFAULT_INTRODUCTION).gsub(/(\\r\\n|\\r|\\n)/, "\n")
  play_type = rand(1..3)
  if (play_type == 3)
    average_score = rand(5..6)
  else
    average_score = rand(1..6)
  end
  User.create!(
    username: username,
    email: email,
    password: password,
    password_confirmation: password,
    confirmed_at: Time.zone.now,
    confirmation_sent_at: Time.zone.now,
    sex: sex,
    birth_date: birth_date,
    prefecture_id: prefecture_id,
    introduction: introduction,
    play_type: play_type,
    average_score: average_score
  )
end

users = User.all

users.each_with_index do |user, n|
  if n.between?(1, 40)
    user.avatar = open("#{Rails.root}/db/fixtures/avatar-#{n}.png")
    user.save
  end

  # relationship,notification
  if n < users.count - 1
    min_follow = n + 1
    max_follow = rand((n+2)..users.count)
    following = users[min_follow..max_follow]
    max_follow = rand((n+2)..users.count)
    followers = users[min_follow..max_follow]
    following.each do |followed|
      user.follow(followed)
      followed.create_notification_follow!(user)
    end
    followers.each do |follower|
      follower.follow(user)
      user.create_notification_follow!(follower)
    end
  end
end


# guest user events
event_date = Date.parse("2020/06/06")
guest_user_events = [
  {
    title: "男女一緒にエンジョイ出来ればなと思ってます。",
    content: "丘陵地の趣を加えたレイアウトでアップダウン少なく、女性、シニア、ビギナーでも" +
              "気軽にラウンド可能です。",
    event_date: event_date += 7
  },
  {
    title: "一緒にラウンドできる方を探してます。",
    content: "西コースをお得に回ります。",
    event_date: event_date += 7
  },
  {
    title: "いろいろな方とご一緒したいです。",
    content: "雨中止無です。",
    event_date: event_date += 7
  },
  {
    title: "一緒に楽しく回れる方と仲良くなりたいです！",
    content: "大自然に囲まれたコース。丘陵地の趣を加えたレイアウトでアップダウン少なく、" +
              "女性、シニア、ビギナーでも気軽にラウンド可能です。",
    event_date: event_date += 7
  },
  {
    title: "楽しくゴルフがしたいです。宜しくお願い致します。",
    content: "メンバーの紹介がないと行けないゴルフ場で、しかもサークル特別プランにしていただきました。",
    event_date: event_date += 7
  },
  {
    title: "ゴルフエンジョイしませんか(^^) ",
    content: "この機会に、お知り合いと参加してください。組利用の方も大歓迎です。",
    event_date: event_date += 7
  },
  {
    title: "雨なら中止になります。",
    content: "スループレイ枠ですのでスタート時間が移動できませんので遅刻は厳禁です。",
    event_date: event_date += 7
  },
  {
    title: "ゴルフ仲間を増やしたいと思っています。",
    content: "参加（満席の場合はキャンセル待ち）をご希望の方は、コメント欄に書き込みをお願いします",
    event_date: event_date += 7
  },
  {
    title: "色々な事を教えて頂けたら嬉しいなと思ってます！",
    content: "午前中スループレイになっております。涼しい時間にまわりましょう。",
    event_date: event_date += 7
  },
  {
    title: "楽しいゴルフがしたいです！よろしくお願いします。",
    content: "丘陵コース。この地域にはめずらしいほどのフラットさで、高低差のあるホールは" +
              "７番ホールのみ、クラブハウスからコースの３分の２が展望でき、ブラインドホールも" +
              "たった３ホールしかありません。\nレギュラーティから初級者でも緊張を強いられる" +
              "こともなくプレーできます。",
    event_date: event_date += 7
  }
]
IMAGE_DOWNLOAD_PATH = "#{Rails.root}/db/fixtures/"
courses = RakutenWebService::Gora::Course.search(keyword: "ゴルフ")
courses.each_with_index do |course, n|
  if guest_user_events.length > n
    guest_user_events[n][:course_id] = course['golfCourseId']
    guest_user_events[n][:place] = course['golfCourseAbbr']
    guest_user_events[n][:address] = course['address']
  else
    break
  end
end

guest_user = User.find_by(guest: true)
guest_user_events.each_with_index do |event, n|
  title = event[:title]
  content = event[:content].gsub(/(\\r\\n|\\r|\\n)/, "\n")
  image = "#{Rails.root}/db/fixtures/event-#{n+1}.png"
  course_id = event[:course_id]
  place = event[:place]
  address = event[:address]
  event_date = event[:event_date]
  start_time = Time.local(event_date.year, event_date.mon, event_date.mday, rand(6..9), 0, 0, 0)
  end_time = Time.local(event_date.year, event_date.mon, event_date.mday, rand(15..17), 0, 0, 0)
  maximum_participants = 4 * rand(1..5)
  guest_user.events.create!(
    title: title,
    content: content,
    image: open(image),
    course_id: course_id,
    place: place,
    address: address,
    event_date: event_date,
    start_time: start_time,
    end_time: end_time,
    maximum_participants: maximum_participants
  )
end

# general user events
general_user_events = [
  {
    title: "上達を目指して集中的にラウンドしませんか？",
    content: "セルフプレー昼飯付き¥13500にて募集中です。ぜひ参加してください。"
  },
  {
    title: "楽しくゴルフしたいです！",
    content: "ぜひ参加してください。"
  },
  {
    title: "ゴルフ終わりの一杯とかご一緒したいですね！",
    content: "スループレー\n￥10000\n風呂なし\n通常￥18000以上します。"
  },
  { 
    title: "ハーフオープンコンぺ！",
    content: "ハーフオープンコンぺ！良いスコアが出やすいINスタート(^ ^)v\n" +
              "でも、Wぺリアだからその行方は神のみぞ知る・・・"
  },
  {
    title: "誰でも参加",
    content: "ビジターは６０００円程度\n2B割増無し\n誰でも参加できます"
  },
  {
    title: "ゴルフシーズン到来！気軽に楽しくラウンドを！",
    content: "ビジターは６８００円程度\n２Ｂ割増無"
  },
  {
    title: "ご都合のよろしい皆様の参加をお待ちしております。",
    content: "池が随所に配され、フェアウェイが池に向かって傾斜しているので少しでも曲げると危険。" +
              "また、フェアウェイの微妙な起伏も曲者。ライの変化に神経を使わないと予期せぬミスが" +
              "出るコースだ。バンカーは大きく、かなり目につく。ショット自体は難しくないが心理的" +
              "プレッシャーに注意。"
  },
  {
    title: "楽しくワイワイ！",
    content: "ＩＣから３分、集合場所から１時間内の好アクセス、早めに帰宅出来ます。" +
              "アウトコースはのびのびと、インコースは緻密なプレーを心掛けたコース攻略が" +
              "楽しみ、快適な一日をお過ごしください。"
  },
  {
    title: "一緒に楽しくラウンドしましょう！",
    content: "ビジターは５０００円程度\n２Ｂ割増無"
  },
  {
    title: "明るく楽しくラウンド⛳️できる方なら大歓迎です。",
    content: "初ラウンドの方もお気軽にどうぞ。また、ご家族、ご友人の方とご一緒での参加も" +
              "歓迎いたします。"
  },
  {
    title: "楽しくラウンドしたいです。",
    content: "時間に余裕をもってお家を出てください。"
  },
  {
    title: "ゴルフ仲間を増やしたいと思っています。",
    content: "車持ちなのでピックアップ可能です。"
  },
  {
    title: "様々な方と仲良くなりたいなと思ってます✨",
    content: "丘陵コース。この地域にはめずらしいほどのフラットさで、高低差のあるホールは" +
              "７番ホールのみ、クラブハウスからコースの３分の２が展望でき、ブラインドホールも" +
              "たった３ホールしかありません。\nレギュラーティから初級者でも緊張を強いられる" +
              "こともなくプレーできます。"
  },
  {
    title: "一緒に回ってくれる方募集してます",
    content: "楽しくプレーがモットーです！ "
  },
  {
    title: "ご一緒して頂けたら嬉しいです！",
    content: "ラウンド経験を増やしたいのでよろしくお願いします！"
  },
  {
    title: "初心者でも一緒にして頂ける方ならどなたでもお待ちしてます。",
    content: "幅広い年代と交流したい。ピックアップは他の人に合わせます。"
  },
  {
    title: "一緒にラウンドしてください。",
    content: "同年代前後で楽しくプレーがしたいです。"
  },
  {
    title: "ゴルフ友達探しています。",
    content: "なかなか休みが合う友人がいないので、一緒にゴルフを楽しくできる仲間を探しております。"
  },
  {
    title: "楽しくゴルフができるお相手探しております。",
    content: "スロープレーしない方であれば性別気にしません！\n同伴者皆が楽しめますように！"
  },
  {
    title: "ゴルフ友達を増やしたい！",
    content: "すっかりゴルフにハマってしまい、日々試行錯誤を繰り返しています。\n気軽に楽しくをモットー、よろしくお願いします！"
  }
]

EVENT_DATE_START = Date.parse("2020/06/01")
EVENT_DATE_END = Date.parse("2020/09/30")
users = User.where.not(admin: true, guest: true).take(general_user_events.length)
users.each_with_index do |user, n|
  title = general_user_events[n][:title]
  content = general_user_events[n][:content].gsub(/(\\r\\n|\\r|\\n)/, "\n")
  image = "#{Rails.root}/db/fixtures/event-#{guest_user_events.length + n + 1}.png"
  course_id = 130001
  place = "赤羽GC"
  address = "東京都北区浮間2-18-7"
  courses = RakutenWebService::Gora::Course.search(areaCode: user.prefecture_id)
  unless courses.nil?
    course = courses.first
    course_id = course['golfCourseId']
    place = course['golfCourseAbbr']
    address = course['address']
  end
  event_date = Random.rand(EVENT_DATE_START .. EVENT_DATE_END)
  start_time = Time.local(event_date.year, event_date.mon, event_date.mday, rand(6..9), 0, 0, 0)
  end_time = Time.local(event_date.year, event_date.mon, event_date.mday, rand(15..17), 0, 0, 0)
  maximum_participants = 4 * rand(1..5)
  user.events.create!(
    title: title,
    content: content,
    image: open(image),
    course_id: course_id,
    place: place,
    address: address,
    event_date: event_date,
    start_time: start_time,
    end_time: end_time,
    maximum_participants: maximum_participants
  )
end


# like,participant,comment,notification
COMMENTS = [ "参加しまーす！", "楽しみですね！", "いっぱい練習しておきます！" ]
events = Event.all
event_count = events.count - 1
events.each_with_index do |event, n|
  event.participate(event.user)
  max_user = rand(0..(event.maximum_participants - 1))
  comment_params = { content: nil, user_id: nil, event_id: nil }
  unless max_user == 0
    users = User.where.not(id: event.user.id).shuffle.take(max_user)
    users.each do |user|
      # like
      event.like(user)
      event.create_notification_like!(user)

      # participant
      event.participate(user)
      event.create_notification_participate!(user)

      # comment
      comment_params[:content] = COMMENTS[rand(0..(COMMENTS.length - 1))]
      comment_params[:user_id] = user.id
      comment_params[:event_id] = event.id
      comment = event.comments.build(comment_params)
      if comment.save
        event.create_notification_comment!(user, comment.id)
      end
    end
  end
end


# admin user
admin = User.create!(
  username: "管理者",
  email: "admin@example.com",
  password:              "adminpassword",
  password_confirmation: "adminpassword",
  confirmed_at: Time.zone.now,
  confirmation_sent_at: Time.zone.now,
  admin: true
)