#
# TODO
#

require 'puppet/type/file'
require 'puppet/type/file/owner'
require 'puppet/type/file/group'
require 'puppet/type/file/mode'
require 'puppet/util/checksums'

module Puppet
  newtype(:file_concat) do
    @doc = "TODO"

    ensurable

    # the file/posix provider will check for the :links property
    # which does not exist
    def [](value)
      if value == :links
        return false
      end

      super
    end

    newparam(:path, :namevar => true) do
      desc "An arbitrary tag for your own reference; the name of the message."
    end

    newproperty(:owner, :parent => Puppet::Type::File::Owner) do
      desc "Desired file owner."
    end

    newproperty(:group, :parent => Puppet::Type::File::Group) do
      desc "Desired file group."
    end

    newproperty(:mode, :parent => Puppet::Type::File::Mode) do
      desc "Desired file mode."
    end

    newproperty(:content) do
      desc "Read only attribute. Represents the content."

      include Puppet::Util::Diff
      include Puppet::Util::Checksums

      defaultto do
        # only be executed if no :content is set
        @content_default = true
        "\0PLEASEMANAGE\0"
      end

      validate do |val|
        fail "read-only attribute" if !@content_default
      end

      def insync?(is)
        result = super

        if ! result
          string_file_diff(@resource[:path], @resource.should_content)
        end

        result
      end

      def is_to_s(value)
        md5(value)
      end

      def should_to_s(value)
        md5(value)
      end
    end

    def should_content
      return @generated_content if @generated_content
      @generated_content = ""
      catalog.resources.select do |r|
        r.is_a?(Puppet::Type.type(:file_fragment)) && r[:path] == self[:path]
      end.each do |r|
        @generated_content += r[:content]
      end
      @generated_content
    end

    def stat
      return @stat if @stat
      @stat = begin
        ::File.stat(self[:path])
      rescue Errno::ENOENT => error
        nil
      rescue Errno::EACCES => error
        warning "Could not stat; permission denied"
        nil
      end
    end
  end
end
