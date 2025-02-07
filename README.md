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
   a. [X] Post liking
   b. [X] Comment liking
6. [X] Comments
   a. [X] Basic comments
   b. [X] Subcomments
7. [X] Categories
8. [X] Configure RuboCop and clean up the code layout
9. [X] Change Minitest to Rspec
10. [ ] Improve signup/login to use Devise
   a. [X] Devise setup
   b. [ ] Sendgrid setup for mailer
   c. [ ] Deploy
   d. [ ] Add emails for old users and change usernames to use [old] tag
   e. [ ] Ask qnsi and Rafał Kęsik to create accounts
   f. [ ] Assign posts to new users and delete [old] ones
   d. [ ] Add unique & present validations for email
11. [ ] Refactoring all code
   x. [ ] Rename LikingRelations to PostLike & CommentLike (foreign_key: like)
   xx.[ ] Rename upvote to Like AND downvote to Unlike for consistency
   a. [ ] use only one flash methods (Devise or custom)
   b. [ ] !!my_liking_relation(user) # Should become .present?
   c. [ ] check all .erb files - they are not checked by Rubocop for now.
   d. [ ] Use Devise resource_params instead of my custom params methods?
   f. [ ] Check all specs for consistency and clarity
   g. [ ] Change 'login_as' into 'sign_in' (Devise). Same for logout, signup.
   h. [ ] Check for other devise paths inconcistencies
   i. [ ] Change all assert_select into expect(). Unless we need specific test.
   j. [ ] Add localisation requirement for every test
   k. [ ] Add password_reset & remember_me spec if needed?
   l. [ ] Check if admin authorizations can be done with Devise methods
   m. [ ] Unify have_http_status(303) to use code.
   n. [ ] Remove liking_relation and comment_liking_relation. (has_many relation is enough for them.)
   o. [ ] Change “render ‘user/profile” into “render :profile”. In every controller.
   p. [ ] Remove reduntant methods in models.
   r. [ ] Rename LikingRelation into PostLikingRelation (Or remove middle-model)
   s. [ ] improve custom.scss styles
   t. [ ] Add remaining Localisation text for PL.
   u. [ ] Make HTML ids consistent across all views
   t. [ ] Check for other DRY, clean improvement possibilities
12. [ ] Add Devise Admin Model


<!-- # README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ... -->
