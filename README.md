# README

# Brine Task

### Prerequisites

- **Ruby Version**: 3.2.0
- **Rails Version**: 7.2.0.alpha (or Rails 7.1+)
  (Be careful while changing the version logs)

Follow this guide to change versions: [Upgrading Ruby on Rails](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html)

## Getting Started


Make sure you have PostgreSQL running on your local system. Configure the following environment variables in a `.env` file at the project root:

```dotenv
POSTGRES_USER=add postgres username
POSTGRES_PASSWORD=add postgres password
POSTGRES_DB=brine_demo_development
POSTGRES_HOST=db
RAILS_ENV=development
```

Install Redis

You can install Redis using Homebrew:

```bash
brew install redis
```

# Running with Docker Compose

Try running the project using the Docker Compose file provided in the brine_demo directory:

```bash
docker-compose build
docker-compose up
```

# If Docker Compose is not working, you can follow these alternative commands:

```bash
cd brine_demo
bundle install
rails db:prepare
```

In another terminal, start Redis:

```bash
brew services start redis
# or
redis-server

```

In another terminal, start Sidekiq:

```bash
bundle exec sidekiq
```

Start rails server
```bash 
rails s
```

# Email Service Configuration

To configure the email service, add your credentials to config/development.rb:

```ruby
config.action_mailer.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  user_name: 'yourmail@gmail.com',
  password: 'your_password',
  authentication: 'plain',
  enable_starttls_auto: true
}
```
- Replace 'yourmail@gmail.com' and 'your_password' with your actual email credentials.
- Replace mail id in 'app/mailers/user_mailer.rb'