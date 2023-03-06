class SolutionSpyController < ApplicationController
  protect_from_forgery with: :null_session
  def solution_spy
    @global = Global.first
    @solution_points = SolutionPoint.all
    @lang_points = LangPoint.all
    @hole_points = HolePoint.all
  end
end