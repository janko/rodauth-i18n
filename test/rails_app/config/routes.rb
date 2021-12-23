Rails.application.routes.draw do
  root to: "test#root"

  constraints Rodauth::Rails.authenticated do
    get "/authenticated" => "test#root"
  end
end
