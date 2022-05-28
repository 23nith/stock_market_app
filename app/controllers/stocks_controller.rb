class StocksController < ApplicationController
  before_action :set_stock, only: %i[ show update destroy ]
  before_action :authenticate_user!

  # GET /stocks
  def index
    # @stocks = Stock.all
    @stocks = User.find(current_user.id).stocks

    @myarr = []
    @transactions = Transaction.where(user_id: current_user.id)

    @stocks.each do |stock|
      @total_amount_spent = @transactions.where(stock_id: stock.id).sum(:total_amount).to_f

      @total_stock_count_bought = @transactions.where(stock_id: stock.id, transaction_type: "buy").sum(:count)

      @total_stock_count_sold = @transactions.where(stock_id: stock.id, transaction_type: "sell").sum(:count)

      @total_stock_count = @total_stock_count_bought - @total_stock_count_sold
      # :latest_price => Stock.get_iex.quote(stock.ticker).latest_price
      @myarr.push({:ticker => stock.ticker, :investment_value => @total_amount_spent, :shares_owned => @total_stock_count})
    end

    puts "#{@myarr}"

    # render json: @stocks
    render json: @myarr.uniq
  end

  # GET /top_ten
  def top_ten
    @top_ten = Stock.top_ten

    render json: @top_ten
  end

  # GET /stock_info
  def stock_info
    @stock_info = Stock.get_iex.quote(stock_params["ticker"])
    render json: @stock_info
  end

  # GET /stocks/1
  def show
    render json: @stock
  end

  # POST /stocks
  def create
    @stock = Stock.new(stock_params)

    if @stock.save
      render json: @stock, status: :created, location: @stock
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stocks/1
  def update
    if @stock.update(stock_params)
      render json: @stock
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end

  # DELETE /stocks/1
  def destroy
    @stock.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stock_params
      params.require(:stock).permit(:ticker)
    end
end
