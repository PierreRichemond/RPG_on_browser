# require "rails_helper"

# RSpec.describe FightersController, type: :controller do
#   context 'GET #index' do
#     it 'returns a success response' do
#       get :index
#       expect(response).to be_success # response.success ?
#     end
#   end

#   context 'GET #show' do
#     it 'returns a success response' do
#       fighter = Fighter.create!(name: 'Ken', level: 1)
#       get :show, params: { id: fighter.to_param}
#       expect(response).to be_success
#     end
#   end

#   context 'GET #new' do
#     it 'assigns a new fighter to @fighter' do
#       get :new
#       expect(assigns(:fighter)).to be_a_new(Fighter)
#     end
#   end

#   context 'GET #create' do
#     let(:valid_params) { 'fighter' => {name: 'Bob', level: 1} }
#     it 'creates a new Fighter' do
#       expect {post :create, valid_params}.to change(Fighter, :count).by(1)
#     end
#   end

#   describe "DELETE #destroy" do
#     let(:valid_params) { 'fighter' => {name: 'Bob', level: 1} }
#     it 'deletes a fighter' do
#       expect {delete :destroy, valid_params}.to change(Fighter, :count).by(-1)
#       expect(response).to redirect_to(fighters_path)
#     end
#   end
# end
