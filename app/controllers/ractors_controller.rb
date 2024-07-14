# app/controllers/ractors_controller.rb
class RactorsController < ApplicationController
    def perform_tasks
      # Create two Ractors to perform tasks in parallel
      ractor1 = Ractor.new do
        ActiveRecord::Base.connection_pool.with_connection do
          User.first.name
        end
      end
  
      ractor2 = Ractor.new do
        ActiveRecord::Base.connection_pool.with_connection do
          Post.first.title
        end
      end
  
      # Receive results from Ractors
      user_name = ractor1.take
      post_title = ractor2.take
  
      render json: { user_name: user_name, post_title: post_title }
    end
  end
  