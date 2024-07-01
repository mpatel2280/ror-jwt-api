# spec/integration/pets_spec.rb
require 'swagger_helper'

describe 'Users API' do

  path '/users' do

    post 'Creates user' do
      tags 'Users'
      consumes 'application/json', 'application/xml'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          username: { type: :string },
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: [ 'name', 'username', 'email', 'password', 'password_confirmation' ]
      }

      response '201', 'user created' do
        let(:user) { 
          {
            "name": "manish2",
            "username": "manish2",
            "email": "manish2@ror.com",
            "password": "manish2",
            "password_confirmation": "manish2"
          }
         }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { name: 'testu' } }
        run_test!
      end
    end
  end

  path '/auth/login' do

    post 'Login user / Generate Token' do
      tags 'Users'
      consumes 'application/json', 'application/xml'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'email', 'password' ]
      }

      response '201', 'user login and token generated' do
        let(:user) { { email: 'testuser1@ror.com', password: 'testuser1' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { email: 'testu' } }
        run_test!
      end
    end
  end

  path '/users' do

    get 'Get all users' do
      tags 'Users'
      consumes 'application/json', 'application/xml'
      parameter name: :user, in: :header, schema: {
        type: :object,
        properties: {
          Authorization: { type: :string }
        },
        required: [ 'Authorization' ]
      }

      response '201', 'get all users' do
        let(:user) { { Authorization: 'Bearer Token: eyJhbGciOiJIUzI1XXX9.eyJ1c2VyX2lkIjXXXCJleHAiOjE3MTk4NDAzNzl9.tnsmNoXXXVX5vSZxOR5u3Is3jsJYe2UkZt1I9B9Qxmc' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { Authorization: '' } }
        run_test!
      end
    end
  end

 
end