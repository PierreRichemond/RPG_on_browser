# frozen_string_literal: true
require 'rails_helper'

describe PagesController, type: :request do
  describe 'GET index' do
    it 'renders successfully' do
      get '/'
      expect(response).to be_successful
    end
  end
end
