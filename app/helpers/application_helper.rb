# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def view_not_implemented()
    '<div class="clean-error">HTML view is not implemented for [' + controller.controller_name + ":" + controller.action_name + '] action</div>'
  end

end
