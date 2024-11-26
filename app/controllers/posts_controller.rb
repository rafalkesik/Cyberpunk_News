class PostsController < ApplicationController
    before_action :authorize,        only: [:new, :create]
    before_action :verify_destroyer, only: [:destroy]

    def index
        @posts = Post.order(created_at: :desc)
    end

    def show
        @post = Post.find(params[:id])
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
            render 'new'
        end
    end

    def destroy
        @post = Post.find(params[:id])
        @post.destroy
        flash[:success] = "Post deleted."
        redirect_to posts_path, status: :see_other
    end

    private


        def authorize
            if !logged_in?
                flash[:warning] = "Log in to submit posts."
                redirect_to login_url, status: :see_other
            end
        end

        def verify_destroyer
            @post = Post.find(params[:id])
            current_user_is_not_admin       = !current_user_is_admin
            current_user_is_not_post_author = !current_user_is_post_author(@post)

            if current_user_is_not_admin && current_user_is_not_post_author
                redirect_to root_url, status: :see_other
            end
        end

        def post_params
            params.require(:post).permit(:title, :content, :link)
        end
end
