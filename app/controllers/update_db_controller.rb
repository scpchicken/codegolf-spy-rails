class UpdateDbController < ApplicationController
  protect_from_forgery with: :null_session
  def main
    @global = Global.first
  end
  
  def update_db
    # redirect_to controller: "main", action: "main"
    Thread.new do
      @global = Global.first
      login_hash = {}
      solution_hash = {}
  
      solution_point_vec = []
      lang_score_vec = []
      hole_score_vec = []
      
      SolutionPoint.delete_all
      LangPoint.delete_all
      HolePoint.delete_all
  
      # do you even lift bro?
      `curl -L https://code.golf/scores/all-holes/all-langs/all -o solution.json`
      file = File.open("solution.json")
      solution_file_hash = JSON.parse(file.read)
      file.close
      solution_file_hash
        .select{|solution|
          solution["scoring"] == "bytes"
        }
        .map{|solution|
          hole = solution["hole"]
          lang = solution["lang"]
          bytes = solution["bytes"].to_i
          login = solution["login"]
  
          login_hash[login] ||= Hash.new
          login_hash[login][hole] ||= Hash.new
          login_hash[login][hole][lang] = bytes
          
          solution_hash[hole] ||= Hash.new
  
          solution_hash[hole]["global"] ||= Hash["bytes" => bytes, "count" => 0]
          solution_hash[hole]["global"]["count"] += 1
  
          solution_hash[hole][lang] ||= Hash["bytes" => bytes, "count" => 0]
          solution_hash[hole][lang]["count"] += 1
  
          solution_hash[hole]["global"]["bytes"] = [bytes, solution_hash[hole]["global"]["bytes"]].min
          solution_hash[hole][lang]["bytes"] = [bytes, solution_hash[hole][lang]["bytes"]].min
        }
      score_global_hash = (0...login_hash.size).zip(login_hash).map{|ind, (login, hole_hash)|
        total_point = 0
        login_point_max = 0
        login_point_max = 0
        hold_ind_max = nil
        (0...hole_hash.size).zip(hole_hash)
          .map{|hole_ind, (hole, lang_hash)|
            lang_point_vec = lang_hash
              .map{|lang, bytes|
  # Points = Sb ÷ Su × 1000
  # Where Su is the length of the user's solution, and Sb is a Bayesian estimator of the form:
  # Sb = ((√n + 2) ÷ (√n + 3)) × S + (1 ÷ (√n + 3)) × Sa
  # n is the number of solutions in this hole in this language. S is the length of the shortest solution in this hole in this language. Sa is the shortest solution among all languages in this hole.
                su = bytes.to_f
                s = solution_hash[hole][lang]["bytes"].to_f
                sa = solution_hash[hole]["global"]["bytes"].to_f
                sqrt_n = Math.sqrt(solution_hash[hole][lang]["count"])
                sb = ((sqrt_n + 2.0) / (sqrt_n + 3.0)) * s + (1.0 / (sqrt_n + 3.0)) * sa
                points = sb / su * 1000
  
                # langs => lid 1 | hid 5 | lang "J" | score 500
                lang_score_vec << {:lid => ind, :hid => hole_ind, :lang => lang, :score => points}
                
                [lang, points]
              }
              .sort_by{|lang, point|
                [point, lang]
              }
              .map{|lang, point|
                [lang, point.round]
              }
            lang_max, point_max = lang_point_vec[-1]
  
            total_point += point_max
  
            # holes => lid 1 | hid 5 | hole "divisors" | lang "python" | score 903
            hole_score_vec << {:lid => ind, :hid => hole_ind, :hole => hole, :lang_best => lang_max, :score_best => point_max}
          #
          # end of for each hole
          #
          }
  
        solution_point_vec << {:lid => ind, :login => login}
      }
  
      SolutionPoint.insert_all(solution_point_vec)
      HolePoint.insert_all(hole_score_vec)
      LangPoint.insert_all(lang_score_vec)
  
      @global.update(time_update: Time.now.to_i)
      @global.update(chicken: @global.chicken + 1)
    end
  end
end