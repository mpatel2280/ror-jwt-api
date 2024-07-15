class UserMailer < ApplicationMailer
    def user_created(name, email)
        @name = name
        @email = email
        @url  = 'http://localhost:3001/'
        mail(to: @email, subject: 'User has been created!')
      end
end
