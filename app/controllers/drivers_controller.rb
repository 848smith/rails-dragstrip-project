class DriversController < ApplicationController
    layout 'application'
    before_action :driver_layout, only: [:home]
    before_action :require_login, only: [:show]
    before_action :current_user, only: [:show, :edit, :update]

    def home
    end

    def new
        @driver = Driver.new
    end

    def create
        @driver = Driver.new(driver_params)
        if @driver.save
            session[:driver_id] = @driver.id
            redirect_to driver_path(@driver)
        else
            render 'new'
        end
    end
    
    def show
        @driver = Driver.find_by(id: params[:id])
    end

    def edit
        @driver = Driver.find_by(id: params[:id])
    end

    def update
        @driver = Driver.find_by(id: params[:id])
        @driver.update(driver_params)
        redirect_to driver_path(@driver)
    end

    private

    def driver_params
        params.require(:driver).permit(:username, :first_name, :last_name, :password, :age, :experience, :country)
    end
end
