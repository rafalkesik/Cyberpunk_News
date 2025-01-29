# Defining sample data
sample_categories = [
  { id: 2, title: 'Polityka', slug: 'polityka', description: 'Polska polityka i nie tylko.' },
  { id: 3, title: 'Programming', slug: 'programming', description: 'Programming questions, news posts.' }
]

sample_posts = [
  { id: 1,
    title: 'Kontrowersyjny nominat Trumpa rezygnuje',
    content: 'Nieźle, co?',
    link: 'https://tvn24.pl/swiat/usa-matt-gaetz-kontrowersyjny-republikanin-wycofuje-sie-z-nominacji-donalda-trumpa-na-prokuratura-generalnego-st8190689',
    user_id: 1,
    category_id: 2 },
  { id: 2,
    title: 'Radosław Sikorski zamówił i a zaniemówił',
    content: 'Zamówił sondaz podobno.',
    link: 'https://wiadomosci.onet.pl/tylko-w-onecie/radoslaw-sikorski-zamowil-prezydencki-sondaz-w-anglii-ujawniamy-wyniki/sq9x2sq?utm_campaign=cb',
    user_id: 1,
    category_id: 2 },
  { id: 3,
    title: 'Powitanie',
    content: 'Dzień dobry, jestem tu nowy. Pochodzę z Dąbrowy Górniczej. A wy?',
    link: '',
    user_id: 1,
    category_id: 1 },
  { id: 4,
    title: 'Upcoming Hardening in PHP',
    content: '',
    link: 'https://news.ycombinator.com/item?id=42063617',
    user_id: 1,
    category_id: 3 }
]

sample_comments = [
  { id: 1, post_id: 4, user_id: 1, content: 'Shoot man, I hate PHP. I should move into Rails' },
  { id: 2, post_id: 4, user_id: 1, content: 'Yeah, you should man!', parent_id: 1 }
]

# Seeding data for every env
User.find_or_create_by!(username: 'Admin User') do |user|
  user.password = 'foobar123'
  user.password_confirmation = 'foobar123'
  user.admin = true
end

Category.find_or_create_by!(id: 1,
                            slug: 'inne',
                            title: 'Inne',
                            description: 'Posty niepasujące do żadnej kategorii.')

# Seeding data for dev & test env
if Rails.env.development? || Rails.env.test?
  sample_categories.each do |category|
    Category.find_or_create_by!(category)
  end
  sample_posts.each do |post|
    Post.find_or_create_by!(post)
  end
  sample_comments.each do |comment|
    Comment.find_or_create_by!(comment)
  end

  puts 'Sample data loaded for development or test'
else
  puts 'Production seed data checked & created if missing'
end
