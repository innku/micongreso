module VotesHelper
  
  def vote_link_class(vote)
    vote.vote ? "si" : "no"
  end
end