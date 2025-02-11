Latest commit available at: https://cyberpunk-news.onrender.com.

## Description:
This project is developed entirely by Rafał Kęsik. Its goal is to create a place to find and share valuable news stories and discussions that is free of clickbaits, spam and hate. It is also a way to develop and showcase my Rails and general WebApp development skills.

## Main Goal:

Build a copy of HackerNews - https://news.ycombinator.com

## Sub Goals:

1. [X] Login / Signup
2. [X] News posts
3. [X] News Feed Homepage
4. [X] Hotwire (Turbo Streams)
5. [X] Liking
   1) [X] Post liking
   2) [X] Comment liking
6. [X] Comments
   1) [X] Basic comments
   2) [X] Subcomments
7. [X] Categories
8. [X] Configure RuboCop and clean up the code layout
9. [X] Change Minitest to Rspec
10. [X] Improve signup/login with Devise
      1) [X] Devise setup
      2) [X] Sendgrid setup for mailer
      3) [X] Deploy
      4) [ ] Ask old users to create new accounts
      5) [ ] Assign posts to new users and delete old ones in db
      6) [ ] Add unique & present validations for email
11. [ ] Refactoring all code
      1) [X] Add remaining Localisation text for PL.
      2) [X] Add localisation requirement for every test
      3) [X] Rename LikingRelations to PostLike & CommentLike
      4) [ ] Rename upvote to Like AND downvote to Unlike for consistency
      5) [X] Clean up Gemfile
      6) [ ] use only one flash methods (Devise or custom)
      7) [X] !!my_liking_relation(user) # Should become .present?
      8) [ ] check all .erb files - they are not checked by Rubocop for now.
      9) [ ] Use Devise resource_params instead of my custom params methods?
      10) [ ] Check all specs for consistency and clarity
      11) [ ] Change 'login_as' into 'sign_in' (Devise). Same for logout, signup.
      12) [ ] Check for other devise paths inconcistencies
      13) [ ] Change all assert_select into expect(). Unless we need specific test.
      14) [ ] Add password_reset & remember_me spec if needed?
      15) [ ] Check if admin authorizations can be done with Devise methods
      16) [ ] Unify have_http_status(303) to use code.
      18) [ ] Change “render ‘user/profile” into “render :profile”. In every controller.
      19) [ ] Remove reduntant methods in models.
      21) [ ] improve custom.scss styles
      22) [ ] Make HTML ids consistent across all views
      23) [X] Remove '' from 'password' in forms
      24) [ ] Check for other DRY, clean improvement possibilities
12. [ ] Add Devise Admin Model
13. [ ] Check issues on Github and handle all of them.
