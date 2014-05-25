#
# TODO
#
module Puppet
  newtype(:file_fragment) do
    @doc = "TODO"

    newparam(:name, :namevar => true) do
      desc "Unique name of the puppet resource"
    end

    newparam(:path) do
      desc "To which file_concat this fragment belongs to (or use the +tag+ feature)."
    end

    newparam(:content) do
      desc "Content of the fragment."
    end

    newparam(:source) do
      desc "Source of the fragment."
    end

    newparam(:order) do
      desc "Where to put this fragment in relation to other fragments."

      defaultto '10'

      validate do |val|
        fail Puppet::ParseError "only integers > 0 are allowed and not '#{val}'" if val !~ /^\d+$/
      end

    end

    validate do
      # Check if either source or content is set. raise error if none is set
      fail Puppet::ParseError, "Set either 'source' or 'content'" if value(:source).nil? && value(:content).nil?

      # Check if both are set, if so raise an error
      fail Puppet::ParseError, "Can't use 'source' and 'content' at the same time" if !value(:source).nil? && !value(:content).nil?
    end

  end
end
