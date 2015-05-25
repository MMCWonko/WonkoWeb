object @wonko_file
node(:formatVersion) { 0 }
attribute :uid, :name
child :wonkoversions => :versions do
    attribute :version, :type, :type, :requires
end
