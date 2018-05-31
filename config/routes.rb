Rails.application.routes.draw do
  resources :jobs, path: "/" do
    patch "stage", on: :member
    patch "submit", on: :member
    patch "stop", on: :member
  end
end
