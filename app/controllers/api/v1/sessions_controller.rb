class Api::V1::SessionsController < ApplicationController
  def whoami
    user = {
      admin: 'anpanman',
      password: 'hogehoge',
      message: 'i am super hero'
    }
    render json: user
  end
end
