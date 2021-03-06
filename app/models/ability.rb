class Ability
  include CanCan::Ability

  ROLES = [ :admin, :participant ]

  def initialize(user)
    user ||= User.new
    #if user.role? :admin
    #  can :manage, :all
    #else
    #  can :read, :all
    #end
    can :widget, :all

    if user.class == Participant
      can :read, :all
      can [:widget, :info_about_number], Voting
      can :manage, Claim
    end

    if user.class == Organization
      can [:create, :widget, :destroy], Voting
      can :update, Voting, status: :pending
      cannot :destroy, Voting, status: [ :active, :prizes ]
    end

    if user.class == AdminUser
      can :manage, :all
      cannot [:create, :destroy], Setting
      cannot [:create, :update, :edit], Payment
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
