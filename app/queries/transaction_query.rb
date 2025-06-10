class TransactionQuery < BaseQuery
  def initialize(relation = Transaction.all, params = {})
    super
  end

  def call
    scoped = relation
    scoped = apply_filters(scoped)
    scoped = apply_search(scoped)
    scoped = apply_order(scoped)
    paginate(scoped)
  end

  protected

  def apply_filters(scoped)
    scoped = filter_by_type(scoped)
    scoped = filter_by_date_range(scoped)
    scoped = filter_by_portfolio(scoped)
    filter_by_portfolio_coin(scoped)
  end

  def apply_order(scoped)
    order_column = order_params[:column] || 'transaction_date'
    order_direction = order_params[:direction] || 'desc'

    scoped.order("#{order_column} #{order_direction}")
  end

  private

  def filter_by_type(scoped)
    return scoped if filter_params[:transaction_type].blank?

    scoped.where(transaction_type: filter_params[:transaction_type])
  end

  def filter_by_date_range(scoped)
    scoped = scoped.where(transaction_date: (filter_params[:start_date])..) if filter_params[:start_date].present?
    scoped = scoped.where(transaction_date: ..(filter_params[:end_date])) if filter_params[:end_date].present?
    scoped
  end

  def filter_by_portfolio(scoped)
    return scoped if filter_params[:portfolio_id].blank?

    scoped.joins(portfolio_coin: :portfolio)
          .where(portfolio_coins: { portfolio_id: filter_params[:portfolio_id] })
  end

  def filter_by_portfolio_coin(scoped)
    return scoped if filter_params[:portfolio_coin_id].blank?

    scoped.where(portfolio_coin_id: filter_params[:portfolio_coin_id])
  end
end
