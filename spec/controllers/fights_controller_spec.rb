require "rails_helper"

RSpec.describe FightsController, type: :controller do
  before do
    let(:first_fighter) { FighterService.create_fighter('Joe', nil) }
    let(:second_fighter) { FighterService.create_fighter('bobby', nil) }
  end
  # context 'GET #index' do
  #   it 'returns a success response' do
  #     get :index
  #     expect(response).to be_success # response.success ?
  #   end
  # end

  context 'GET #show' do
    it 'returns a success response' do
      fight = Fight.create!(red_fighter: first_fighter, blue_fighter: second_fighter)
      get :show, params: { id: fight.to_param}
      expect(response).to be_success
    end

    it 'returns a failure response' do
      fight = Fight.create!(red_fighter: first_fighter, blue_fighter: first_fighter)
      get :show, params: { id: fight.to_param}
      expect(response).not_to be_success
    end
  end

  context 'GET #create' do
    it 'assigns a new fight to @fight' do
      let(:valid_params) { {'fight' => {
        red_fighter_id: first_fighter.id,
        blue_fighter_id: second_fighter.id,} }
      post :create
      expect(assigns(:fight)).to be_a_new(Fight)
      expect {
        post :create, valid_params
      }.to change(Fighter, :count).by(1)
    end

    it 'not to assign a new fight to @fight while invalid params' do
      let(:invalid_params) { {'fight' => {
        red_fighter_id: first_fighter.id,
        blue_fighter_id: second_fighter.id,} }
      post :create
      expect(assigns(:fight)).not_to be_a_new(Fight)
      expect {
        post :create, invalid_params
      }.not_to change(Fighter, :count).by(1)
    end
  end
end
