class PostsController < ApplicationController
    before_action :authenticate,     only: [:new, :create]
    before_action :verify_destroyer, only: [:destroy]

    def index
        @posts = Post.order(created_at: :desc)
        @current_user = current_user
    end

    def show
        @post        = Post.find(params[:id])
        @comments    = @post.comments.where.not(id: nil)
        @new_comment = @post.comments.build()
        @current_user = current_user
    end

    def new
        @post = Post.new
    end

    def create
        @user = current_user
        @post = @user.posts.build(post_params)
        if @post.valid?
            @post.save
            flash[:success] = "News Post created!"
            redirect_to posts_url, status: :see_other
        else
            respond_to do |format|
                format.html { render 'new' }
                format.turbo_stream 
            end
        end
    end

    def destroy
        @post = Post.find(params[:id])

        @post.destroy
        
        respond_to do |format|
            format.html do
                flash[:success] = "Post deleted."
                redirect_to posts_url, status: :see_other
            end
            format.turbo_stream { flash.now[:success] = "Post deleted." }
        end
    end

    private


        def authenticate
            if !logged_in?
                store_requested_location
                flash[:warning] = "Log in to submit posts."
                redirect_to login_url, status: :see_other
            end
        end

        def verify_destroyer
            @post = Post.find(params[:id])
            current_user_is_not_admin       = !current_user&.admin?
            current_user_is_not_post_author = !current_user&.is_author_of_post(@post)

            if current_user_is_not_admin && current_user_is_not_post_author
                redirect_to root_url, status: :see_other
            end
        end

        def post_params
            params.require(:post).permit(:title, :content, :link)
        end
end
