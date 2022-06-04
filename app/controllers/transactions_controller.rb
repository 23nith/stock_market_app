class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show update destroy ]
  before_action :authenticate_user!

  # GET /transactions
  def index
    if current_user.role == "admin"
      @transactions = Transaction.all
    elsif current_user.role == "user"
      @transactions = Transaction.where(user_id: current_user.id)
    end
    # @myarr = []
    # @transactions.each do |transaction|
    #   @myarr.push({:id => transaction.id, :user_id => transaction.user_id, :count => transaction.count, :transaction_type => transaction.transaction_type, :share_price => transaction.share_price, :total_amount => transaction.total_amount, :gains => transaction.gains, :created_at => transaction.created_at, :stock_id => transaction.stock_id, :ticker => Stock.find(transaction.stock_id).ticker})
    # end
    # render json: @myarr
    # debugger
    render json: @transactions.to_json(include: [stock: {only: [:ticker]}])

  end

  # GET /transactions/1
  def show
    render json: @transaction
  end

  # POST /transactions
  def create
    check_if_symbol_exists(transaction_params["symbol"])
    # find_or_create_by
    create_new_transaction(transaction_params)
    @transaction = create_new_transaction(transaction_params)

    if @transaction.save
      render json: @transaction, status: :created, location: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      render json: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy
  end

  def approve_user
    @user = User.find(params[:id])
    @user.confirmed_at = DateTime.now
    if @user.save!
      UserMailer.with(user: @user).user_approved.deliver_later
      render json: {
        status: {code: 200, message: 'User has been approved.'},
      }
    end

  end

  def add_user
    @user = User.new(user_params)
    if current_user.role == "admin"
      @user.skip_confirmation!
    end
    if @user.save!
      render json: {
        status: {code: 200, message: "Admin successfully created Trader."},
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def check_if_symbol_exists(symbol)
      if Stock.find_by(ticker: symbol) == nil
        Stock.create!(ticker: symbol)
      end
    end

    def compute_gains(transaction_type, count, stock_price)
      if transaction_params[:transaction_type] == "buy"
        @gains = 0;
      elsif transaction_params[:transaction_type] == "sell"
        user_transactions = Transaction.where(user_id: current_user.id)
        @total_amount_earned = user_transactions.where(stock_id: @stock_id, transaction_type: "sell").sum(:total_amount)
        @total_amount_spent = user_transactions.where(stock_id: @stock_id, transaction_type: "buy").sum(:total_amount)
        @total_amount_to_be_divided = @total_amount_spent - @total_amount_earned
        @total_stock_count_bought = user_transactions.where(stock_id: @stock_id, transaction_type: "buy").sum(:count)
        @total_stock_count_sold = user_transactions.where(stock_id: @stock_id, transaction_type: "sell").sum(:count)
        @total_stock_count = @total_stock_count_bought - @total_stock_count_sold
        @ave_val_stock = (@total_amount_to_be_divided / @total_stock_count).nan? ? 0 : (@total_amount_to_be_divided / @total_stock_count)
        @gains = (stock_price - @ave_val_stock) * count.to_f
      end
    end

    def create_new_transaction(transaction_params)
      @stock_id = Stock.find_by(ticker: transaction_params["symbol"]).id
      @stock_price = Stock.latest_price(transaction_params["symbol"])
      @total_amount = transaction_params[:count].to_f * @stock_price 
      @gains = compute_gains(transaction_params[:transaction_type], transaction_params[:count], @stock_price)
      Transaction.new({
        user_id: current_user.id, 
        stock_id: @stock_id, 
        share_price: @stock_price.to_f.round(2),
        count: transaction_params["count"],
        gains: @gains.to_f.round(2),
        total_amount: @total_amount.to_s[0,13].to_f.round(2),
        transaction_type: transaction_params["transaction_type"],
      })
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:user_id, :symbol, :count, :transaction_type, :ticker)
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
    end
end
