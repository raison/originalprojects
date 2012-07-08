module Regex
    REGEX_EMAIL = /^([-\w+.]+)@(([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})|(([-\w]+\.)+[a-zA-Z]{2,4}))$/
    REGEX_PHONE = /^(?:1[ ]?[-.]?[ ]?)?(\((\d{3})\)|(\d{3}))[-. ]?(\d{3})[-.]?(\d{4})[ ]*([^\s\d].{0,9})?$/

    module_function

    # Formats a phone number
    def format_phone phone_string, sep = '-'
      a = parse_phone(phone_string)
      raise "invalid phone number" if !a
      "#{a[0]}#{sep}#{a[1]}#{sep}#{a[2]}#{a[3] ? ' '+a[3] : ''}"
    end

    # Returns area code, exchange, number, extension
    def parse_phone(phone_string)
      if phone_string =~ REGEX_PHONE
        if $2
          area_code = $2
        else
          area_code = $3
        end
        exchange = $4
        number = $5
        extension = $6
        return area_code, exchange, number, extension
      else
        return nil
      end
    end

end
