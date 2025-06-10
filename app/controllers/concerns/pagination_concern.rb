module PaginationConcern
  extend ActiveSupport::Concern

  def pagination_meta(paginated_object)
    PaginationMetaSerializer.new(paginated_object).as_json
  end

  def paginated_response(collection, serializer)
    {
      data: ActiveModelSerializers::SerializableResource.new(
        collection,
        each_serializer: serializer
      ),
      meta: pagination_meta(collection)
    }
  end
end
