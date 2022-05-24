class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show update destroy ]
  before_action :authenticate_user!

  # GET /transactions
  def index
    if current_user.role == "admin"
      @transactions = Transaction.all
    elsif current_user.role == "user"
      @transactions = Transaction.where(user_id: current_user.id)
      @myarr = []
      @transactions.each do |transaction|
        @myarr.push({:id => transaction.id, :user_id => transaction.user_id, :count => transaction.count, :transaction_type => transaction.transaction_type, :share_price => transaction.share_price, :total_amount => transaction.total_amount, :gains => transaction.gains, :created_at => transaction.created_at, :stock_id => transaction.stock_id, :ticker => Stock.find(transaction.stock_id).ticker})
      end
    end

    # render json: @transactions
    render json: @myarr
  end

  def buy

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

    @stock_id = Stock.find_by(ticker: transaction_params["symbol"]).id
    @stock_price = Stock.latest_price(transaction_params["symbol"])

    # TOTAL AMOUNT AND GAINS
    if transaction_params[:transaction_type] == "buy"
      @total_amount = transaction_params[:count] * @stock_price * -1
      @gains = 0;
    elsif transaction_params[:transaction_type] == "sell"
      @total_amount = transaction_params[:count] * @stock_price 
      # COMPUTE GAINS
      @total_amount_spent = Transaction.where(user_id: 1).where(stock_id: @stock_id).sum(:total_amount).to_f
      @total_stock_count_bought = Transaction.where(user_id: 1).where(stock_id: @stock_id, transaction_type: "buy").sum(:count)
      @total_stock_count_sold = Transaction.where(user_id: 1).where(stock_id: @stock_id, transaction_type: "sell").sum(:count)
      @total_stock_count = @total_stock_count_bought - @total_stock_count_sold
      @ave_val_stock = (@total_amount_spent * -1) / @total_stock_count
      @gains = (@stock_price - @ave_val_stock) * transaction_params[:count] 
    end

    

    @transaction = Transaction.new({
      user_id: current_user.id, 
      stock_id: @stock_id, 
      share_price: @stock_price,
      count: transaction_params["count"],
      gains: @gains,
      total_amount: @total_amount,
      transaction_type: transaction_params["transaction_type"],
    })


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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:user_id, :symbol, :count, :transaction_type)
    end
end
