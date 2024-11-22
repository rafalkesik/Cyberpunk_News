User.create([{ username:              "Admin User",
               password:              "foobar123",
               password_confirmation: "foobar123",
               admin:                 true         }])
               
Post.create([{ title:   "Kontrowersyjny nominat Trumpa rezygnuje",
               content: "No nieźle, co?",
               link:    "https://tvn24.pl/swiat/usa-matt-gaetz-kontrowersyjny-republikanin-wycofuje-sie-z-nominacji-donalda-trumpa-na-prokuratura-generalnego-st8190689",
               user_id: 1 }])
Post.create([{ title:   "Radosław Sikorski zamówił i a zaniemówił",
               content: "Zamówił sondaz podobno.",
               link:    "https://wiadomosci.onet.pl/tylko-w-onecie/radoslaw-sikorski-zamowil-prezydencki-sondaz-w-anglii-ujawniamy-wyniki/sq9x2sq?utm_campaign=cb",
               user_id: 1 }])
Post.create([{ title:   "Powitanie",
               content: "Dzień dobry, jestem tu nowy. Pochodzę z Dąbrowy Górniczej. A wy?",
               link:    "",
               user_id: 1 }])
Post.create([{ title:   "Upcoming Hardening in PHP",
               content: "",
               link:    "https://news.ycombinator.com/item?id=42063617",
               user_id: 1 }])
