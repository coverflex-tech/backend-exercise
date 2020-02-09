
ORIGINS = YAML.load_file(Rails.root.join('config','cors.yml'))[Rails.env]

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ORIGINS["host"]    
    
    resource '*',
      headers: :any,
      credentials: true,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end