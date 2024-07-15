# app/workers/create_user_email_worker.rb
class CreateUserEmailWorker
    include Sidekiq::Worker
  
    def perform(name, email, count)
      # Simulate a long-running task
      puts "Performing work for #{name} with sending an email to newly created user #{email}"
      UserMailer.user_created(name, email).deliver_now
      sleep(count)
      puts "Email sent for #{name}"
    end
  end
  