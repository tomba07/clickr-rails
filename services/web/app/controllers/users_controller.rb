class UsersController < ApplicationController
  def school_class
    # TODO Move under /users/<id>/school_class for RESTful API
    current_user&.update_attribute(:school_class_id, params[:school_class_id])
    redirect_to request.referer if request.referer
  end
end
