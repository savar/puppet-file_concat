#
# TODO
#
module Puppet
  newtype(:file_fragment) do
    @doc = "TODO"

    ensurable

    def exists?
      true
    end

    newparam(:name, :namevar => true) do
      desc "TODO"
    end

    newparam(:path) do
      desc "TODO"
    end

    newparam(:content) do
      desc "TODO"
    end
  end
end
