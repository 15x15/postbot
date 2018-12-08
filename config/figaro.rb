require 'figaro'

Figaro.application = Figaro::Application.new(path: 'config/secrets.yml')
Figaro.load
