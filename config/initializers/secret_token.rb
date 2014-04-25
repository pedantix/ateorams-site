module SecretToken
  def self.generic_secure_token
    token_file_url = %Q|#{Rails.root}/.secret|
    if File.exist?(token_file_url)
      File.read(token_file_url).chomp
    else
      new_token = SecureRandom.hex(64)
      File.write(token_file_url, new_token)
      new_token
    end
  end
end

Ateorams::Application.config.secret_key_base = SecretToken.generic_secure_token