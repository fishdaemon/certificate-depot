require 'openssl'

class CertificateDepot
  autoload :Runner, 'certificate_depot/runner'
  
  def initialize(path)
    config_filename = File.join(path, 'openssl.cnf')
    @config = OpenSSL::Config.load(config_filename)
  end
  
  def label
    @config['ca']['default_ca']
  end
  
  def self.create(path, label)
    FileUtils.mkdir_p(path)
    File.open(openssl_config_path(path), 'w') do |file|
      file.write("# Generated by Certificate Depot
[ ca ]
default_ca     = #{label}

[ #{label} ]
dir            = #{path}")
    end
    
    new(path)
  end
  
  def self.run(argv)
    runner = ::CertificateDepot::Runner.new(argv)
    runner.run
    runner
  end
  
  def self.openssl_config_path(path)
    File.join(path, 'openssl.cnf')
  end
end