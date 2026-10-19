# Resque connection. The URL (including any password) comes from the
# environment so credentials stay out of the repository.
Resque.redis = ENV.fetch('REDIS_URL', 'redis://localhost:6379/')
