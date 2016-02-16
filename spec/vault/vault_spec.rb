require 'docker'
require 'serverspec'

describe "Vault" do
  image = Docker::Image.build_from_dir('.')

  set :os, family: :alpine
  set :backend, :docker
  set :docker_image, image.id

  it "installs the right version of Vault" do
    expect(vault_version).to include("0.5.0")
  end

  def vault_version
    command("/bin/vault version").stdout
  end

end
