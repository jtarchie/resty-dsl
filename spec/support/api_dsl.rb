require 'tempfile'
require 'rest_client'

module ApiDSL
  def start_app(app)
    file = Tempfile.new('nginx.conf')
    file.write(app.to_s)
    file.close
    Dir.mkdir(File.join(File.dirname(file.path), "logs")) rescue nil
    `pkill nginx; nginx -p #{File.dirname(file.path)} -c #{File.basename(file.path)}`
  end

  def get(uri)
    start_app(app)
    @response ||= begin
                    RestClient.get("http://localhost:9979#{uri}")
                  rescue RestClient::ResourceNotFound => e
                    e.response
                  end
  end

  def status
    @response.code
  end

  def content_type
    @response.headers[:content_type]
  end

  def body
    @response.to_str
  end
end
