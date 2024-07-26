# Use the official Ruby image from the Docker Hub
FROM ruby:2.7

# Set environment variables
ENV LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    RAILS_ENV=production

# Set the working directory
WORKDIR /api

# Install necessary dependencies
RUN apt-get update -qq && apt-get install -y \
    nodejs yarn default-mysql-client \
    build-essential \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the Gemfile and Gemfile.lock
COPY Gemfile /api/Gemfile
COPY Gemfile.lock /api/Gemfile.lock

# Install the gems
RUN bundle install

# Copy the rest of the application code
COPY . /api

# Expose port 3000 to the Docker host, so we can access it from the outside
EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
