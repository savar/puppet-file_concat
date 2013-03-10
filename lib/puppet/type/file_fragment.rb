#
# TODO
#
module Puppet
  newtype(:file_fragment) do
    @doc = "TODO"

    newparam(:name, :namevar => true) do
      desc "TODO"
    end

    newparam(:target) do
      desc "Deprecated. Use *path* instead."
    end

    newparam(:path) do
      desc "TODO"

      defaultto do
	resource.value(:target)
      end
    end

    newparam(:content) do
      desc "TODO"
    end

    newparam(:source) do
      desc "Source"
    end

    newparam(:order) do
      desc "TODO"

      defaultto '10'

      validate do |val|
        fail Puppet::ParseError "only integers > 0 are allowed and not '#{val}'" if val !~ /^\d+$/
      end

    end

    validate do

      # Check if either source or content is set. raise error if none is set
      self.fail Puppet::ParseError, "Set either 'source' or 'content'" if self[:source].nil? && self[:content].nil?

      # Check if both are set, if so rais error
      self.fail Puppet::ParseError, "Can't use 'source' and 'content' at the same time" if !self[:source].nil? && !self[:content].nil?

    end

  end
end
