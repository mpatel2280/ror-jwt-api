# app/controllers/concurrent_controller.rb
require 'concurrent-ruby'
class ConcurrentController < ApplicationController

  def get_concurrent_data
    #responses = get_concurrent_data_with_thread_pool
    responses = get_concurrent_data_without_thread_pool
    render json: { data: responses }
  end

  def get_concurrent_data_without_thread_pool
    urls = ['https://dummyjson.com/posts', 'https://dummyjson.com/comments']

    fetch_data = urls.map do |url|
      Concurrent::Future.execute { Net::HTTP.get(URI(url)) }
    end

    return fetch_data.map(&:value).map { |response| JSON.parse(response) }
  end

  def get_concurrent_data_with_thread_pool
    urls = ['https://dummyjson.com/products', 'https://dummyjson.com/users']

    thread_pool = Concurrent::FixedThreadPool.new(10)
    fetch_data = urls.map do |url|
      Concurrent::Future.execute(executor: thread_pool) do
        begin
          Net::HTTP.get(URI(url))
        rescue StandardError => e
          { error: e.message }
        end
      end
    end

    return fetch_data.map(&:value).map { |response| JSON.parse(response) }    
  end

end



