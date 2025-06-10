class BaseQuery
  attr_reader :relation, :params

  def initialize(relation = nil, params = {})
    @relation = relation
    @params = params
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
    scoped
  end

  def apply_search(scoped)
    scoped
  end

  def apply_order(scoped)
    scoped
  end

  def paginate(scoped)
    scoped.page(params[:page])
          .per(params[:per_page])
  end

  def search_term
    @search_term ||= "%#{params[:search]&.downcase}%"
  end

  def search_present?
    params[:search].present?
  end

  def order_params
    params[:order] || {}
  end

  def filter_params
    params[:filter] || {}
  end
end
