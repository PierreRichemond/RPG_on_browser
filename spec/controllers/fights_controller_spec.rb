# require "rails_helper"

# RSpec.describe FightsController, type: :controller do
#   before do
#     let(:first_fighter) { FighterService.create_fighter('Joe', nil) }
#     let(:duplication) { first_fighter }
#     let(:second_fighter) { FighterService.create_fighter('bobby', nil) }
#   end

#   # context 'GET #index' do
#   #   it 'returns a success response' do
#   #     get :index
#   #     expect(response).to be_success # response.success ?
#   #   end
#   # end

#   context 'GET #show' do
#     it 'returns a success response' do
#       fight = Fight.create!(red_fighter: first_fighter, blue_fighter: second_fighter)
#       get :show, params: { id: fight.to_param}
#       expect(fight).to be_an_instance_of Fight
#       expect(response).to be_success
#       expect(response).to redirect_to(fighter_path(fight))
#     end

#     it 'returns a failure response' do
#       fight = Fight.create!(red_fighter: first_fighter, blue_fighter: first_fighter)
#       get :show, params: { id: fight.to_param}
#       expect(response).not_to be_success
#       expect(response).not_to redirect_to(fighter_path(fight))
#       expect(response).to redirect_to(root_path)
#     end
#   end

#   context 'GET #create' do
#     it 'assigns a new fight to @fight' do
#       let(:valid_params) { 'fight' => {
#         red_fighter_id: first_fighter,
#         blue_fighter_id: second_fighter} }

#       expect(assigns(:fight)).to be_a_new(Fight)
#       expect {
#         post :create, valid_params
#       }.to change(Fight, :count).by(1)
#     end

#     it 'does not to assign a new fight to @fight while invalid params' do
#       let(:invalid_params) { 'fight' => {
#         red_fighter_id: first_fighter,
#         blue_fighter_id: duplication} }

#       expect(assigns(:fight)).not_to be_a_new(Fight)
#       expect {
#         post :create, invalid_params
#       }.not_to change(Fight, :count).by(1)
#     end
#   end
# end
