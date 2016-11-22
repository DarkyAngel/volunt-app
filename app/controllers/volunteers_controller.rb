class VolunteersController < ApplicationController
  include ProfilesControllerConcern

  profile_controller :volunteer, 'Voluntar'

  # GET/volunteers/assignments
  def assignments
    @profiles =  Profile.volunteers.
        joins(:projects).
        order(:full_name).
        includes([:memberships, :projects]).
        all
  end
  
end
