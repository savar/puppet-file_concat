Puppet::Type.type(:file_concat).provide(:ruby, :parent => Puppet::Type.type(:file).provider(:posix)) do

  def exists?
    resource.stat ? true : false
  end

  def create
    send("content=", resource.should_content)
  end

  def destroy
    File.unlink(resource[:path]) if exists?
  end

  def content
    actual = File.read(resource[:path]) rescue nil
    (actual == resource.should_content) ? "\0PLEASEMANAGE\0" : actual
  end
#
  def content=(value)
    File.open(resource[:path], 'w') do |fh|
      fh.print resource.should_content
    end
  end
end
