RubyGnome2DocView::Application.routes.draw do
  get "browse/(:action(/:id))" => 'browse'

  root :to => "browse#index"

  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
