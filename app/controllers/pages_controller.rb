# frozen_string_literal: true
class PagesController < ApplicationController
  def index
    @fighters = Fighter.all
    @best_fighters = Fighter.all.sort_by { |fighter| fighter.stats[:overall_stats] }.reverse.first(3)
    @fight = Fight.new
  end
end
