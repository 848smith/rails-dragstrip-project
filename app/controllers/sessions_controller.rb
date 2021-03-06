class SessionsController < ApplicationController
    layout "application"
    before_action :driver_layout
    before_action :is_logged_in?, only: [:new, :create]
    skip_before_action :driver_layout, only: [:auth]

    def new
    end

    def create
        if @driver = Driver.find_by(username: params[:username])
            if @driver.authenticate(params[:password])
                session[:driver_id] = @driver.id
                redirect_to driver_path(@driver)
            else
                flash[:error] = 'Invalid password'
                render 'new'
            end
        else
            flash[:error] = 'User does not exist'
            render 'new'
        end
    end

    def auth
        pp request.env['omniauth.auth']
        @driver = Driver.find_by(username: request.env['omniauth.auth']['info']['nickname'])
        #session[:username] = request.env['omniauth.auth']['info']['nickname']
        session[:driver_id] = @driver.id
        session[:omniauth_data] = request.env['omniauth.auth']
        redirect_to root_path
    end

    def destroy
       session.delete :driver_id
       redirect_to "/" 
    end
end