class UserMailer < ApplicationMailer
    def user_created(user)
        @user = user
        @url  = 'http://localhost:3001/'
        mail(to: @user.email, subject: 'User has been created!')
      end
end
