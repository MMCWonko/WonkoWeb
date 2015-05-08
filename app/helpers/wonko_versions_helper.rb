module WonkoVersionsHelper
  def can_copy(version)
    policy(version).show? && policy(WonkoVersion).create? &&
      version.wonko_file.wonkoversions.where(user: current_user, version: version.version).empty?
  end

  def own(version)
    WonkoVersion.get(version.wonko_file, version.version, current_user)
  end

  def show_go_to_mine(version)
    current_user && !own(version).nil? && version.user != current_user
  end
end
