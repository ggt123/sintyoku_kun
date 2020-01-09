Rails.application.routes.draw do

get   '/'                   =>  'topic#top'
get   '/topic/create_topic' =>  'topic#create_topic'
get   '/topic/create_anonymous_user' => 'topic#create_anonymous_user'
post  '/topic/save_topic'   =>  'topic#save_topic'
get   '/topic/:id'          =>  'topic#show'
post  '/topic/edit/:id'     =>  'topic#edit'
post  '/topic/delete/:id'   =>  'topic#delete_topic'
post  '/topic/save/:id'     =>  'topic#save'

get   '/user'               =>  'user#top'

post  '/comment/create_comment/:id' =>  'comment#create_comment'
get   '/comment/create_anonymous_user' => 'comment#create_anonymous_user'
post  '/comment/save_comment/:id' => 'comment#save_comment'

get   '/login'              =>    'user#login'
post  '/login_check'        =>    'user#login_check'
get   '/user_create'        =>    'user#user_create'
post  '/user_save'          =>    'user#user_save'
get   '/user/create_anonymous_user'   =>  'user#create_anonymous_user'
get   '/logout_question'    =>    'user#logout_question'
get   '/logout'             =>    'user#logout'
get   '/edit'               =>    'user#edit'
post  '/user/edit_save/:id' => 'user#edit_save'
post  '/user/user_destroy_question/:id'  =>  'user#user_destroy_question'
post  '/user_destroy/:id'   =>    'user#user_destroy'

#テストログイン用
get   '/testlogin'          =>    'user#testlogin'

end
