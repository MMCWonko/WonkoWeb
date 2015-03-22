node :uid do
    @wonko_file.uid
end

object @wonko_version
attribute :version, :type, :time, :requires
node :data do |d|
    WonkoVersion.unclean_keys(d.data)
end