class PaginationMetaSerializer < ActiveModel::Serializer
  attributes :pagination

  def pagination
    {
      current_page: object.current_page,
      total_pages: object.total_pages,
      total_count: object.total_count,
      per_page: object.limit_value
    }
  end
end
