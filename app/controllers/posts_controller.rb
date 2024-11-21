class PostsController < ApplicationController
    before_action :authorize, only: [:new, :create]

    def index
        @posts = Post.all
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

        def post_params
            params.require(:post).permit(:title, :content, :link)
        end
end
