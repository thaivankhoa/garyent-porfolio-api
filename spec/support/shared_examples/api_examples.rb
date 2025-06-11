RSpec.shared_examples 'requires authentication' do
  it 'returns unauthorized status' do
    expect(response).to have_http_status(:unauthorized)
  end
end

RSpec.shared_examples 'paginated endpoint' do
  it 'returns pagination metadata' do
    expect(json_response['meta']).to include('pagination')
    expect(json_response['meta']['pagination']).to include(
      'current_page',
      'total_pages',
      'total_count',
      'per_page'
    )
  end
end

RSpec.shared_examples 'validates presence' do |field|
  it { is_expected.to validate_presence_of(field) }
end

RSpec.shared_examples 'successful request' do
  it 'returns success status' do
    expect(response).to have_http_status(:success)
  end

  it 'returns JSON response' do
    expect(response.content_type).to eq('application/json; charset=utf-8')
  end
end 