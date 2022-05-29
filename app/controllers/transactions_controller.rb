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
    # @transaction = Transaction.new(transaction_params)
    # CHECK IF SYMBOL IS ALREADY IN THE LIST OF STOCKS
    if Stock.find_by(ticker: transaction_params["symbol"]) == nil
      Stock.create!(ticker: transaction_params["symbol"])
    end
    # find_or_create_by

    @stock_id = Stock.find_by(ticker: transaction_params["symbol"]).id
    @stock_price = Stock.latest_price(transaction_params["symbol"])

    # TOTAL AMOUNT AND GAINS
    if transaction_params[:transaction_type] == "buy"
      @total_amount = transaction_params[:count].to_f * @stock_price 
      User.find(current_user.id)
      @gains = 0;
    elsif transaction_params[:transaction_type] == "sell"
      @total_amount = transaction_params[:count].to_f * @stock_price 
      # @gains = 0;
      user_transactions = Transaction.where(user_id: current_user.id)
      # COMPUTE GAINS
      @total_amount_earned = User.find(current_user.id).transactions.where(stock_id: @stock_id, transaction_type: "sell").sum(:total_amount)
      @total_amount_spent = User.find(current_user.id).transactions.where(stock_id: @stock_id, transaction_type: "buy").sum(:total_amount)
      # @total_amount_spent = Transaction.where(user_id: current_user.id).where(stock_id: @stock_id).sum(:total_amount).to_f
      @total_amount_to_be_divided = @total_amount_spent - @total_amount_earned
      @total_stock_count_bought = Transaction.where(user_id: current_user.id).where(stock_id: @stock_id, transaction_type: "buy").sum(:count)
      @total_stock_count_sold = Transaction.where(user_id: current_user.id).where(stock_id: @stock_id, transaction_type: "sell").sum(:count)
      @total_stock_count = @total_stock_count_bought - @total_stock_count_sold
      @ave_val_stock = (@total_amount_to_be_divided) / @total_stock_count
      @gains = (@stock_price - @ave_val_stock) * transaction_params[:count] 
      
    end


    @total_amount = transaction_params[:count].to_f * @stock_price 
    # @gains = 0;

    # debugger
    @transaction = Transaction.new({
      user_id: current_user.id, 
      stock_id: @stock_id, 
      # ticker: Stock.find(@stock_id).ticker,
      share_price: @stock_price.to_f.round(2),
      count: transaction_params["count"],
      gains: @gains.to_f.round(2),
      total_amount: @total_amount.to_s[0,13].to_f.round(2),
      transaction_type: transaction_params["transaction_type"],
    })

    # puts "TEST !!!!!!!!!!!!! #{@total_amount.to_s[0,13].to_f}"
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
    # debugger
    @user = User.find(params[:id])
    @user.confirmed_at = DateTime.now
    if @user.save!
      UserMailer.with(user: @user).user_approved.deliver_later
      render json: {
        status: {code: 200, message: 'User has been approved.'},
      }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:user_id, :symbol, :count, :transaction_type, :ticker)
    end
end
