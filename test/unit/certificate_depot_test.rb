require File.expand_path('../../test_helper', __FILE__)

describe "CertificateDepot" do
  it "creates a new depot" do
    CertificateDepot.create(temporary_directory, 'Certificate Depot Test')
    
    # Creates all directories
    File.should.exist(temporary_directory)
    %w(private certificates new-certificates crl).each do |directory|
      File.should.exist(File.join(temporary_directory, directory))
    end
    
    # Creates configuration and all database files
    File.size(File.join(temporary_directory, 'openssl.cnf')).should > 0
    File.size(File.join(temporary_directory, 'index.txt')).should == 0
    File.size(File.join(temporary_directory, 'serial')).should > 0
    
    # Creates a key and self-signed certificate
    File.size(File.join(temporary_directory, 'private/ca.key')).should > 0
    File.size(File.join(temporary_directory, 'certificates/ca.crt')).should > 0
  end
end

describe "A CertificateDepot" do
  before do
    @depot = CertificateDepot.create(temporary_directory, 'Certificate Depot Test')
  end
  
  it "has a label" do
    @depot.label.should == 'Certificate Depot Test'
  end
end