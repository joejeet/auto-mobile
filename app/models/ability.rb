#Define the levels of authorization in this class
class Ability
  include CanCan::Ability
  
  def initialize(user)
       
    if user.is_admin? 
      can :manage, :all
    end

  end
end


