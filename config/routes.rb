Rails.application.routes.draw do

  match 'create-new-event'        => 'events#create_new_event',     :via => [:post],  :as => :create_new_event  # creation of an event
  match 'publish-event'           => 'events#publish_event',        :via => [:post],  :as => :publish_event     # publish of an event
  match 'events'                  => 'events#index',                :via => [:get],   :as => :events            # list of events
  match 'events/:id'              => 'events#show',                 :via => [:get],   :as => :event_detail      # details of event
  match 'stop-event'              => 'events#stop_event',           :via => [:post],  :as => :stop_event        # stop event
  match 'update-event/:id'        => 'events#update',               :via => [:post],  :as => :update_event      # update and event
  match 'delete-event'            => 'events#delete_event',         :via => [:post],  :as => :delete_event      # update and event

  match 'owner-list'              => 'users#get_owner_list',        :via => [:get]    # get list of owners (admin)
  match 'users'                   => 'users#index',                 :via => [:get]    # get list of all the users
  match 'users/:id'               => 'users#show',                  :via => [:get]    # get details of the user
  match 'create-new-user'         => 'users#create',                :via => [:post]   # create new user
  match 'update-user/:id'         => 'users#update',                :via => [:put]    # update existing user

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
