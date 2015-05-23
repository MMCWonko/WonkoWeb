module JsonErrorSerializer
  def self.serialize(errors, options = {})
    return if errors.nil?

    default_status = options[:default_status] || 500
    href_base = options[:href_base]
    default_meta = options[:default_meta]

    new_hash = errors.map do |k, v|
      (v.is_a?(Array) ? v : [v]).map do |msg|
        msg = { title: msg } unless msg.is_a? Hash
        create_error_object k, msg, default_status, href_base, default_meta
      end
    end.flatten

    { errors: new_hash }
  end

  def self.common_status_code(errors)
    code = nil
    errors[:errors].each do |error|
      c = error[:status]
      next if c.nil?

      code = select_code code, c
    end

    code
  end

  private

  def self.create_error_object(id, msg, default_status, href_base, default_meta)
    obj = {
      id: id,
      title: msg[:title]
    }
    obj[:status] = Rack::Utils.status_code(msg[:status] || default_status.to_s)
    obj[:source] = msg[:source]
    obj[:href] = href_for_message msg, href_base
    obj[:detail] = msg[:detail]
    obj[:meta] = msg[:meta] || default_meta
    obj.delete_if { |_k, v| v.nil? }
  end

  def self.href_for_message(msg, href_base)
    return msg[:href] if msg[:href]
    return href_base + msg[:code].to_s if href_base && msg[:code]
  end

  def self.select_code(old, new)
    old_is_client_error = code_is_client_error old

    if old.nil?
      new
    elsif old_is_client_error && new >= 500 # server error overrides client error
      new
    elsif old_is_client_error && [401, 403].include?(c) # unauthorized or forbidden override other client errors
      new
    elsif old_is_client_error && code_is_client_error(new) && old != new # both client error but not the same
      400
    end # else: either same or `old` is a server error and `new` is not
  end

  def self.code_is_client_error(code)
    !code.nil? && code >= 400 && code < 500
  end
end
