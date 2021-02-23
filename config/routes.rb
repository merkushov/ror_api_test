Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post '/visited_links', to: 'visited_domains#add_links'
  get '/visited_domains', to: 'visited_domains#show_domains'
end
