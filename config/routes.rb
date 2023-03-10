# frozen_string_literal: true

Rails.application.routes.draw do
  post '/api', to: 'api#api_call_handler'
end
