User.create([{ username:              "Admin User",
               password:              "foobar123",
               password_confirmation: "foobar123",
               admin:                 true         }])
               
Category.create([{ id: 1,
                   title: "Polityka",
                   description: "Polska polityka i nie tylko." }])
Category.create([{ id: 2,
                   title: "Programming",
                   description: "Programming questions, news posts." }])

Post.create([{ id: 1,
               title:   "Kontrowersyjny nominat Trumpa rezygnuje",
               content: "Nieźle, co?",
               link:    "https://tvn24.pl/swiat/usa-matt-gaetz-kontrowersyjny-republikanin-wycofuje-sie-z-nominacji-donalda-trumpa-na-prokuratura-generalnego-st8190689",
               user_id: 1,
               category_id: 1 }])
Post.create([{ id: 2,
               title:   "Radosław Sikorski zamówił i a zaniemówił",
               content: "Zamówił sondaz podobno.",
               link:    "https://wiadomosci.onet.pl/tylko-w-onecie/radoslaw-sikorski-zamowil-prezydencki-sondaz-w-anglii-ujawniamy-wyniki/sq9x2sq?utm_campaign=cb",
               user_id: 1,
               category_id: 1 }])
Post.create([{ id: 3,
               title:   "Powitanie",
               content: "Dzień dobry, jestem tu nowy. Pochodzę z Dąbrowy Górniczej. A wy?",
               link:    "",
               user_id: 1 }])
Post.create([{ id: 4,
               title:   "Upcoming Hardening in PHP",
               content: "",
               link:    "https://news.ycombinator.com/item?id=42063617",
               user_id: 1,
               category_id: 2 }])

Comment.create([{ id: 1,
                  post_id: 4,
                  user_id: 1,
                  content: "Shoot man, I hate PHP. I should move into Rails" }])
Comment.create([{ id: 2,
                  post_id: 4,
                  user_id: 1,
                  content: "Yeah, you should man!",
                  parent_id: 1 }])
