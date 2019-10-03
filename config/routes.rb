Rails.application.routes.draw do
  get '/' => "topic#top"
  get 'topic/create' => "topic#before_create_session_check"
  get 'topic/create_topic' => "topic#create_topic"
  post 'topic/save_topic' => 'topic#save_topic'

  get "/user/give_session" => "user#give_session"
  get "/user/error_view" => "user#error_view"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
