ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "whiteapple.com",
    :user_name => "sanjusoftware",
    :password => "sanjusadhna",
    :authentication => "plain",
    :enable_starttls_auto => true
}