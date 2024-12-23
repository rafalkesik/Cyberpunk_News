class PostsController < ApplicationController
    before_action :authenticate,     only: [:new, :create, :destroy]
    before_action :verify_destroyer, only: [:destroy]

    def index
        @posts = Post.order(created_at: :desc)
    end

    def show
        @post          = Post.find(params[:id])
        @root_comments = @post.comments.where.not(id: nil).where(parent_id: nil)
        @new_comment   = @post.comments.build()
        @parent        = nil
    end

    def new
        @post = Post.new
    end

    def create
        @user = current_user
        @post = @user.posts.build(post_params)
        if @post.valid?
            @post.save
            flash[:success] = t 'flash.post_created'
            redirect_to posts_url, status: :see_other
        else
            render turbo_stream:[
                turbo_stream.replace("new_post", template: 'posts/new')
            ]
        end
    end

    def destroy
        @post = Post.find(params[:id])

        @post.destroy
        flash.now[:success] = t 'flash.post_deleted'
        if request.referrer == post_url(@post)
          redirect_to root_url, status: :see_other
        end
    end

    private


        def authenticate
            if !logged_in?
                store_requested_location
                flash[:warning] = t 'flash.authenticate_add_post'
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
