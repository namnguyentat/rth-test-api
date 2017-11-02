# RSpec.shared_examples 'Paginatable' do |factory, per_page|
#   include_context 'user_login'
#
#   let!(:create_options) { defined?(create_params) ? create_params : {} }
#   let!(:data_key) { defined?(result_key) ? result_key : :records }
#
#   context "there are #{per_page - 1} items" do
#     items_num = per_page - 1
#
#     before(:each) do
#       create_list factory, items_num, create_options
#       integration_session.get url, params: {per_page: per_page}, headers: headers
#     end
#
#     it "renders #{items_num} items with params per_page #{per_page}" do
#       expect(json_response[data_key].length).to eq items_num
#     end
#
#     it 'returns pagination information' do
#       expect(json_response[:pagination][:total_count]).to eq items_num
#       expect(json_response[:pagination][:page_count]).to eq items_num
#     end
#   end
#
#   context "there are #{per_page} items" do
#     items_num = per_page
#
#     before(:each) do
#       create_list factory, items_num, create_options
#       integration_session.get url, params: {per_page: per_page}, headers: headers
#     end
#
#     it "renders #{items_num} items with params per_page #{per_page}" do
#       expect(json_response[data_key].length).to eq items_num
#     end
#
#     it 'returns pagination information' do
#       expect(json_response[:pagination][:total_count]).to eq items_num
#       expect(json_response[:pagination][:page_count]).to eq per_page
#     end
#   end
#
#   context "there are #{per_page + 1} items" do
#     items_num = per_page + 1
#
#     before(:each) do
#       create_list factory, items_num, create_options
#       integration_session.get url, params: {per_page: per_page}, headers: headers
#     end
#
#     it "renders #{per_page} items with params per_page #{per_page}" do
#       expect(json_response[data_key].length).to eq per_page
#     end
#
#     it 'returns pagination information' do
#       expect(json_response[:pagination][:total_count]).to eq items_num
#       expect(json_response[:pagination][:page_count]).to eq per_page
#     end
#   end
# end
