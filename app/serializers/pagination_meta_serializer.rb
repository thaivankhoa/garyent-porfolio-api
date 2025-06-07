class PaginationMetaSerializer < ActiveModel::Serializer
  attributes :current_page, :total_pages, :total_count, :per_page

  def current_page
    object.current_page
  end

  def total_pages
    object.total_pages
  end

  def total_count
    object.total_count
  end

  def per_page
    object.limit_value
  end
end 