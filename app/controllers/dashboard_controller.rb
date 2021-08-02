class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
        @user_list = User.where.not(id: current_user.id).pluck(:email)
        @transfer_list = Transfer.log(current_user)
    end

    def send_transfer
        # Receiver variables
        to_amount = transfer_params[:amount].to_f
        to_transfer = User.find_by(email: transfer_params[:email])

        # Basic valid inputs check
        valid_email = transfer_params[:email].match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/)
        valid_amount = to_amount.positive?
        valid_receiver = current_user.email != transfer_params[:email]
        valid_user = !to_transfer.nil?
        valid_balance = current_user.account.balance >= to_amount

        # Could be made nested-IFs/Cases to display accurate information for the user
        if valid_email && valid_amount && valid_receiver && valid_user && valid_balance
            # Transfer
            if start_transfer(current_user, to_transfer, to_amount)
                flash[:notice] = "Transfer successful"
                redirect_to dashboard_path and return
            else
                flash[:notice] = "Transaction error"
                redirect_to dashboard_path and return
            end
        else
            flash[:notice] = "Invalid transfer"
            redirect_to dashboard_path and return
        end
    end

    private

    def start_transfer(from, to, amount)
        Account.transaction do
            Account.tx(from, to, amount)
        end
        return true
    rescue Exception => ex
        return false
    end

    def transfer_params
        params.permit(:email, :amount, :authenticity_token, :utf8, :commit)
    end
end
