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

    render json: @transactions
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
    # check if symbol is already in the list of stocks
    if Stock.find_by(ticker: transaction_params["symbol"]) == nil
      Stock.create!(ticker: transaction_params["symbol"])
    end

    @stock_id = Stock.find_by(ticker: transaction_params["symbol"]).id
    @stock_price = Stock.latest_price(transaction_params["symbol"])

    # TOTAL AMOUNT 
    if transaction_params[:transaction_type] == "buy"
      @total_amount = transaction_params[:count] * @stock_price * -1
      @gains = 0;
    elsif transaction_params[:transaction_type] == "sell"
      @total_amount = transaction_params[:count] * @stock_price 
      # COMPUTE GAINS
      @total_amount_spent = Transaction.where(user_id: 1).where(stock_id: @stock_id).sum(:total_amount).to_i
      @total_stock_count = Transaction.where(user_id: 1).where(stock_id: @stock_id).sum(:count)
      @ave_val_stock = @total_amount_spent / @total_stock_count
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
