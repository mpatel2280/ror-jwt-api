class ApplicationMailer < ActionMailer::Base
  default from: "from@localhost:3001"
  layout "mailer"
end
