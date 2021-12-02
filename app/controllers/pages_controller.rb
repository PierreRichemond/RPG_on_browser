# frozen_string_literal: true
class PagesController < ApplicationController
  def index
    @fighters = Fighter.all
    @best_fighters = Fighter.all.sort_by {|fighter| fighter.level}.reverse.first(3)
    @fight = Fight.new
  end
end
