class CoinQuery < BaseQuery
  attr_reader :relation, :params

  def initialize(relation = Coin.all, params = {})
    super
    @relation = relation
    @params = params
  end

  def call
    scoped = relation
    scoped = apply_search(scoped)
    scoped = apply_order(scoped)
    paginate_coins(scoped)
  end

  protected

  def apply_search(scoped)
    return scoped unless search_present?

    search_term = "%#{params[:search].downcase}%"
    scoped.where(
      'LOWER(coingecko_id) LIKE :term OR LOWER(name) LIKE :term OR LOWER(symbol) LIKE :term',
      term: search_term
    )
  end

  def apply_order(scoped)
    order_column = order_params[:column] || 'market_cap_rank'
    order_direction = order_params[:direction] || 'asc'

    scoped.order("#{order_column} #{order_direction}")
  end

  def paginate_coins(scoped)
    scoped.page(params[:page] || 1)
          .per(params[:per_page] || 20)
  end
end
