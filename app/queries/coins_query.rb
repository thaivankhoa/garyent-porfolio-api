class CoinsQuery
  attr_reader :relation, :params

  def initialize(relation = Coin.all, params = {})
    @relation = relation
    @params = params
  end

  def call
    scoped = relation
    scoped = search_coins(scoped)
    scoped = order_coins(scoped)
    paginate_coins(scoped)
  end

  private

  def search_coins(scoped)
    return scoped if params[:search].blank?

    search_term = "%#{params[:search].downcase}%"
    scoped.where(
      "LOWER(coingecko_id) LIKE :term OR LOWER(name) LIKE :term OR LOWER(symbol) LIKE :term",
      term: search_term
    )
  end

  def order_coins(scoped)
    scoped.order(market_cap_rank: :asc)
  end

  def paginate_coins(scoped)
    scoped.page(params[:page] || 1)
          .per(params[:per_page] || 20)
  end
end

