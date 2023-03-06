class MainController < ApplicationController
  protect_from_forgery with: :null_session
  def main
    Global.upsert({:id => 1});
    @global = Global.first
    @solution_points = SolutionPoint.all
    @lang_points = LangPoint.all
    @hole_points = HolePoint.all
    # @global.update(time_update: 0)
  end

  def query_login
    @login = SolutionPoint.find_by(login: params[:login])
    redirect_to controller: 'solution_spy', action: 'solution_spy', lid: @login.lid, login: @login.login
  end
end
