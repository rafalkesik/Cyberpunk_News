class ApplicationController < ActionController::Base

    def nil?
        self === nil
    end
end
